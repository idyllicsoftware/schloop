//= require jquery2
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_self

class SchloopBase {
    constructor (config) {
        this._config = config;
        return this;
    };

    init (){};

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