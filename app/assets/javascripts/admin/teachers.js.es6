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