// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class Teachers extends SchloopBase {
    init (){
    	let {action} = this._config,
        	_self = this,
            params = {teacher_id: this._config.teacher_id};

        _self.popoverInit(true);
        _self.initEventListeners();
        return this;
    };

    initEventListeners (){
        var _self = this;
        
        // $('#school-Tab li a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        //     let el = $(this),
        //         { tabName } = el.data();

        //     switch (tabName){
        //         case "students":
        //             _self._students.onTabShow();
        //         break;
        //         case "circulars":
        //             //
        //         break;
        //     }

        // });
    };
}