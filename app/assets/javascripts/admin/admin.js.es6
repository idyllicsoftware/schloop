//= require base
//= require admin/schools

class SchloopAdmin extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');

        if(['admin_schools'].includes(subController)){
            this._schools = new Schools({action: action}).init();
        }
    }
}