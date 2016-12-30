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

        $(document).on("click", ".topics-list li", function(e) {
            var topic_hash = {},
                key_value = $(this).find('span').data('topic_id'),
                topic_id_tag = {
                    'topic_id' : key_value
                };
            e.preventDefault();
            _self.topic_hash = $.extend(_self.filters, topic_id_tag);
            $(".topics-list").find(".active").removeClass("active");
            $(this).addClass("active");
            _self.loadTopicBookmarks();
            _self.addTopicContent();
        });

        $(document).on('click','.save-caption', function(e) {
            let bookmarkId = $(this).data('bookmark_id'),
                jForm = $(this).closest('div').parent();
            
            e.preventDefault();
            $.ajax({
                url: `/admin/teachers/bookmarks/add_caption`,
                method: 'POST',
                data: jForm.serializeObject(),
                success: function (res) {
                    if(res.success) {
                        jForm.replaceWith('<p>'+ res.caption +'</p>');
                        toastr.success('Caption added successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                            });      
                    } else {
                        _self.showErrors(res.errors);
                    }
                    
                }
            });   
        });
    
        $(document).on('click', '.bookmark-edit', function(e) {
            var bookmark_id = $(this).data('bookmark_id'),
                bookmarkEditModal = $('#bookmark-edit-modal'),
                jForm = bookmarkEditModal.find('form');

                e.preventDefault();
                bookmarkEditModal.modal('show');
                if(_self.topicBookmarks.hasOwnProperty(bookmark_id)){
                   var curr_bookmark = _self.topicBookmarks[bookmark_id];
                    jForm.fillForm(_self.topicBookmarks[bookmark_id], 'bookmark');
                    if(curr_bookmark.data){
                        jForm.find('.content-editor-update').html(curr_bookmark.data);
                    }else{
                        jForm.find('.content-editor-update').html(curr_bookmark.preview_image_url);
                    }
                    jForm.on('click', '.bookmark-edit-btn', function(e) {
                        var bmId = jForm.find('input[type=hidden][name="bookmark[id]"]').val();
                        e.preventDefault();
                        if (bmId == bookmark_id) {                            
                            _self.bookmarkEdit(jForm, bookmark_id);
                        }
                    });
                }
        });

    };

    InitDocument () {
        var _self = this,
            addTopicModalEl = $('#add-topic-modal');

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

        $('.content-editor-section > div[contenteditable=true]').on('focusin', function() {
            $('div[contenteditable=true]').parent().css('border','1px solid #25aae1');
            $('div[contenteditable=true]').parent().find('button').css('color','#25aae1');
        });
        $('.content-editor-section > div[contenteditable=true]').on('focusout', function() {
            $('div[contenteditable=true]').parent().css('border','1px solid #ccc');
            $('div[contenteditable=true]').parent().find('button').css('color','#dddddd');
        });
        _self.addTopic();
    };

    addTopic() {
        var _self = this,
            addTopicModalEl = $('#add-topic-modal');

        $(document).on('click','.add-topic', function () {
            var add_topic_form = $('.add-topic-form');
            addTopicModalEl.modal('show');
            add_topic_form[0].reset();
            addTopicModalEl.find('label').replaceWith('<label>' + _self.filters.grade_name + ' - ' + _self.filters.subject_name + ' | Add New Topic</label>');        
            
            $('.add-topic-btn').on('click', function () {
                var key_value = add_topic_form.serializeObject(),
                    topic_data = {};

                topic_data = $.extend(_self.filters, key_value); 

                $.ajax({
                    url: `/admin/teachers/topics`,
                    data: topic_data,
                    method: 'POST',
                    success: function (res) {
                        if(res.success) {
                            _self.loadMyTopics();
                            addTopicModalEl.modal('hide');
                            toastr.success('New topic added successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                            });      
                        } else {
                            _self.showErrors(res.errors);
                        }
                    }
                });
            });
        });
    };

    loadMyTopics(){
        let _self = this;
        
        $.ajax({
                url: `/admin/teachers/topics/get_topics`,
                data: _self.filters,
                success: function (res) {
                   if(res.success) {
                        if(res.topics.length !== 0) {
                           var topics_hash = res.topics.toHash('id');
                           var topics_list_tag = [];
                           
                           for(var topic in  topics_hash) {
                                var li_tag = '<li><span data-topic_id="' + topics_hash[topic].id + '">' + topics_hash[topic].title + '</span></li>';
                                topics_list_tag.push(li_tag);
                           }
                           
                           $('.topics-list').replaceWith('<ul class="nav nav-sidebar topics-list">' + topics_list_tag.join(' ') + '</u>');
                        
                            $('.topics-list li').eq(0).trigger('click'); 
                        } else {
                            $('.topics-list').empty();
                        }    
                   }
                }
        });
    };

    get topicBookmarksTpl (){
        return $("#topic_bookmarks_tpl").html();
    };

    loadTopicBookmarks() {
        let _self = this,
            filters_data = _self.topic_hash,
            bookmarksEl = $('.bookmarks-section'),
            bookmarkEditModal = $('#bookmark-edit-modal');
        $.ajax({
            url: `/admin/teachers/bookmarks/get_bookmarks`,
            data: filters_data,
            method: 'GET',
            success: function (res) {
                if(res.success) {
                    var html = Mustache.to_html(_self.topicBookmarksTpl, res);
                        _self.topicBookmarks = res.bookmarks.toHash('id');
                        bookmarksEl.html(html);
                        $("time.timeago").timeago();
                        
                        $('.input-form-group').on('focusin', function() {
                                $(this).css('border-bottom','1px solid #25aae1');
                                $(this).find('button').css('color','#25aae1');
                        });
                        $('.input-form-group').on('focusout', function() {
                            $(this).css('border-bottom','1px solid #ccc');
                            $(this).find('button').css('color','#dddddd');
                        });
            
                        bookmarksEl.find('.bookmark-delete').on('click', function() {
                            var curr_bookmark_El = $(this).closest('.topics-list-section'),
                                bookmark_id = $(this).data('bookmark_id');
                            
                            if(_self.topicBookmarks.hasOwnProperty(bookmark_id)){

                                $.ajax({
                                    url: "/admin/teachers/bookmarks/"+bookmark_id,
                                    method: "DELETE",
                                    success: function (res) {
                                       if(res.success) {
                                        curr_bookmark_El.remove();
                                         toastr.success('schloopmarked deleted successfully', '', {
                                                    positionClass: 'toast-top-right cloud-display'
                                                });      
                                       } else {
                                            _self.showErrors(res.errors);
                                       }
                                    }
                                });
                            }
                        });

                        bookmarksEl.find('.share-for-collaboration').on('click', function() {
                            var curr_Bm_id = $(this).data('bookmark_id'),
                                img_tag = $(this).find('img'),
                                span_tag = $(this).find('span'),
                                shared = $(this).hasClass('already-shared') ? false : true ;

                            if(_self.topicBookmarks.hasOwnProperty(curr_Bm_id) && shared){
                                swal({
                                        title: "Are you sure?",
                                        text: "You want share for collaboration",
                                        type: "info",
                                        showCancelButton: true,
                                        confirmButtonText: "Yes!"
                                    },
                                    function(isConfirm){
                                        if (isConfirm) {
                                            $.ajax({
                                                url: "/admin/teachers/collaborations?bookmark_id=" + curr_Bm_id,
                                                method: "POST",
                                                success: function (res) {
                                                   if(res.success) {
                                                    span_tag.html('Shared with teachers').css('color','#25aae1');
                                                    img_tag.replaceWith('<img src="/assets/admin/collaboration_fill.svg" >');
                                                     toastr.success('schloopmark collaborated successfully', '', {
                                                                positionClass: 'toast-top-right cloud-display'
                                                            });      
                                                   } else {
                                                        _self.showErrors(res.errors);
                                                   }
                                                }
                                            });
                                        }
                                });
                            }                
                        });

                        $(document).find('.share-for-collaboration').each(function(){
                            var thisEl = $(this),
                                img_tag = $(this).find('img'),
                                span_tag = $(this).find('span'),
                                bk_id = $(this).data('bookmark_id');
                            res.collaborated.forEach(function(co) {
                                 if(bk_id == co) {
                                    thisEl.addClass('already-shared');
                                    span_tag.html('Shared with teachers').css('color','#25aae1');
                                    img_tag.replaceWith('<img src="/assets/admin/collaboration_fill.svg" >');
                                 }
                            });
                        });
                } else {
                    _self.showErrors(res.errors);
                }
            }
        });
    };

    bookmarkEdit(jForm, bookmark_id) {
        let _self = this,
            bookmarkEditModal = $('#bookmark-edit-modal'),
            content_val = $('.content-editor-update').html().replace(new RegExp('<div><br></div>', 'g'), '').replace(new RegExp(' &nbsp;', 'g'), '').replace(new RegExp('&nbsp;', 'g'), ''),
            bookmarks_hash = {
                'datum' : content_val,
                'bookmark_id': bookmark_id
            },
            new_val = jForm.serializeObject(),
            formdata = $.extend(bookmarks_hash, new_val);
        
        $.ajax({
            url: "/admin/teachers/bookmarks/"+bookmark_id,
            data: formdata,
            method: "PATCH",
            success: function (res) {
               if(res.success) {
                _self.loadTopicBookmarks();
                bookmarkEditModal.modal('hide');
                 toastr.success('schloopmarked updated successfully', '', {
                            positionClass: 'toast-top-right cloud-display'
                        });      
               } else {
                    _self.showErrors(res.errors);
               }
            }
        });

        jForm.on('click', '.close-edit-modal', function() {
            bookmarkEditModal.modal('hide');
        });
    };

    addTopicContent() {
        let _self = this,
            add_topic_content_form = $('.add-topic-content-form'),
            content_editor = $('.content-editor');
        
            add_topic_content_form.off('click').on('click', '.add-topic-content-btn', function (e) {
                var content_val = content_editor.html().replace(new RegExp('<div><br></div>', 'g'), '').replace(new RegExp(' &nbsp;', 'g'), '').replace(new RegExp('&nbsp;', 'g'), ' '),
                    bookmarks_hash = {},
                    key_value = {
                        'datum' : content_val
                    };
                    e.preventDefault();
                bookmarks_hash = $.extend(_self.topic_hash, key_value);
                
                $.ajax({
                    url: "/admin/teachers/bookmarks",
                    data: bookmarks_hash,
                    method: "POST",
                    success: function (res) {
                       if(res.success) {
                        content_editor.html('');
                         _self.loadTopicBookmarks();
                         toastr.success('New schloopmarked added successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                                });      
                       } else {
                            _self.showErrors(res.errors);
                       }
                    }
                });
            });
    };
}