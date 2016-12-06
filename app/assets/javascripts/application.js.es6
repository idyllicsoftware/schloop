//= require base
//= require home

class Schloop extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');

        if(['home'].includes(subController)){
            this._main = new Main({action: action});
        }
       	this.initEventListeners();
        return this;
    };
    initEventListeners(){
    	let self = this,
    		reset_password_form = $('.pass-reset-subsection').find('form');
    	
    	$(document).on('click','.pass-show', function() {
    		 if ($(this).html() === "Show") {
		        $(this).html("Hide")
		        $(this).closest('div').find('input:password').attr({type:"text"});
		      } else {
		        $(this).html("Show");
		    	$(this).closest('div').find('input:text').attr({type:"password"});
		      }
    	});
    	reset_password_form.submit(function(){
    		var new_pass = reset_password_form.find('.new').val(),
    			confirm_pass = reset_password_form.find('.confirm').val();

    			if(new_pass != confirm_pass){
    				reset_password_form.find('.show_err').removeClass('hidden');
    				return false;
    			}else{
    				reset_password_form.find('.show_err').removeClass('hidden');
    				return true;
    			}
    	});
    };
}