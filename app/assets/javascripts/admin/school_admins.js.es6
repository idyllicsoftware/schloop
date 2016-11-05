//= require_self

class SchoolAdmins extends SchloopBase {
    init (){
        var self = this;
        self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let self = this;
        self.loadSchoolsAdmins();
    };

    get schoolAdminTpl(){
        return $("#school_admin_tpl").html();
    };

    loadSchoolsAdmins (){
        let self = this, html = '',
            { school_id } = this._config,
            schoolAdminContainerEl = $("#schoolAdminContainer");
        $.ajax({
            url: `/admin/schools/${school_id}/school_admins`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(self.schoolAdminTpl, res);
                }
                schoolAdminContainerEl.html(html);
            }
        });
    }
}