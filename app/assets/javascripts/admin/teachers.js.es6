//= require_self

class SchoolTeachers extends SchloopBase {
    init (){
        var self = this;
        self.initEventListeners();
        return this;
    };

    globals (){
        return {
            teachers_csv_upload_path: '/admin/teachers/upload'
        }
    };

    initEventListeners (){
        let self = this,
            uploadTeacherModalEl = $("#upload-teachers-modal"),
            { teachers_csv_upload_path } = self.globals();

        $(document).on('click','.upload-sheet', function () {
            uploadTeacherModalEl.modal('show');
        });

        $('#upload-csv-file').change(function(){
            var res=$('#upload-csv-file').val();
            var arr = res.split("\\");
            var filename = arr.slice(-1)[0];
            var filextension = filename.split(".");
            var filext ="."+filextension.slice(-1)[0];
            var valid=[".csv",".jpg"];

            if (valid.indexOf(filext.toLowerCase())==1){      
                $('#namefile').css({"color":"green","font-weight":700,"padding":"20px"});
                $('#namefile').html("You select " + filename + " file.");
            }
        });
        $(".upload-teachers-form").submit(function () {
            var jForm = $(this);

            $.ajax({
                url: teachers_csv_upload_path,
                method: 'POST',
                data: jForm,
                success: function() {
                    uploadTeacherModalEl.modal('hide');
                }
            });
        });
        $(document).on('click','.upload-cancel', function () {
            uploadTeacherModalEl.modal('hide');
        });
    };
}