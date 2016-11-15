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
        var self = this;
        $("#labelForgotPassword").click(function (){
            $("#loginDiv").addClass('hidden');
            $("#forgotPasswordDiv").removeClass('hidden');
        });
         
        $(".sign-in-link").click(function() {
            $("#loginDiv").removeClass('hidden');
            $("#login-form")[0].reset();
            $("#forgot-password-form")[0].reset();
            $('#signInModal .form-group label.error').remove();
            $("#forgotPasswordDiv").addClass('hidden');
        });

        //this.initFormSubmit($("#login-form"), {
        //    'user[email]': 'email' ,
        //    'user[password]': 'password'
        //}, function () {
        //    debugger;
        //});
        //
        //this.initFormSubmit($("#forgot-password-form"), {
        //    'user[email]': 'email'
        //}, function () {
        //    debugger;
        //});
    }
}