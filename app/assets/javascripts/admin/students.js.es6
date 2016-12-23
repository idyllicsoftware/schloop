
class Students extends SchloopBase {
    init (){
        let _self = this;

        _self.initEventListeners();
        return this;
    };

    get studentsListTpl (){
        return $('#student_list_tpl').html();
    };

    get divisionsListTpl (){
        return $('#divisions_list_tpl').html();
    };

    get gradeListTpl (){
        return $('#grades_list_tpl').html();
    };

    getDivisionsByGradeId (grade_id){
        var _self = this,
            { divisions } =  _self.grades_hash[grade_id] || [];

        return divisions;
    };

    processDivisions (grade_id) {
        let _self = this,
            html,
            divisionsWrapperEl = $("#divisions_wrapper_id"),
            divisions = _self.getDivisionsByGradeId(grade_id);


        html = Mustache.to_html(_self.divisionsListTpl, {
            divisions: divisions,
            divisions_present: divisions.length
        });

        divisionsWrapperEl.html(html);

        divisionsWrapperEl.find(".division-list-item").eq(0).trigger('click');
    };

    getGrades () {
        let _self = this,
            html = '',
            studentWrapperEl = $('#students-tab'),
            { school_id } = _self._config;

        $.ajax({
            url: `/admin/schools/${school_id}/grades/grades_divisions`,
            success: function (res) {
                _self.grades_hash = res.grades.toHash('grade_id');
                if(res.success) {
                    html = Mustache.to_html(_self.gradeListTpl, {
                        grades: res.grades,
                        grades_present: res.grades.length
                    });
                }
                studentWrapperEl.html(html);
                $("#grade_select").trigger('change');
            }
        });
    };

    onTabShow (){
        var _self = this;
        _self.getGrades();
    };

    initEventListeners(){
        let _self = this,
            { school_id } = _self._config;

        $(document).on('click', '.division-list-item', function () {
            let { division_id } = $(this).data();
            $(".division-list-item.active").removeClass('active');
            $(this).addClass('active');
            _self.loadStudents(division_id);
        });

        $(document).on('change', '#grade_select', function () {
            let grade_id = $(this).val();
            $('#studentListWrapper').html("");
            $("#divisions_wrapper_id").html("");
            $("#uploadStudentCSVLink").attr('href', `/admin/parent_imports/new?grade_id=${grade_id}&school_id=${school_id}`)
            _self.processDivisions(grade_id);
        });
    };

    loadStudents(division_id){
        let _self = this, html = '',
            studentListWrapperEl = $('#studentListWrapper');
            
        $.ajax({
            url: `/admin/students?division_id=${division_id}`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.studentsListTpl, {
                        student_data: res.student_data,
                        student_data_present: res.student_data.length
                    });
                }
                _self.studentsData = res.student_data.toHash('student_id');
                studentListWrapperEl.html(html);
                _self.popoverInit(false, studentListWrapperEl);
                studentListWrapperEl.find('td #student-edit-popover').on('shown.bs.popover', function (){
                    let popupEl = $('#' + $(this).attr('aria-describedby')),
                        student_id = $(this).data('student_id'),
                        jForm = popupEl.find('form');
                
                    if(_self.studentsData.hasOwnProperty(student_id)){
                            jForm.fillForm(_self.studentsData[student_id], 'student');
                            jForm.attr('action', `/admin/students/${student_id}`);
                            jForm.attr('method', 'PUT');
                            jForm.find('input[name="student[parent_email]"]').attr('disabled', 'disabled');
                            _self.initForm(jForm, $(this), student_id);
                        }
                });
            }
        });
    };

    initForm (jForm, popoverEl, student_id){ 
        let _self = this,
            student_id_hash = {
                'student_id': student_id
            },
            msg = student_id ? 'School student updated successfully' : 'School student added successfully',
            deactivate_student_url = `/admin/students/deactivate`;
           
        this.initFormSubmit(jForm, {
            'student[student_first_name]': 'name',
            'student[student_last_name]': 'name',
            'student[parent_first_name]': 'name',
            'student[parent_last_name]': 'name',
            'student[parent_email]': 'email',
            'student[cell_number]': 'phone'
        }, function (res) {
            if(res.success) {
                _self.loadStudents();
                toastr.success(msg);
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
                popoverEl.popover('hide');
            }
        });

        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
            popoverEl.popover('hide');
        });

        jForm.find('.deActivateStudentBtn').off('click').on('click', function() {
            var el = $(this),
                student_row = popoverEl.parent();
            
            swal({
                  title: "Are you sure?",
                  text: "You want deactivate this student",
                  confirmButtonColor: "#25aae1",
                  confirmButtonText: "Yes, deactivate it!",
                  showCancelButton: true
                },
                function(){
                  $.ajax({
                        url: '/admin/students/deactivate',
                        method: 'POST',
                        data: student_id_hash,
                        success: function (res) {
                            if(res.success) {
                                toastr.success('Student deactivated successfully', '', {
                                    positionClass: 'toast-top-right cloud-display'
                                });
                                student_row.remove();
                                _self.loadStudents();
                                popoverEl.popover('hide');
                            }else {
                                _self.showErrors(res.errors);
                            }
                        },
                        error: function () {
                            swal({title: "Oops!", text: "Something went wrong. Please try later.", type: "error", confirmButtonText: "OK" });
                        }
                    });
            });
        })
    };
}