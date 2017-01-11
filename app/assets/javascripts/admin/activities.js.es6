

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
            createWebContentModal.find('label.error').addClass('hidden');
            createWebContentModal.find('.ms-choice >span').empty();
            jForm.find('.ms-drop >ul >li >label >input').each(function(){
                var inEl = $(this);
                    inEl.parents().eq(1).removeClass('selected');
                    inEl.removeAttr('disabled');
                    inEl.parents().closest('div').find('.placeholder').empty();
            });
        });
    
        $(document).on('click','.close-activity-form', function () {
            createWebContentModal.modal('hide');
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
                                toastr.success('Activity deactivated successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                                });
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
            activitiesListEl = $('#content_list_id'),
            activityPreviewModal = $('#activity-preview-modal'),
            detailTpl = $("#activity-preview-detail-tpl").html();
            
        $.ajax({
            url: `/admin/activities/all`,
            data: _self.filters,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.activitiesListTpl, _self.getProcessedData(res));
                }
                _self.Activities = res.activities.toHash('id');
                activitiesListEl.html(html);   
            
                $(document).on('click','.activity-preview', function() {
                    let {activityId} = $(this).data();
                      
                    if(_self.Activities.hasOwnProperty(activityId)) {    
                        activityPreviewModal.modal('show');
            
                        html = Mustache.to_html(detailTpl, {
                            activity: _self.Activities[activityId],
                            category: function() {
                                var cat = [], cat_html = '';
                                this.categories.split('|').forEach(function(category) {
                                    cat_html = category ;
                                    cat.push({name: cat_html});
                                });
                                return cat;
                            },
                            attachment: function() {
                                var att = [],html = '',html_url = '';
                                this.reference_files.forEach(function(attachment) {
                                    html = attachment.original_filename;
                                    html_url = attachment.s3_url
                                    att.push({original_filename: html, s3_url: html_url});
                                });
                                return att;
                            },
                        });
                    }
                    activityPreviewModal.find('.modal-body').html(html);
                });

                $(document).on('click','.close-form', function(){
                    activityPreviewModal.modal('hide');
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
                    toastr.success(msg, '', {
                        positionClass: 'toast-top-right cloud-display'
                    });
                    createWebContentModal.modal('hide');
                    _self.loadActivities();
                }
            }
        }, null, btnEl);
    };
}
