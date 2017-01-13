// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class SchoolGrades extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };
	
    get addTeachersTpl (){
        return $("#add_teachers_tpl").html();
    };
	
    initEventListeners (){
        let _self = this,addTeachersContainer = $('.scroll-grade'),
        { school_id } = _self._config;
        _self.loadSchoolsGrades();
        $(".grade-teacher-tab > #teach-tab > a[data-toggle='tab']").on('shown.bs.tab', function () {

           var html = Mustache.to_html(_self.addTeachersTpl, {
                grades: _self.schoolGrades,    
           });
            addTeachersContainer.html(html);
        });

        $(".grade-teacher-tab > #grade-tab > a[data-toggle='tab']").on('shown.bs.tab', function () {
            _self.loadSchoolsGrades();
        });

        $("#add-grade-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby')),
                jForm = popupEl.find('form');
                jForm[0].reset();
                jForm.attr('action', `/admin/schools/${school_id}/grades`);
                jForm.attr('method', 'POST');
                _self.add_grade(jForm, $(this));
        });

        $(document).on('click', '.delete_grade',function(){
            var el = $(this),
                grade_div = el.parent(),
                grade_id = el.data('grade-id');

                swal({
                  title: "Are you sure?",
                  text: "You want delete this grade",
                  confirmButtonColor: "#25aae1",
                  confirmButtonText: "Yes, delete it!",
                  showCancelButton: true
                },
                function(){
                  _self.deleteRequest(`/admin/grades/${grade_id}`, el, null, function (res) {
                        if(res.success) {
                            toastr.success('Grade deleted successfully', '', {
                                positionClass: 'toast-top-right cloud-display'
                            });
                            grade_div.remove();
                        }else {
                            _self.showErrors(res.errors);
                        }
                    });
                });
        });
    };

    get schoolGradesTpl (){
        return $("#school_grade_tpl").html();
    };

    initForm (jForm, popoverEl, grade_id ,current_element){
        let _self = this;
         
        this.initFormSubmit(jForm, {
            'subject_name': 'name',
            'grade_id': 'name',
            'division_name': 'name',
                    }, function (res) {
            if(res.success) {
            	_self.loadSchoolsGrades();
            	if(jForm.hasClass("add-subject-form")){
                	current_element.find(".subject-list").append("<li><a href='#subject1-tab' data-toggle='tab'>" + res.subject_name +"</a></li>");
             		toastr.success('Subject added successfully', '', {
                        positionClass: 'toast-top-right cloud-display'
                    });
             	}else{
                 	current_element.parent().find(".division-list").append("<li><a href='#div1-tab' data-toggle='tab'>" + res.division_name +"</a></li>");
             		toastr.success('Division added successfully', '', {
                        positionClass: 'toast-top-right cloud-display'
                    });
             	}
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
            }
        });
            
        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
        	popoverEl.popover('hide');
    	});
    };
        

    add_grade (jForm, popoverEl){
        let _self = this,
            msg = 'Grade added successfully';
            
        this.initFormSubmit(jForm, {
            'grade_name': 'name',
            'grade_id': 'name',
        }, function (res) {
            if(res.success) {
                _self.loadSchoolsGrades();
                toastr.success(msg, '', {
                    positionClass: 'toast-top-right cloud-display'
                });
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
            }
        });

        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
            popoverEl.popover('hide');
        });
    };

    processGrades (grades){
        grades.forEach(function(grade){
            var count = 0;
            grade.valid = true;
            grade.subjects.forEach(function(subject){
                subject.valid = true;
                if(!subject.divisions.length){
                    subject.valid = false;
                    count ++;
                }
            });
            if(count == grade.subjects.length){
                grade.valid  = false;
            }
        });

        return grades;
    };

    loadSchoolsGrades (){
        let _self = this, html = '',
            { school_id } = this._config,
            schoolGradeContainerEl = $("#schoolGradeContainer");

        $.ajax({
            url: `/admin/schools/${school_id}/grades`,
            success: function (res) {
                if(res.success) {
                    html = Mustache.to_html(_self.schoolGradesTpl, res);
                    _self.schoolGrades = _self.processGrades(res.grades); 
                    _self.schoolGradesHash = _self.schoolGrades.toHash('grade_id'); 

                    schoolGradeContainerEl.html(html);
                    _self.popoverInit(false, schoolGradeContainerEl);
                    
                    schoolGradeContainerEl.find('.subject-list').each(function(){
                        var firstliEl = $(this).find('li').eq(0);
                        firstliEl.find('a').trigger('click');
                    });
                
                    schoolGradeContainerEl.find('.division-list').each(function(){
                        var firstliEl = $(this).find('li').eq(0);
                        firstliEl.find('a').trigger('click');
                    });

                    schoolGradeContainerEl.find("[data-toggle=popover]").on('shown.bs.popover', function () {
                        let popupEl = $('#' + $(this).attr('aria-describedby')),
                            grade_id = $(this).data('grade_id'),
                            jForm = popupEl.find('form'),
                            current_element = $(this).parent().closest("div");
                            
                        if(_self.schoolGradesHash.hasOwnProperty(grade_id)){
                    		if (jForm.hasClass('add-subject-form')) {
	                            jForm.attr('action', `/admin/grades/${grade_id}/subjects`);
		                		jForm.attr('method', 'POST');
	                            _self.initForm(jForm, $(this), grade_id, current_element);
                            }
                            if(jForm.hasClass('add-division-form')){
	                            jForm.attr('action', `/admin/grades/${grade_id}/divisions`);
		                		jForm.attr('method', 'POST');
	                            _self.initForm(jForm, $(this), grade_id, current_element);
                            }
                    	}	
                    });
                    
                    schoolGradeContainerEl.find('.data-title').on('click', function () {
     					var current_el = $(this).parent().next();

			    	    if ($(this).find('.no-of-div').hasClass('fa-chevron-down')){
			        		$(this).find('.no-of-div').addClass("fa-chevron-up").removeClass("fa-chevron-down");
			    		}else {
			    			$(this).find('.no-of-div').removeClass("fa-chevron-up").addClass("fa-chevron-down");
			    		}
			        	current_el.slideToggle();
        			});

                    schoolGradeContainerEl.find('.subject-wrapper').each( function () {
        				var current_el = $(this).find(".division-list li:first"),
        					current_division_name = current_el.data('division_name'),
        					current_division_id = current_el.data('division_id');
        					current_el.addClass('active');	
        					if (current_el.length == '0') {
							$(this).find('.current_division').remove('.current_division');
        					}else{	
							$(this).find('.current_division').replaceWith('<span class="current_division" data-division_id="'+ current_division_id +'" ><a>Delete Division ' + current_division_name + '</a></span>');
							}
                    });
       			
        			schoolGradeContainerEl.find('.division-list li').off('click').on('click', function () {
        				var current_el = $(this).parent().closest("div").parent().find(".current_division"), 
        					current_division_name = $(this).data('division_name'),
        					current_division_id = $(this).data('division_id');
							
							current_el.replaceWith('<span class="current_division" data-division_id="'+ current_division_id +'" ><a>Delete Division ' + current_division_name + '</a></span>');
        					_self.deleteDivision();
        			});
        			_self.deleteDivision();	
                }
            }
        });        
    };

    deleteDivision () {
    	let _self = this;

    	$('.current_division').on('click', function () {
			var	current_division_id = $(this).data('division_id'),
				url = '/admin/divisions/'+ current_division_id,
				rm_El = $(this).parent().parent().find(".division-list > li.active"),
				rm_El_data = rm_El.data('division_id'),
                removeUserBtn = $(this),
				msg = 'Division deleted successfully';

            swal({
                    title: "Are you sure?",
                    text: "You want delete division",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes, delete it!"
                },
                function(isConfirm){
                    if (isConfirm) {
                        _self.deleteRequest(url, removeUserBtn, null, function (res) {
                            if(res.success) {
                                if(current_division_id !== ''){
                                    if(rm_El_data == current_division_id){
                                    _self.loadSchoolsGrades();
                                    toastr.success('Division deleted successfully', '', {
                                        positionClass: 'toast-top-right cloud-display'
                                    });
                                    rm_El.remove();
                                    }
                                }
                            }else {
                                _self.showErrors(res.errors);
                            }
                        })
                    }    
                });
        });
    };
}        