// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
	
	$('body').on('click', function (e) {
    $('[data-toggle="popover"]').each(function () {
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            $(this).popover('hide');
        }
    });
	});

	$(document).on('click','#create-school-btn', function () {
		
		$("#create-school-modal").modal('show');
		$(".schools-registraion-form").submit(function () {
			var jForm = $(this),
				formData = jForm.serializeObject();

			$.ajax({
				url: '/admin/schools/new',
				method: 'POST',
				data: formData,
				success: function() {
					$("#create-school-modal").modal('hide');
				}
			});	
		});
		$(document).on('click','.cancel-creation', function () {		
			$("#create-school-modal").modal('hide');
		});
	});
	
	$("[data-toggle=popover]").popover({
        html : true, 
        content: function() {
        	var data_content = $(this).data("value");	
          return $("#" + data_content).html();
        }
    });

	$(".data-title").click( function () {
		$(".slide-division-wrapper").slideToggle();
	});

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

