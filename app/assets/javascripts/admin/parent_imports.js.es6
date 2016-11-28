class ParentImports extends SchloopBase {
    init (){
        let _self = this,
            {school_id} = _self._config,
            file_upload = new FileUpload();

        $(document).on("uploadedFileResponse", function (e, res) {
            let {result} = res;
            if(result.success){
                toastr.success('Upload Successful');
                setTimeout(function () {
                    window.location = `/admin/schools/${school_id}`;
                }, 3000);
            }
        });
        return this;
    }
}