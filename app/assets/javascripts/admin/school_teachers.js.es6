//= require_self

class SchoolTeachers extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let _self = this,
            { school_id } = _self._config;

        _self.loadSchoolsTeachers();

        $("#add-teachers-popover").on('show.bs.popover', function () {
            $(".removeTeacherBtn").hide();
        });

        $("#add-teachers-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby')),
                jForm = popupEl.find('form');
            jForm[0].reset();
            jForm.attr('action', `/admin/schools/${school_id}/teachers`);
            jForm.attr('method', 'POST');
            jForm.find('input[name="teacher[email]"]').removeAttr('disabled');
            $("input[type=checkbox]").change(function(){
                    var grade_id = $(this).data('grade_id'),
                        subject_id = $(this).data('subject_id'),
                        val = $(this).parents().eq(3).find('.subject_cls').val();
                    if($("input[name='grade["+ grade_id +"]subjects["+ subject_id +"]divisions[]']:checked")){
                        $("input[name='grade["+ grade_id +"]subjects["+ subject_id +"]divisions[]']:checked").each(function(i){
                            if(val == subject_id){     
                            $(this).parents().eq(3).find('.subject_cls').prop('checked', true);
                            }
                        });
                    }
             });  
            _self.initForm(jForm, $(this));
        });

        _self.initCsvUpload();
    };

    initCsvUpload (){
        var _self = this,
            uploadTeacherModalEl = $("#upload-teachers-modal"),
            uploadTeacherForm = uploadTeacherModalEl.find('form');

        $(document).on('click','.upload-sheet', function () {
            uploadTeacherModalEl.modal('show');
        });

        $('#upload-csv-file').change(function(){
            var res=$('#upload-csv-file').val();
            var arr = res.split("\\");
            var filename = arr.slice(-1)[0];
            var filextension = filename.split(".");
            var filext ="."+filextension.slice(-1)[0];
            var valid=[".csv"];

            if (valid.indexOf(filext.toLowerCase())==1){
                $('#namefile').css({"color":"green","font-weight":700,"padding":"20px"});
                $('#namefile').html("You select " + filename + " file.");
            }
        });

        this.initFormSubmit(uploadTeacherForm , {
            'school_id' : 'school_id'
        }, function (res) {
            if(res.success) {
                _self.loadSchoolsTeachers();
                toastr.success('File imported successfully');
                uploadTeacherModalEl.modal('hide');
            }else {
                _self.showErrors(res.errors);
                uploadTeacherModalEl.modal('hide');
            }
        },
        {
           contentType: false,
           enctype: 'multipart/form-data',
           processData: false
        });

        $(document).on('click','.upload-cancel', function () {
            uploadTeacherModalEl.modal('hide');
        });
    };

    initForm (jForm, popoverEl, school_teacher_id){
        let _self = this,
            delete_teachers_url = `/admin/teachers/${school_teacher_id}`,
            msg = school_teacher_id ? 'School teacher updated successfully' : 'School teacher added successfully';
           
        this.initFormSubmit(jForm, {
            'teacher[first_name]': 'name',
            'teacher[last_name]': 'name',
            'teacher[cell_number]': 'phone',
            'teacher[email]': 'email'
        }, function (res) {
            if(res.success) {
                _self.loadSchoolsTeachers();
                toastr.success(msg);
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
                popoverEl.popover('hide');
            }
        },{
            contentType: false,
            enctype: 'multipart/form-data',
            processData: false
        });

        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
            popoverEl.popover('hide');
        });

        jForm.find('.removeTeacherBtn').off('click').on('click', function () {
            _self.deleteRequest(delete_teachers_url, $(this), null, function (res) {
                if(res.success) {
                    _self.loadSchoolsTeachers();
                    toastr.success('School teacher removed successfully');
                    popoverEl.popover('hide');
                }else {
                    _self.showErrors(res.errors);
                }
            })
        });
    };

    get schoolTeachersTpl (){
        return $("#school_teachers_tpl").html();
    };

    loadSchoolsTeachers (){
        let _self = this, html = '',
            { school_id } = this._config,
            schoolTeacherContainerEl = $("#schoolTeacherContainer");
        $.ajax({
            url: `/admin/schools/${school_id}/teachers`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.schoolTeachersTpl, res);
                    _self.schoolTeachers = res.school_teachers.toHash('id');
                    schoolTeacherContainerEl.find('li.saved_teacher').remove();
                    schoolTeacherContainerEl.prepend(html);
                    _self.popoverInit(false, schoolTeacherContainerEl);

                    schoolTeacherContainerEl.find("li.saved_teacher").on('show.bs.popover', function () {
                        $(".removeTeacherBtn").show();
                    });

                    schoolTeacherContainerEl.find("li.saved_teacher").on('shown.bs.popover', function () {
                        let popupEl = $('#' + $(this).attr('aria-describedby')),
                            school_teacher_id = $(this).data('school_teacher_id'),
                            jForm = popupEl.find('form');

                        if(_self.schoolTeachers.hasOwnProperty(school_teacher_id)){
                            jForm.fillForm(_self.schoolTeachers[school_teacher_id], 'teacher');
                            jForm.attr('action', `/admin/teachers/${school_teacher_id}`);
                            jForm.attr('method', 'PUT');
                            jForm.find('input[name="teacher[email]"]').attr('disabled', 'disabled');
                            _self.initForm(jForm, $(this), school_teacher_id);
                        }
                    });
                }
            }
        });
    }
}