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

        $("#labelForgotPassword").click(function (){
            $("#loginDiv").addClass('hidden');
            $("#forgotPasswordDiv").removeClass('hidden');
        });

        $(document).on('click','.sign-in-link', function () {
            signInModal.modal('show');
            $("#loginDiv").removeClass('hidden');
            $("#login-form")[0].reset();
            $("#forgot-password-form")[0].reset();
            $('#signInModal .form-group label.error').remove();
            $("#forgotPasswordDiv").addClass('hidden');
            signInModal.find('.show_err').text('');
        });

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
    }
}