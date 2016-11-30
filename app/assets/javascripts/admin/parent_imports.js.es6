class ParentImports extends SchloopBase {
    init (){
        let _self = this,
            {school_id} = _self._config,
            file_upload = new FileUpload({
                jScope: $("#studentUploadWrapperId")
            });

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