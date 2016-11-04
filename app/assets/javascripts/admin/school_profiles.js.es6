//= require_self
//= require admin/teachers

class SchoolProfiles extends SchloopBase {
    init (){
        var self = this;
        self.popoverInit();
        self._teachers = new SchoolTeachers();
        return this;
    };
}