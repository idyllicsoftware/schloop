
class Students extends SchloopBase {
    init (){
        let _self = this;

        _self.initEventListeners();
        return this;
    };

    get studentsListTpl (){
        return $('#student_list_tpl').html();
    };

    getGrades () {
        let _self = this,
            { school_id } = _self._config;

        $.ajax({
            url: `/admin/schools/${school_id}/grades/grades_divisions`,
            success: function (res) {
                debugger;
            }
        });
    };

    onTabShow (){
        var _self = this;
        _self.getGrades();
    };

    initEventListeners(){
        let _self = this;

        // _self.loadStudents();
    };

    loadStudents(division_id){
        let _self = this, html = '',
            activitiesListEl = $('#content_list_id');
        $.ajax({
            url: `/admin/activities/all`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.studentsListTpl, res);
                }
                activitiesListEl.html(html);
            }
        });
    };
}