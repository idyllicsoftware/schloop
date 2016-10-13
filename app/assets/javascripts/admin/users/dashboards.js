// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
	
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
});

