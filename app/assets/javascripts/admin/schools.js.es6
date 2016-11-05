//= require_self
//= require admin/school_profiles

class Schools extends SchloopBase {
    init (){
        let {action} = this._config;
        if(action == 'index'){
            this.initDashboard();
        }else if(action == 'show'){
            this._schoolProfile = new SchoolProfiles();
        }
        return this;
    };

    initDashboard () {
        let self = this,
            createSchoolFormEl = $(".schools-registraion-form"),
            createModalEl = $("#create-school-modal");

        $(document).on('click','#create-school-btn', function () {
            createModalEl.modal('show');
        });

        $(".data-title").click( function () {
            $(".slide-division-wrapper").slideToggle();
        });

        this.initFormSubmit(createSchoolFormEl, {
            'school[name]': 'name',
            'school[board]': 'name',
            'school[address]': 'name',
            'school[zip_code]': 'zip_code',
            'school[phone1]': 'phone',
            'administrator[first_name]': 'name',
            'administrator[last_name]': 'name',
            'administrator[phone]': 'phone',
            'administrator[email]': 'email',
        }, function (res) {
            if(res.success) {
                createSchoolFormEl[0].reset();
                createModalEl.modal('hide');
                toastr.success('School created successfully');
            }else {
                let msg = res.errors.join("<br/> ") || "Something went wrong. Please try later."
                swal({title: "Oops!",   text: msg,   html:true, type: "error",   confirmButtonText: "OK" });
            }
        });


        $(document).on('click','.cancel-creation', function () {
            createModalEl.modal('hide');
        });

    }
}