//= require_self
//= require admin/school_teachers
//= require admin/school_admins
//= require admin/grades
//= require admin/ecircular

class SchoolProfiles extends SchloopBase {
    init (){
        var self = this;
        self.popoverInit(true);
        self._school_teachers = new SchoolTeachers({school_id: this._config.school_id});
        self._school_admins = new SchoolAdmins({school_id: this._config.school_id});
        self._grades = new SchoolGrades({school_id: this._config.school_id});
        self._ecircular = new SchoolECircular({school_id: this._config.school_id});
        self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let self = this;
    }    
}