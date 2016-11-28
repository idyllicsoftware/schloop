
class Activities extends SchloopBase {
    init (){
        let _self = this;

        _self.initEventListeners();
        return this;
    };

    get activitiesListTpl (){
        return $('#content_list_tpl').html();
    }

    initEventListeners(){
        let _self = this,
            createWebContentModal = $('#create-web-content-modal'),
            jForm = createWebContentModal.find('#activity_creation_form'),
            file_upload;

        $('#select_multiple').multipleSelect({});

        file_upload = new FileUpload({
            jScope: createWebContentModal,
            isImageUpload: true
        });

        $(document).on('click','.web-content-creation-link', function () {
            file_upload.resetForm();
            createWebContentModal.modal('show');
            jForm[0].reset();
            jForm.attr('action', `/admin/activities`);
            jForm.attr('method', 'POST');
        });
        _self.initForm(jForm, null, $("#activitySubmit"));
        createWebContentModal.find("#activitySubmit").on('click', function () {
            if(!createWebContentModal.find("#activity_id").val()) {
                jForm.submit();
            }else {
                createWebContentModal.find("#activitySubmit").attr('disabled', 'disabled');
                createWebContentModal.find(".uploadBtn").trigger('click');
            }
        });

        createWebContentModal.on('hide.bs.popover', function () {
            file_upload.resetForm();
            createWebContentModal.find("#activity_id").val(null);
            createWebContentModal.find("#activitySubmit").removeAttr('disabled');
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
    }

    loadActivities(){
        let _self = this, html = '',
            activitiesListEl = $('#content_list_id');
        $.ajax({
            url: `/admin/activities/all`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.activitiesListTpl, _self.getProcessedData(res));
                }
                activitiesListEl.html(html);
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
                createWebContentModal.find("#activity_id").val(res.activity_id);
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