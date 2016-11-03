//= require base
//= require admin/users/dashboards


class SchloopAdmin extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');

        if(['admin_users_dashboards'].includes(subController)){
            this._users = new Users({action: action}).init();
        }
    }
}