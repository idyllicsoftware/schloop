//= require_self
//= require admin/school_profiles

class Schools extends SchloopBase {
    init (){
        let {action} = this._config;
        if(action == 'index'){
            this.initDashboard();
        }else if(action == 'show'){
            this._schoolProfile = new SchoolProfiles();
        }
    };

    globals (){
        return {
            new_school_path: '/admin/schools/new'
        }
    };

    initDashboard () {
        let self = this,
            createModalEl = $("#create-school-modal"),
            { new_school_path } = self.globals();

        $(document).on('click','#create-school-btn', function () {
            createModalEl.modal('show');
        });

        $(".schools-registraion-form").submit(function () {
            var jForm = $(this),
                formData = jForm.serializeObject();

        	$(".data-title").click( function () {
        		$(".slide-division-wrapper").slideToggle();
        	});
            
            $.ajax({
                url: new_school_path,
                method: 'POST',
                data: formData,
                success: function() {
                    createModalEl.modal('hide');
                }
            });
        });

        $(document).on('click','.cancel-creation', function () {
            createModalEl.modal('hide');
        });

    }
}