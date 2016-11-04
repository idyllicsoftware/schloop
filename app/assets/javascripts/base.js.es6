//= require jquery2
//= require jquery_ujs
//= require bootstrap-sprockets
//= require sweetalert
//= require jquery.validate
//= require common
//= require_self

class SchloopBase {
    constructor (config) {
        this._config = config;
        this.init();
        return this;
    };

    init (){
        return this;
    };

    scrollTopTo ($top, $duration=400){
        $("html, body").animate({scrollTop: $top}, $duration);
    };

    addAjaxLoader (scope){
        var loader = '<span class="ajax-loader"></span>';
        if(scope.find('.ajax-loader')){
            scope.find('.ajax-loader').remove();
        }
        scope.addClass('loaderIn');
        scope.append(loader);
        scope.attr('disabled', 'disabled');
    };

    removeAjaxLoader (scope){
        scope.removeClass('loaderIn');
        scope.find('.ajax-loader').remove();
        scope.removeAttr('disabled');
    };

    submitData (url, jFrom, data, cb, extraParams) {
        let self = this,
            params,
            btnEl = jFrom.find('button[type="submit"]');

        self.addAjaxLoader(btnEl);

        params = {
            url: url,
            method: 'POST',
            cache: false,
            dataType: 'json',
            data: data,
            success: function (res) {
                self.removeAjaxLoader(btnEl);
                if(cb) {
                    cb(res);
                }
            },
            error: function () {
                self.removeAjaxLoader(btnEl);
                swal({title: "Oops!",   text: "Something went wrong. Please try later.",   type: "error",   confirmButtonText: "OK" });
            }
        };

        $.extend(params, extraParams || {});
        $.ajax(params);
    };

    getValidationRules () {
        return {
            rules: {
                password: {
                    required: true,
                    minlength: 6
                },
                email: {
                    required: true,
                    email: true
                }
            },
            messages: {
                password: {
                    required: "Please enter correct password",
                    minlength: jQuery.validator.format("At least {0} characters password required!")
                },
                email: {
                    required: "Please specify email address",
                    email: "Your email address must be in the format of name@domain.com"
                }
            }
        }
    };

    formValidatorInit (jForm, fieldsMapping){
        let {rules: all_rules, messages:all_messages} = this.getValidationRules(),
            rules = {}, messages = {}, key;

            for(key in fieldsMapping){
                if(all_rules.hasOwnProperty(key)){
                    rules[fieldsMapping[key]] = all_rules[key];
                }
                if(all_messages.hasOwnProperty(key)){
                    messages[fieldsMapping[key]] = all_messages[key];
                }
            }

        jForm.validate({
            rules: rules,
            messages: messages
        });
    };

    initFormSubmit (jForm, fieldsMapping, cb){
        let self = this;

        self.formValidatorInit(jForm, fieldsMapping);

        jForm.submit(function (e) {
            e.preventDefault();
            let jForm = $(this), formData;
            if(jForm.valid()) {
                formData = jForm.serialize();
                self.submitData(jForm.attr('action'), jForm, formData, cb);
            }
        });
    };

    popoverInit (){
        $('body').on('click', function (e) {
            $('[data-toggle="popover"]').each(function () {
                if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                    $(this).popover('hide');
                }
            });
        });

        $("[data-toggle=popover]").popover({
            html : true,
            content: function() {
                var data_content = $(this).data("value");
                return $("#" + data_content).html();
            }
        });
    }
}