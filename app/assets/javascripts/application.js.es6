//= require base
//= require home

class Schloop extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');

        if(['home'].includes(subController)){
            this._main = new Main({action: action}).init();
        }
        return this;
    }
}