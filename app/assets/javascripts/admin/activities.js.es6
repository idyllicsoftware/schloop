
class Activities extends SchloopBase {
    init (){
        let _self = this;

        _self.initEventListeners();
        _self.filters = {};
        return this;
    };

    get activitiesListTpl (){
        return $('#content_list_tpl').html();
    }

    initEventListeners(){
        let _self = this,
            createWebContentModal = $('#create-web-content-modal'),
            jForm = createWebContentModal.find('#activity_creation_form'),
            thumbnail_file_upload, reference_file_upload;

        $('#select_multiple').multipleSelect({});


        $("#content_filter_wrapper select").change(function(){
            _self.filters = $(this).closest('form').serializeObject();
            _self.loadActivities();
        });


        thumbnail_file_upload = new FileUpload({
            jScope: createWebContentModal.find("#thumbnailImageUploadSection"),
            isImageUpload: true
        });

        reference_file_upload = new FileUpload({
            jScope: createWebContentModal.find("#referenceImageUploadSection"),
            isImageUpload: true
        });

        $(document).on('click','.web-content-creation-link', function () {
            thumbnail_file_upload.resetForm();
            reference_file_upload.resetForm();
            createWebContentModal.modal('show');
            jForm[0].reset();
            jForm.attr('action', `/admin/activities`);
            jForm.attr('method', 'POST');
            jForm.find('input[name], select, textarea').removeAttr('disabled');
            jForm.find('.ms-drop >ul >li >label >input').each(function(){
                var inEl = $(this);
                    inEl.parents().eq(1).removeClass('selected');
                    inEl.removeAttr('disabled');
                    inEl.parents().eq(4).find('.placeholder').empty();       
            });    
            createWebContentModal.find('.action-btn').show();
            createWebContentModal.find('.file_upload_files--upload-block').show();
            createWebContentModal.find('.image-attach img').remove();
            createWebContentModal.find('.close-form').addClass('hidden');
            createWebContentModal.find('label.error').addClass('hidden');
        });

        _self.initForm(jForm, null, $("#activitySubmit"));
        createWebContentModal.find("#activitySubmit").on('click', function () {
            createWebContentModal.find('label.error').removeClass('hidden');
            if(!createWebContentModal.find(".activity_id_hidden_input").val()) {
                jForm.submit();
            }else {
                createWebContentModal.find("#activitySubmit").attr('disabled', 'disabled');
                createWebContentModal.find(".uploadBtn").trigger('click');
            }
        });

        createWebContentModal.on('hide.bs.modal', function () {
            thumbnail_file_upload.resetForm();
            reference_file_upload.resetForm();
            createWebContentModal.find(".activity_id_hidden_input").val(null);
            createWebContentModal.find("#activitySubmit").removeAttr('disabled');
            createWebContentModal.find(".selected_files").html('');
        });

        $(document).on("uploadedFileResponse", function (event, res) {
            if(res.result.success) {
                if (createWebContentModal.find("button.delete[disabled]").length == createWebContentModal.find("button.delete").length) {
                    createWebContentModal.modal('hide');
                    _self.loadActivities();
                }
            }else {
                createWebContentModal.find("#activitySubmit").removeAttr('disabled');
            }
        });


        $(document).on('click', '.deactivate_activity', function(){
            var el = $(this),
                activity_id = el.data('activity-id');

            swal({
                    title: "Are you sure?",
                    text: "You want deactivate this Activity",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes, deactivate it!"
                },
                function(){
                    $.ajax({
                        url: '/admin/activities/'+activity_id+'/deactivate',
                        method: 'PUT',
                        success: function (res) {
                            if(res.success){
                                toastr.success('Activity deactivated successfully');
                                el.removeClass('deactivate_activity').addClass('disabled').html("Deactivated");
                            } else {
                                _self.showErrors(res.errors);
                            }
                        },
                        error: function () {
                            swal({title: "Oops!", text: "Something went wrong. Please try later.", type: "error", confirmButtonText: "OK" });
                        }
                    });
                });
        });

        _self.loadActivities();

    };

