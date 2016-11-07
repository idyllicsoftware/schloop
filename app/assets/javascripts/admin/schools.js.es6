//= require_self
//= require admin/school_profiles

class Schools extends SchloopBase {
    init (){
        let {action} = this._config;
        if(action == 'index'){
            this.initDashboard();
        }else if(action == 'show'){
            this._schoolProfile = new SchoolProfiles(this._config);
        }
        return this;
    };

    initDashboard () {
        let self = this,
            createSchoolFormEl = $(".schools-registration-form"),
            createModalEl = $("#create-school-modal");

        $(document).on('click','#create-school-btn', function () {
            createModalEl.modal('show');
        });

        self.loadSchools();

        this.initFormSubmit(createSchoolFormEl, {
            'school[name]': 'name',
            'school[board]': 'name',
            'school[address]': 'name',
            'school[zip_code]': 'zip_code',
            'school[phone1]': 'phone',
            'school[website]': 'website',
            'administrator[first_name]': 'name',
            'administrator[last_name]': 'name',
            'administrator[cell_number]': 'phone',
            'administrator[email]': 'email',
        }, function (res) {
            if(res.success) {
                createSchoolFormEl[0].reset();
                createModalEl.modal('hide');
                self.loadSchools();
                toastr.success('School created successfully');
            }else {
                self.showErrors(res.errors);
            }
        });

        $(document).on('click','.cancel-creation', function () {
            createModalEl.modal('hide');
        });

    };

    get schoolListTpl (){
        return $('#schools_list_tpl').html();
    }

    loadSchools (){
        let self = this, html = '',
            schoolsContainerEl = $("#schoolsContainer");
        $.ajax({
            url: '/admin/schools/all',
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(self.schoolListTpl, res);
                }
                schoolsContainerEl.html(html);
            }
        });
    }
}