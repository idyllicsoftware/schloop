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