    getProcessedData(res){
        let {activities} = res;
        if(activities && activities.length){
            activities.forEach(function (item) {
                item.categories = item.categories.join(' | ');
            });
        }

        return {
            activities: activities || []
        };
    };

    loadActivities(){
        let _self = this, html = '',
            activitiesListEl = $('#content_list_id');
            
        $.ajax({
            url: `/admin/activities/all`,
            data: _self.filters,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.activitiesListTpl, _self.getProcessedData(res));
                }
                _self.Activities = res.activities.toHash('id');
                activitiesListEl.html(html);   

                activitiesListEl.find('.activity-preview').on('click', function() {
                    let curr_pre_El = $(this),
                        activity_id = curr_pre_El.data('activity-id'),
                        createWebContentModal = $('#create-web-content-modal'),
                        //    activityPreviewModal = $('#activity-preview-modal'),

                        jForm = createWebContentModal.find('#activity_creation_form');
                        createWebContentModal.modal('show');
                        // if(_self.Activities.hasOwnProperty(activity_id)){
                        //     var activity_data =  _self.Activities[activity_id];
                        //     html = Mustache.to_html(_self.activitiesPreviewTpl, activity_data);
                        // }
                        //activityPreviewModal.modal('show');
                        
                         if(_self.Activities.hasOwnProperty(activity_id)){
                            var activity_data =  _self.Activities[activity_id],
                                thumb_img_url = activity_data.thumbnail_file.s3_url,ref_img_list = [];    
                            jForm.fillForm(_self.Activities[activity_id], 'activity');
                            jForm.find('input[name], select, textarea').attr('disabled', 'disabled');
                            jForm.find('.ms-drop >ul >li >label >input').each(function(){
                                var inEl = $(this),
                                    inEl_val = inEl.val();
                                activity_data.category_ids.forEach(function(category){
                                    if(inEl_val == category){
                                        inEl.parents().eq(1).addClass('selected');
                                    }
                                });
                                activity_data.categories.split("|").forEach(function(category_name){
                                    var this_El = $(this);
                                    inEl.parents().eq(4).find('.placeholder').append(category_name + ',');
                                }); 
                                inEl.attr('disabled', 'disabled');       
                            });
                            createWebContentModal.find('.thumb_img').append('<img src="'+ thumb_img_url +'" style="width:200px; margin-bottom: 20px;">');
                            activity_data.reference_files.forEach(function(ref_img){
                                var ref_img_url = ref_img.s3_url,
                                    ref_img_tag = '<li><img src="'+ ref_img_url +'" style="width:200px"></li>';
                                    ref_img_list.push(ref_img_tag);
                            });
                            createWebContentModal.find('.ref_img').append('<ul style="padding: 0px; list-style: none;">'+ ref_img_list.join("") +'</ul>');
                            createWebContentModal.find('.action-btn').hide();
                            createWebContentModal.find('.file_upload_files--upload-block').hide();
                            createWebContentModal.find('.close-form').removeClass('hidden');
                            createWebContentModal.find('.close-form').on('click',function(){
                                createWebContentModal.modal('hide');
                            });
                        }    
                });
            }
        });
    };

    initForm (jForm, activity_id, btnEl){
        let _self = this,
            createWebContentModal = $('#create-web-content-modal'),
            msg = activity_id ? 'Activity updated successfully' : 'Activity added successfully';

        this.initFormSubmit(jForm, {
            'activity[topic]': 'name',
            'activity[title]': 'name'
        }, function (res) {
            if(res.errors && res.errors.length) {
                _self.showErrors(res.errors);
            }else {
                createWebContentModal.find(".activity_id_hidden_input").val(res.activity_id);
                if(createWebContentModal.find(".selected_files tr").length){
                    btnEl.attr('disabled', 'disabled');
                    createWebContentModal.find(".uploadBtn").trigger('click');
                }else {
                    toastr.success(msg);
                    createWebContentModal.modal('hide');
                    _self.loadActivities();
                }
            }
        }, null, btnEl);
    };
}
