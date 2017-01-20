//= require_self
//= require admin/activities
//= require admin/school_profiles


class Schools extends SchloopBase {
    init (){
        let {action} = this._config;
        if(action == 'index'){
            this.initDashboard();
            this._activities = new Activities(this._config);
        }else if(action == 'show' || action == 'school'){
            this._schoolProfile = new SchoolProfiles(this._config);
        }
        return this;
    };

    initDashboard () {
        let self = this,
            createSchoolFormEl = $(".schools-registration-form"),
            createModalEl = $("#create-school-modal"),
            user_name = $('.user_name').html(),
            fname_char = user_name.split(' ')[0].charAt(0),
            lname_char = user_name.split(' ')[1].charAt(0),
            user_profile_name = fname_char + lname_char;
        
        $('.profile-photo').html(user_profile_name.toUpperCase());

        $(document).on('click','#create-school-btn', function () {
            createModalEl.modal('show');
            createModalEl.find('label.error').addClass('hidden');
        });

        $(document).on('click','.close-school-form', function () {
            createModalEl.modal('hide');
        });

        $(document).on('click','.add-school', function () {
            createModalEl.find('label.error').removeClass('hidden');
        });

        $(":file").change(function () {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = imageIsLoaded;
                reader.readAsDataURL(this.files[0]);
            }
        });

        function imageIsLoaded(e) {
            $('.upload-logo').css('background-image', 'url(' + e.target.result +')');
            $('.upload-logo').find('img').css('z-index','-1');
        };

        self.loadSchools();
        
        this.initFormSubmit(createSchoolFormEl, {
            'school[name]': 'name',
            'school[photo]': 'photo',
            'school[board]': 'name',
            'school[address]': 'name',
            'school[zip_code]': 'zip_code',
            'school[phone1]': 'phone',
            'school[website]': 'website',
            'school[logo]': 'logo',
            'administrator[first_name]': 'name',
            'administrator[last_name]': 'name',
            'administrator[cell_number]': 'phone',
            'administrator[email]': 'email',
        }, function (res) {
            if(res.success) {
                createSchoolFormEl[0].reset();
                createModalEl.modal('hide');
                self.loadSchools();
                toastr.success('School created successfully', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
            }else {
                self.showErrors(res.errors);
            }
        },{
            contentType: false,
            enctype: 'multipart/form-data',
            processData: false
        });

        $(document).on('click','.cancel-creation', function (e) {
            createModalEl.modal('hide');
            createSchoolFormEl[0].reset();
            e.preventDefault();
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