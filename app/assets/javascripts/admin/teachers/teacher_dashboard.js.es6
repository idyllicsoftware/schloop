// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self
//= base
class TeacherDashboard extends SchloopBase {
    init (){
    	let {action} = this._config,
        	_self = this,
            params = {teacher_id: this._config.teacher_id};

        _self.popoverInit(true);
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        var _self = this;
            _self.filters = {};

            _self.InitDocument();
        
        $("#select-filter-tag-popover").on('shown.bs.popover', function () {
            var popoverEl = $('#' + $(this).attr('aria-describedby')),
                selected_subject = $('.grade-selection').find('.select-grade-subject').find('li > input');   
            
                popoverEl.find('input[type=radio]').change( function() {
                    var curr_sub_val = $(this).val(),
                        curr_sub_name = $(this).parent().find('label').html(),
                        curr_grade_name = $(this).closest('div').find('label').html(),
                        curr_grade_val = $(this).closest('div').find('label').data('grade_id');
                    
                   $('.select-filter-tag-section a').text(curr_grade_name + ' | ' + curr_sub_name);
                    _self.filters = {
                        'grade_id' : curr_grade_val,
                        'subject_id' : curr_sub_val,
                        'subject_name' : curr_sub_name,
                        'grade_name' : curr_grade_name
                    }
                    _self.loadMyTopics();

                     popoverEl.popover('hide');
                });

                selected_subject.each( function () {
                    var val = $(this).val();
                    if( _self.filters.subject_id === val) {
                        $(this).attr('checked','checked');
                    }
                });    
        });           
    };

    InitDocument () {
        var _self = this,
            addTopicModalEl = $('#add-topic-modal');

        $(document).ready( function () {
            var grade_filter_name = $('.select-filter-tag-section label:first').html(),
                subject_filter_name = $('.select-filter-tag-section li >label:first').html(),
                grade_filter_val = $('.select-filter-tag-section label:first').data('grade_id'),
                subject_filter_val = $('.select-filter-tag-section li input').val();
                
            $('.select-filter-tag-section a').text(grade_filter_name + ' | ' + subject_filter_name);

             _self.filters = {
                        'grade_id' : grade_filter_val,
                        'subject_id' : subject_filter_val,
                        'grade_name' : grade_filter_name,
                        'subject_name' : subject_filter_name
                    }
                    _self.loadMyTopics();
                
            var max_topic_content_lenght = $('.content-view-section').find('p').text().length;
                if (max_topic_content_lenght > 200){
                    var trimmedString = $('.content-view-section').find('p').text().substring(0, 200);
                    $('.content-view-section').find('p').text(trimmedString);
                    $('.content-view-section').find('p').append("<a class='read-more'> More...</a>");
                }        
        });

        $('div[contenteditable=true]').on('focusin', function() {
            $('div[contenteditable=true]').parent().css('border','1px solid #25aae1');
            $('div[contenteditable=true]').parent().find('button').css('color','#25aae1');
        });
        $('div[contenteditable=true]').on('focusout', function() {
            $('div[contenteditable=true]').parent().css('border','1px solid #ccc');
            $('div[contenteditable=true]').parent().find('button').css('color','#dddddd');
        });
        
        $(document).on('click','.add-topic', function () {
            var add_topic_form = $('.add-topic-form');
            addTopicModalEl.modal('show');
            add_topic_form[0].reset();
            addTopicModalEl.find('label').replaceWith('<label>' + _self.filters.grade_name + ' - ' + _self.filters.subject_name + ' | Add New Topic</label>');        
            
            $('.add-topic-btn').on('click', function () {
                var key_value = add_topic_form.serializeObject(),
                    topic_data = {};
                
                var fun = function jsonConcat(o1, o2) {
                                for (var key in o2) {
                                    o1[key] = o2[key];
                                }
                             return o1;
                            }

                topic_data = fun(topic_data, _self.filters);
                topic_data = fun (topic_data, key_value); 

                $.ajax({
                    url: `/admin/teachers/dashboards/add_topic`,
                    data: topic_data,
                    method: 'POST',
                    success: function (res) {
                       if(res.success) {
                           _self.loadMyTopics();
                            addTopicModalEl.modal('hide');
                       }
                    }
                });
            });
        });
    };

    loadMyTopics(){
        let _self = this;
        
        $.ajax({
                url: `/admin/teachers/dashboards/get_topics`,
                data: _self.filters,
                success: function (res) {
                   if(res.success) {
                        if(res.topics.length !== 0) {
                           var topics_hash = res.topics.toHash('id');
                           var topics_list_tag = [];

                           for(var topic in  topics_hash) {
                                var li_tag = '<li><a href="#">' + topics_hash[topic].title + '</a></li>';
                                topics_list_tag.push(li_tag);
                           }

                           $('.topics-list').replaceWith('<ul class="nav nav-sidebar topics-list">' + topics_list_tag.join(' ') + '</u>'); 
                        } else {
                            $('.topics-list').empty();
                        }    
                   }
                }
        });
    };
}