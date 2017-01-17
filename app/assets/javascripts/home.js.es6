class Main extends SchloopBase {
    init (){
        this.initEventListeners();
        return this;
    };

    initEventListeners () {
        var self = this;
        $(".sign-up-btn").click(function() {
            self.scrollTopTo($(".sign-up-registration-section").offset().top);
        });

        self.initLoginPopup();
    };

    initLoginPopup (){
        var self = this,
            login_form = $('#login-form'),
            signInModal = $('#signInModal'),
            forgot_password_form = $('#forgot-password-form');
        
        $(document).on('click', '.close-login-form', function() {
            signInModal.modal('hide');
        });

        $("#labelForgotPassword").click(function (){
            $("#loginDiv").addClass('hidden');
            $("#forgotPasswordDiv").removeClass('hidden');
        });
       
        $(document).on('click','.sign-in-link', function (e) {
            var teacher_login = $(this).data('teacher_login');
            signInModal.modal('show');
            $("#loginDiv").removeClass('hidden');
            $("#login-form")[0].reset();
            $("#forgot-password-form")[0].reset();
            $('#signInModal .form-group label.error').remove();
            $("#forgotPasswordDiv").addClass('hidden');
            signInModal.find('.show_err').text('');
            if (teacher_login) {
                login_form.attr('action','/teachers/sign_in');
                login_form.find('input[type=email]').attr('name','teacher[email]');
                login_form.find('input[type=password]').attr('name','teacher[password]');
                forgot_password_form.find('input[name=is_user]').val('false');
                e.preventDefault();  
                self.initTeacherLoginForm(login_form, forgot_password_form);              
            }else {
                login_form.find('input[type=email]').attr('name','user[email]');
                login_form.find('input[type=password]').attr('name','user[password]');
                login_form.attr('action','/users/sign_in');
                forgot_password_form.find('input[name=is_user]').val('true');
                self.initUserLoginForm(login_form, forgot_password_form);
            }
        }); 
    };

    initUserLoginForm (login_form, forgot_password_form) {
        let self = this,
            signInModal = $('#signInModal');

            this.initFormSubmit(login_form, {
               'user[email]': 'email' ,
               'user[password]': 'password'
            }, function (res) {
               if (res.errors){
                    login_form.find('.show_err').text(res.errors);
               }else {
                    window.location = res.redirect_url;
                    signInModal.modal('hide');
               }
            });
            
            this.initFormSubmit(forgot_password_form, {
               'user[email]': 'email'
            }, function (res) {
               if(res.success){
                signInModal.modal('hide');
                toastr.success('please check your email inbox!', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
            }else{
                forgot_password_form.find('.show_error').text('User is not available. Enter correct email address.');
                }
            });
    };

    initTeacherLoginForm (login_form, forgot_password_form) {
        let self = this,
            signInModal = $('#signInModal');

            self.initFormSubmit(login_form, {
               'teacher[email]': 'email' ,
               'teacher[password]': 'password'
            }, function (res) {
               if (res.errors){
                    login_form.find('.show_err').text(res.errors);
               }else {
                    window.location = res.redirect_url;
                    signInModal.modal('hide');
                    toastr.success('Sign in Successfully', '', {
                        positionClass: 'toast-top-right cloud-display'
                    });
               }
            });

            this.initFormSubmit(forgot_password_form, {
               'teacher[email]': 'email'
            }, function (res) {
               if(res.success){
                signInModal.modal('hide');
                toastr.success('please check your email inbox!', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
            }else{
                forgot_password_form.find('.show_error').text('User is not available. Enter correct email address.');
                }
            });
    }
}