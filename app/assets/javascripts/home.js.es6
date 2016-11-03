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

        $("#labelForgotPassword").click(function (){
            $("#loginDiv").addClass('hidden');
            $("#forgotPasswordDiv").removeClass('hidden');
        });

        $(".sign-in-link").click(function() {
            $("#loginDiv").removeClass('hidden');
            $("#forgotPasswordDiv").addClass('hidden');
        });

        self.initLoginPoup();
    };

    initLoginPoup (){
        $(".schools-registraion-form").submit(function () {
            var jForm = $(this),
                formData = jForm.serializeObject();

            $(".data-title").click( function () {
                $(".slide-division-wrapper").slideToggle();
            });

            $.ajax({
                url: new_school_path,
                method: 'POST',
                data: formData,
                success: function() {
                    createModalEl.modal('hide');
                }
            });
        });
    }
}