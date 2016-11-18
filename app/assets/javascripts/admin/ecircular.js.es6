// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class SchoolECircular extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };
			
    initEventListeners (){
        let _self = this,
        { school_id } = _self._config,
        eCircularFormEl = $(".school-ecircular-form");
        

        $("#select-circular-popover").on('shown.bs.popover', function () {
        	$("input[name=radio_select]").change(function(){ 
			        if( $(this).is(":checked") ){ 
			            var val = $(this).val(),
			            	name = $(this).next().text(),
			            	tag_El = $(this).parents().eq(4).find('.selected_circular_tag');
			        	
			        	tag_El.replaceWith('<p class="selected_circular_tag">'+ name +'</p>');
			        	$('.selected_circular_tag').next().val(val)     
			        }
			    });
        });
       
        $("#select-recipients-popover").on('shown.bs.popover', function () {
        	$("input[type=checkbox]").change(function(){
        	        var selected_grade_id = [],selected_grade = [],selected_division = [],
        	        	selected_division_id = [],vall = $(this).data('grade_id'),
        	        	tag_El = $('.school-ecircular-form').find('.select-recipients_name');  
		        $("input[name='grade[]']:checked").each(function(i){
		        	selected_grade[i] = $(this).parent().find('label').html();
		          	selected_grade_id[i] = $(this).val();

		        });
		  //       var grade_arr = [];
		  //       for (var i = 0; i < selected_grade.length; i++) {
    // 				grade_arr.push('<span class="present_grade" data-grade_id="'+ selected_grade_id [i] +'">' + selected_grade[i] + '</span>');
				// }	
		  //       selected_grade_id.forEach(function(grade){
		  //       	var val = grade;
		  //       	$("input[name='grade["+ val +"]division[]']:checked").each(function(i){ 
		  //       		if(val == vall){
			 //        	selected_division[i] = $(this).parent().find('label').html();
			 //          	selected_division_id[i] = $(this).val();
			 //          	}
		  //       	});
		  //       });
		  //       var grade_array = [];
			 //          	for (var i = 0; i < selected_division.length; i++) {
    // 						grade_array.push('<span class="present_grade" data-grade_id="'+ vall +'">' + selected_division[i] + '</span>');
				// 		}
		  //       tag_El.html(grade_arr.join(" , ") + grade_array.join(","));
		  //       debugger;
		    });    
        });
        

        this.initFormSubmit(eCircularFormEl, {
            'title': 'title',
            'attachments[]': 'attachments[]',
        }, function (res) {
            if(res.success) {
                eCircularFormEl[0].reset();
                self.loadSchools();
                toastr.success('School created successfully');
            }else {
                self.showErrors(res.errors);
            }
        });
    }
}        