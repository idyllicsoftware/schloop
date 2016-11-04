//= require_self
//= require admin/teachers
	
class SchoolProfiles extends SchloopBase {
    init (){
        var self = this;
        self.popoverInit();
        self._teachers = new SchoolTeachers().init();
        self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let self = this;

        $(document).on('click','.data-title', function () {
    	    if ($(".no-of-div").hasClass("fa-chevron-down")){
        		$(".no-of-div").addClass("fa-chevron-up");
        		$(".no-of-div").removeClass("fa-chevron-down");
    		}else {
    			$(".no-of-div").removeClass("fa-chevron-up");
    			$(".no-of-div").addClass("fa-chevron-down");
    		}
        	$(".slide-division-wrapper").slideToggle();
        });
    }    
}