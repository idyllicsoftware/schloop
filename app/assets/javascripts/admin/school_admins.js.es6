//= require_self

class SchoolAdmins extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let _self = this;
        _self.loadSchoolsAdmins();

        $("#add-school-administrator-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby'));
            popupEl.find(".removeAdminBtn").hide();
            popupEl.find('form')[0].reset();
        });
    };

    get schoolAdminTpl (){
        return $("#school_admin_tpl").html();
    };

    loadSchoolsAdmins (){
        let _self = this, html = '',
            { school_id } = this._config,
            schoolAdminContainerEl = $("#schoolAdminContainer");
        $.ajax({
            url: `/admin/schools/${school_id}/school_admins`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.schoolAdminTpl, res);
                    _self.schoolAdmins = res.school_admins.toHash('id');
                }
                schoolAdminContainerEl.html(html);
                _self.popoverInit(false, schoolAdminContainerEl);

                schoolAdminContainerEl.find("[data-toggle=popover]").on('shown.bs.popover', function () {
                    let popupEl = $('#' + $(this).attr('aria-describedby')),
                        id = $(this).data('id'),
                        jForm = popupEl.find('form');
                        popupEl.find(".removeAdminBtn").show();

                    if(_self.schoolAdmins.hasOwnProperty(id)){
                        jForm.fillForm(_self.schoolAdmins[id], 'administrator');
                    }
                });
            }
        });
    }
}