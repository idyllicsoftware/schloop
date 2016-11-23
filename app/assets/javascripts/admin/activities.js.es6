
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