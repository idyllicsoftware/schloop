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
    	let self = this;

    	$(document).on('click','.pass-show', function() {
    		 if ($(this).html() === "Show") {
		        $(this).html("Hide")
		        $(this).closest('div').find('input:password').attr({type:"text"});
		      } else {
		        $(this).html("Show");
		    	$(this).closest('div').find('input:text').attr({type:"password"});
		      }
    	});
    };
}