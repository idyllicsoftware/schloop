//= require jquery2
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap-sprockets
//= require sweetalert
//= require jquery.validate
//= require toastr.min
//= require mustache
//= require tinymce/tinymce.min.js
//= require tinymceEditor.js
//= require jquery.timeago.js
//= require multiselect.min
//= require moment
//= require common
//= require file_uploads
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

    submitData (url, jFrom, data, cb, extraParams, otherBtnEl) {
        let self = this,
            params,
            btnEl = otherBtnEl || jFrom.find('button[type="submit"]');

        self.addAjaxLoader(btnEl);

        params = {
            url: url,
            method: jFrom.attr('method') || 'POST',
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

    showErrors (errors){
        if(typeof errors === 'string'){
            let msg = errors + '<br/>' || "Something went wrong. Please try later.";
            swal({title: "Oops!",   text: msg,   html:true, type: "error",   confirmButtonText: "OK" });
        } else if (typeof errors === 'object'){
            let msg = errors.join("<br/> ") || "Something went wrong. Please try later.";
            swal({title: "Oops!",   text: msg,   html:true, type: "error",   confirmButtonText: "OK" });
        }
    };

    deleteRequest (url, btnEl, data, cb){
        let self = this;
        self.addAjaxLoader(btnEl);

        $.ajax({
            url: url,
            method: 'DELETE',
            cache: false,
            dataType: 'json',
            data: data || {},
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
        });
    };

    getValidationRules () {
        return {
            rules: {
                password: {
                    required: true,
                    minlength: 6
                },
                current_password: {
                    required: true,
                    minlength: 6
                },
                password_confirmation: {
                    required: true,
                    minlength: 6
                },
                zip_code: {
                    required: true,
                    digits: true,
                    minlength: 6
                },
                phone: {
                    required: true,
                    digits: true,
                    minlength: 10
                },
                website: {
                    required: true,
                    url: true,
                },
                name: {
                    required: true,
                },
                email: {
                    required: true,
                    email: true
                }
            },
            messages: {
                name: {
                    required: "This field is required",
                },
                password: {
                    required: "Please enter correct password",
                    minlength: jQuery.validator.format("At least {0} characters password required!")
                },
                current_password: {
                    required: "Please enter correct password",
                    minlength: jQuery.validator.format("At least {0} characters password required!")
                },
                password_confirmation: {
                    required: "Please enter correct password",
                    minlength: jQuery.validator.format("At least {0} characters password required!")
                },
                website: {
                    required: 'Please enter Website URL',
                    url: 'Please enter valid Website URL eg: http://www.schloop.co',
                },
                zip_code: {
                    required: "Please enter valid zipcode",
                    digits: "Please enter valid zipcode",
                    minlength: jQuery.validator.format("At least {0} characters zipcode required!")
                },
                phone: {
                    required: "Please enter valid phone number",
                    digits: "Please enter valid phone number",
                    minlength: jQuery.validator.format("At least {0} characters phone number required!")
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
            rules = {}, messages = {}, key, mapping_key;

            for(key in fieldsMapping){
                mapping_key = fieldsMapping[key]
                if(all_rules.hasOwnProperty(mapping_key)){
                    rules[key] = all_rules[mapping_key];
                }
                if(all_messages.hasOwnProperty(mapping_key)){
                    messages[key] = all_messages[mapping_key];
                }
            }

        jForm.validate({
            rules: rules,
            messages: messages
        });
    };

    initFormSubmit (jForm, fieldsMapping, cb, extraParams, btnEl){
        let self = this;

        self.formValidatorInit(jForm, fieldsMapping);

        jForm.submit(function (e) {
            e.preventDefault();
            e.stopPropagation();
            let jForm = $(this), formData;
            console.log(2);
            if(jForm.valid()) {
                if(extraParams) {
                    formData = new FormData(jForm[0]);
                }else{
                    formData = jForm.serialize();
                }
                self.submitData(jForm.attr('action'), jForm, formData, cb, extraParams, btnEl);
            }
        });
    };

    popoverInit (initBodyClick: false, jScope){
        jScope = jScope || $(document);
        if(initBodyClick) {
            $('body').on('click', function (e) {
                $('[data-toggle="popover"]').each(function () {
                    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                        $(this).popover('hide');
                    }
                });
            });
        }

        jScope.find("[data-toggle=popover]").popover({
            html : true,
            content: function() {
                var data_content = $(this).data("value");
                return $("#" + data_content).html();
            }
        });
    };

    initUserChangePasswordForm() {
        let self = this,
            change_pwd_form = $('#change-password-form'),
            changePasswordModal = $('#changePasswordModal');

        $('.change-pwd-link').on('click', function(){
            change_pwd_form[0].reset();
            changePasswordModal.find('.show_err').text('');
        });

        this.initFormSubmit(change_pwd_form, {
           'user[current_password]': 'current_password',
           'user[password]': 'password',
           'user[password_confirmation]': 'password_confirmation'
        }, function (res) {
           if (res.success){
                toastr.success('Password changed successfully', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
                changePasswordModal.modal('hide');
                change_pwd_form[0].reset();
                changePasswordModal.find('.show_err').text('');
           }else {
                change_pwd_form.find('.show_err').text(res.errors);
           }
        });
    };
}
