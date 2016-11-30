//= require base
//= require admin/schools
//= require admin/parent_imports

class SchloopAdmin extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');

        if(['admin_schools'].includes(subController)){
            this._schools = new Schools(this._config);
        }
        if(['admin_parent_imports'].includes(subController)) {
            this._parentImports = new ParentImports(this._config);
        }
        return this;
    }
}