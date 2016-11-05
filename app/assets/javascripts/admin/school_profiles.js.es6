//= require_self
//= require admin/teachers
//= require admin/school_admins

class SchoolProfiles extends SchloopBase {
    init (){
        var self = this;
        self.popoverInit();
        self._teachers = new SchoolTeachers({school_id: this._config.school_id});
        self._school_admins = new SchoolAdmins({school_id: this._config.school_id});
        self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let self = this;

        $(document).on('click','.data-title', function () {
    	    if ($(".no-of-div").hasClass("fa-chevron-down")){
        		$(".no-of-div").addClass("fa-chevron-up").removeClass("fa-chevron-down");
    		}else {
    			$(".no-of-div").removeClass("fa-chevron-up").addClass("fa-chevron-down");
    		}
        	$(".slide-division-wrapper").slideToggle();
        });
    }    
}