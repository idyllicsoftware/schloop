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
        // $("#myTab a[data-toggle='tab']").off().on('shown.bs.tab', function () {
        //     _self.loadSchoolsTeachers();
        // });
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
                        subject_id = $(this).data('subject_id');
                        
                    if($("input[name='grade["+ grade_id +"]subjects["+ subject_id +"]divisions[]']:checked")){
                        $("input[name='grade["+ grade_id +"]subjects["+ subject_id +"]divisions[]']:checked").each(function(i){
                            $(this).parents().eq(3).find('.subject_cls').prop('checked', true);
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
            file_upload = new FileUpload({
                jScope: uploadTeacherModalEl
            });

        $(document).on('click','.upload-sheet', function () {
            uploadTeacherModalEl.modal('show');
        });

        $(document).on("uploadedFileResponse", function (e, res) {
            let {result} = res;
            if(result.success){
                toastr.success('Upload Successful', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
                uploadTeacherModalEl.modal('hide');
                _self.loadSchoolsTeachers();
            }
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
                toastr.success(msg, '', {
                    positionClass: 'toast-top-right cloud-display'
                });
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
            var removeUserBtn = $(this);
            swal({
                    title: "Are you sure?",
                    text: "You want delete school admin",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes, delete it!"
                },
                function(isConfirm){
                    if (isConfirm) {
                         _self.deleteRequest(delete_teachers_url, removeUserBtn, null, function (res) {
                            if(res.success) {
                                _self.loadSchoolsTeachers();
                                toastr.success('School teacher removed successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                                });
                                popoverEl.popover('hide');
                            }else {
                                _self.showErrors(res.errors);
                            }
                        })
                    }    
                });
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
                    schoolTeacherContainerEl.append(html);
                    _self.popoverInit(false, schoolTeacherContainerEl);

                    schoolTeacherContainerEl.find("li.saved_teacher").on('show.bs.popover', function () {
                        $(".removeTeacherBtn").show();
                    });

                    schoolTeacherContainerEl.find("li.saved_teacher").on('shown.bs.popover', function () {
                        let popupEl = $('#' + $(this).attr('aria-describedby')),
                            school_teacher_id = $(this).data('school_teacher_id'),
                            jForm = popupEl.find('form');
                            
                        if(_self.schoolTeachers.hasOwnProperty(school_teacher_id)){
                            var grade_teacher_data =  _self.schoolTeachers[school_teacher_id].grade_teacher_data;
                            jForm.fillForm(_self.schoolTeachers[school_teacher_id], 'teacher');
                            jForm.attr('action', `/admin/teachers/${school_teacher_id}`);
                            jForm.attr('method', 'PUT');
                            jForm.find('input[name="teacher[email]"]').attr('disabled', 'disabled');
                            grade_teacher_data.forEach( function(index){
                            var grade_data = index.subjects_data,
                                grade_id = index.grade_id;
                                grade_data.forEach( function(subjects_id){
                                    var divisions_data = subjects_id.divisions_data,
                                        sub_id = subjects_id.subject_id;
                                    divisions_data.forEach(function(div_id){  
                                        jForm.find("input[name='grade["+ grade_id +"]subjects["+ sub_id +"]divisions[]']").each(function(){
                                            var this_EL_val = $(this).val(),
                                                curr_sub_id = $(this).data('subject_id'),
                                                division_id = div_id.division_id;
                                                if(this_EL_val == division_id && curr_sub_id == sub_id){
                                                        $(this).prop('checked', true);
                                                        $(this).parents().eq(3).find('.subject_cls').prop('checked', true);
                                                }
                                        });    
                                    });
                                });
                            });
                            _self.initForm(jForm, $(this), school_teacher_id);
                        }
                    });
                }
            }
        });
    }
}