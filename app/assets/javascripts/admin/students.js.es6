
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
                if(res.grades[0]) {
                    _self.processDivisions(res.grades[0].grade_id);
                }
            }
        });
    };

    onTabShow (){
        var _self = this;
        _self.getGrades();
    };

    initEventListeners(){
        let _self = this;

        $(document).on('click', '.division-list-item', function () {
            let { division_id } = $(this).data();
            $(".division-list-item.active").removeClass('active');
            $(this).addClass('active');
            _self.loadStudents(division_id);
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
                studentListWrapperEl.html(html);
            }
        });
    };
}