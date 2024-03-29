//= require_self
//= require admin/school_teachers
//= require admin/school_admins
//= require admin/grades
//= require admin/ecircular
//= require admin/students

class SchoolProfiles extends SchloopBase {
    init (){
        var _self = this,
            params = {school_id: this._config.school_id};
        _self.popoverInit(true);

        _self._school_teachers = new SchoolTeachers(params);
        _self._school_admins = new SchoolAdmins(params);
        _self._grades = new SchoolGrades(params);
        _self._ecircular = new SchoolECircular(params);
        _self._students = new Students(params);
        
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        var _self = this,
        user_name = $('.user_name').html(),
        fname_char = user_name.split(' ')[0].charAt(0),
        lname_char = user_name.split(' ')[1].charAt(0),
        user_profile_name = fname_char + lname_char;
        
        $('.profile-photo').html(user_profile_name.toUpperCase());
        
        $('#school-Tab li a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            let el = $(this),
                { tabName } = el.data();

            switch (tabName){
                case "students":
                    _self._students.onTabShow();
                break;
                case "circulars":
                    //
                break;
            }

        });
    };
}