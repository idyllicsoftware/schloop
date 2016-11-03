class Users extends SchloopBase {

    init (){
        let {action} = this._config;
        this._global = this.globals();
        if(action == 'admin_dashboard'){
            this.initUserDashboard();
        }
    };

    initUserDashboard(){
        let self = this,
            createModalEl = $("#create-school-modal"),
            { new_school_path } = self.globals();

        self.popoverInit();

        $(document).on('click','#create-school-btn', function () {
            createModalEl.modal('show');
        });

        $(".schools-registraion-form").submit(function () {
            var jForm = $(this),
                formData = jForm.serializeObject();

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


$(document).ready(function () {
    $(document).on('click','.upload-sheet', function () {
    	$("#upload-teachers-modal").modal('show');
  
    	$('#upload-csv-file').change(function(){
			    var res=$('#upload-csv-file').val();
			    var arr = res.split("\\");
			    var filename=arr.slice(-1)[0];
			    filextension=filename.split(".");
			    filext="."+filextension.slice(-1)[0];
			    valid=[".csv",".jpg"];
			    if (valid.indexOf(filext.toLowerCase())==-1){
			        $('#namefile').css({"color":"red","font-weight":700,"padding": "20px 0px"});
			        $('#namefile').html("Selected File is not csv");			        
			    }else{
			        $('#namefile').css({"color":"green","font-weight":700,"padding": "20px 0px"});
			        $('#namefile').html(filename + "file is selected");
			    }
			});
    	$(".upload-teachers-form").submit(function () {
    		var jForm = $(this);

			$.ajax({
				url: '/admin/schools/new',
				method: 'POST',
				data: jForm,
				success: function() {
					$("#upload-teachers-modal").modal('hide');
				}
			});	
		});
		$(document).on('click','.upload-cancel', function () {		
			$("#upload-teachers-modal").modal('hide');
		});
    });
});

