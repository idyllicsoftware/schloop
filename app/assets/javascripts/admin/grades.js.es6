// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class SchoolGrades extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        let _self = this,
        { school_id } = _self._config;
        _self.loadSchoolsGrades();
        
        $("#add-grade-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby')),
                jForm = popupEl.find('form');
                jForm[0].reset();
                jForm.attr('action', `/admin/schools/${school_id}/grades`);
                jForm.attr('method', 'POST');
                _self.add_grade(jForm, $(this));
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
            	
            	if(jForm.hasClass("add-subject-form")){
                	current_element.find(".subject-list").append("<li><a href='#subject1-tab' data-toggle='tab'>" + res.subject_name +"</a></li>");
             		toastr.success('Subject added successfully');
             	}else{
                 	current_element.parent().find(".division-list").append("<li><a href='#div1-tab' data-toggle='tab'>" + res.division_name +"</a></li>");
             		toastr.success('Division added successfully');
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
                toastr.success(msg);
                popoverEl.popover('hide');
            }else {
                _self.showErrors(res.errors);
            }
        });

        jForm.find('.cancelPopoverBtn').off('click').on('click', function () {
            popoverEl.popover('hide');
        });
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
                    _self.schoolGrades = res.grades.toHash('grade_id'); 

                    schoolGradeContainerEl.html(html);
                    _self.popoverInit(false, schoolGradeContainerEl);

                    schoolGradeContainerEl.find("[data-toggle=popover]").on('shown.bs.popover', function () {
                        let popupEl = $('#' + $(this).attr('aria-describedby')),
                            grade_id = $(this).data('grade_id'),
                            jForm = popupEl.find('form'),
                            current_element = $(this).parent().closest("div");
                            
                        if(_self.schoolGrades.hasOwnProperty(grade_id)){
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
                }
            }
        });        
    };
}        