
class Activities extends SchloopBase {
    init (){
        let _self = this;

        _self.initEventListeners();
        return this;
    };

    initEventListeners(){
        let _self = this,
            jForm,
            createWebContentModal = $('#create-web-content-modal');

        $('#select_multiple').multipleSelect({});

        $(document).on('click','.web-content-creation-link', function () {
            createWebContentModal.modal('show');
            jForm = createWebContentModal.find('form');
            jForm[0].reset();
            jForm.attr('action', `/admin/activities`);
            jForm.attr('method', 'POST');
            _self.initForm(jForm);
        });

        _self.loadActivities();

    };

    loadActivities(){
        let _self = this, html = '';
        $.ajax({
            url: `/admin/activities/all`,
            success: function (res) {
                if(res.success) {

                }
            }
        });
    };

    initForm (jForm, activity_id){
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
                toastr.success(msg);
                createWebContentModal.modal('hide');
                _self.loadActivities();
            }
        });
    };
}