//= require_self

class SchoolAdmins extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let _self = this,
        { school_id } = _self._config;
        _self.loadSchoolsAdmins();

        $("#add-school-administrator-popover").on('show.bs.popover', function () {
            $(".removeUserBtn").hide();
        });

        $("#add-school-administrator-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby')),
                jForm = popupEl.find('form');
            jForm[0].reset();
            jForm.attr('action', `/admin/schools/${school_id}/school_admins`);
            jForm.attr('method', 'POST');
            jForm.find('input[name="administrator[email]"]').removeAttr('disabled');
            _self.initForm(jForm, $(this));
        });
    };

    initForm (jForm, popoverEl, school_admin_id){
        let _self = this,
            delete_admin_url = `/admin/school_admins/${school_admin_id}`,
            msg = school_admin_id ? 'School admin updated successfully' : 'School admin added successfully';

        this.initFormSubmit(jForm, {
            'administrator[first_name]': 'name',
            'administrator[last_name]': 'name',
            'administrator[cell_number]': 'phone',
            'administrator[email]': 'email'
        }, function (res) {
            if(res.success) {
                _self.loadSchoolsAdmins();
                toastr.success(msg);
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
            }
        });

        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
            popoverEl.popover('hide');
        });

        jForm.find('.removeUserBtn').off('click').on('click', function () {
            _self.deleteRequest(delete_admin_url, $(this), null, function (res) {
                if(res.success) {
                    _self.loadSchoolsAdmins();
                    toastr.success('School admin removed successfully');
                    popoverEl.popover('hide');
                }else {
                    _self.showErrors(res.errors);
                }
            })
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

                    schoolAdminContainerEl.html(html);
                    _self.popoverInit(false, schoolAdminContainerEl);

                    schoolAdminContainerEl.find("[data-toggle=popover]").on('show.bs.popover', function () {
                        $(".removeUserBtn").show();
                    });

                    schoolAdminContainerEl.find("[data-toggle=popover]").on('shown.bs.popover', function () {
                        let popupEl = $('#' + $(this).attr('aria-describedby')),
                            school_admin_id = $(this).data('school_admin_id'),
                            jForm = popupEl.find('form');

                        if(_self.schoolAdmins.hasOwnProperty(school_admin_id)){
                            jForm.fillForm(_self.schoolAdmins[school_admin_id], 'administrator');
                            jForm.attr('action', `/admin/school_admins/${school_admin_id}`);
                            jForm.attr('method', 'PUT');
                            jForm.find('input[name="administrator[email]"]').attr('disabled', 'disabled');
                            _self.initForm(jForm, $(this), school_admin_id);
                        }
                    });
                }
            }
        });
    };

    add_division (){
        let _self = this,
            jForm = $(".add-division-form");

        jForm.submit( function() {
            var added_division = jForm.serializeObject;
            $.ajax({
                url: `/admin/schools/${school_id}/`,
                data: added_division,
                success: function (res) {
                                                //To DO...
            }

            });     
        });       
    };

    add_subject (){
        let _self = this,
            jForm = $(".add-subject-form");

        jForm.submit( function() {
            var added_subject = jForm.serializeObject;
            $.ajax({
                url: `/admin/schools/${school_id}/`,
                data: added_subject,
                success: function (res) {
                                                //To DO...
            }

            });     
        });       
    };
}