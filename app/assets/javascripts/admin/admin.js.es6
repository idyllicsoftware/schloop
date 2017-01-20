//= require base
//= require admin/schools
//= require admin/parent_imports
//= require admin/teachers/teacher_dashboard
//= require admin/teachers/collaborations
//= require admin/teachers/followups

class SchloopAdmin extends SchloopBase {
    init (){
        let {controller, action} = this._config,
            subController = controller.split("/").join('_');
        
        if(['admin_teachers_dashboards'].includes(subController)){
            this._teacher_dashboard = new TeacherDashboard(this._config);
            this._collaborations = new Collaborations(this._config);
            this._followups = new Followups(this._config);
        }
        if(['admin_schools'].includes(subController)){
            this._schools = new Schools(this._config);
        }

        if(['admin_parent_imports'].includes(subController)) {
            this._parentImports = new ParentImports(this._config);
        }
        this.initUserChangePasswordForm();
        return this;
    }
}
