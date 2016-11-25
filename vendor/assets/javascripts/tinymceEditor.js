tinymce.init({
	selector: "textarea.tinymce",
	toolbar: ' bold italic | bullist, numlist | link image | insertfile',
	menubar: false,
	theme: 'modern',
	statusbar: false,
	plugins: 'code',
    height: 300,
    plugins: [
    	'advlist autolink lists link image charmap print preview anchor',
    	'searchreplace visualblocks code fullscreen',
    	'insertdatetime media table contextmenu paste code'
	],
});
