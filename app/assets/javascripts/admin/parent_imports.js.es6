class ParentImports extends SchloopBase {
    init (){
        let _self = this,
            {school_id} = _self._config,
            file_upload = new FileUpload({
                jScope: $("#studentUploadWrapperId")
            });

        var user_name = $('.user_name').text(),
            fname_char = user_name.split(' ')[0].charAt(0),
            lname_char = user_name.split(' ')[1].charAt(0),
            profile_name = fname_char + lname_char;

        $('.profile-photo').html(profile_name.toUpperCase());

        $(document).on("uploadedFileResponse", function (e, res) {
            let {result} = res;
            if(result.success){
                toastr.success('Upload Successful', '', {
                    positionClass: 'toast-top-right cloud-display'
                });
                setTimeout(function () {
                    window.location = `/admin/schools/${school_id}`;
                }, 3000);
            }
        });
        return this;
    }
}