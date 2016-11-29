//= require jquery-file-upload/jquery.fileupload
//= require_self

class FileUpload {
    constructor (config = {}) {
        let oUpload = this,
            {isImageUpload=false} = config;
        oUpload._config = config;
        oUpload._config.allowedFileTypes = !isImageUpload ? ["doc", "docx", "pdf", "xls", "xlsx", "csv", "xlsm"] : ['jpg', 'jpeg', 'png', 'gif'];
        oUpload.limitMultiFileUploadSize = (typeof config !== 'undefined' && config.limitMultiFileUploadSize) ? config.limitMultiFileUploadSize : 10000000;
        oUpload.file_ids = [];

        this.init();
        return this;
    };

    get isValidForm(){
        return this._config.isValidForm || false;
    }

    init (){
        var oUpload = this,
            jScope = oUpload._config.jScope || $(document);

        oUpload.selectedFilesTable = jScope.find(".selected_files");
        oUpload.fileDetails = jScope.find(".fileDetails");

        oUpload.uploadsBlock = jScope.find(".file_upload_files--upload-block");

        oUpload.uploadsBtn = oUpload.uploadsBlock.find(".uploadBtn");
        oUpload.progressBarWrap = jScope.find('.progressWrap');

        oUpload.currentAddedFileSize = 0;
        oUpload.uploadFailedFlag = false;
        oUpload.fileUpload = jScope.find(".fileuploadInput");
        oUpload.fileUpload_container = jScope.find(".file_upload_files--fileUploadBtn");
        oUpload.hasmultiple = oUpload.fileUpload_container.children('input').is('[multiple]');

        oUpload.initFileUploadWidget();

        return this;
    };


    addFileRow (currentFile) {
        var oUpload = this
            , jFileSelection = $(Mustache.render($("#selectedFileTr").html(), currentFile))
            ;

        oUpload.uploadsBtn.prop("disabled", false).removeClass("disabled");
        jFileSelection.appendTo(oUpload.selectedFilesTable);
        return jFileSelection;
    };

    clearErrorMessages() {
        var oUpload = this,
            jScope = oUpload._config.jScope || $(document);
        jScope.find(".uploadFiles_btn_container .errorMessage").fadeOut().remove();
        jScope.find(".file_upload_files--selector .errorMessage").fadeOut().remove();
        jScope.find(".file_upload_files--sub-selection .errorMessage").fadeOut().remove();
    };

    addFileAllowed (file){
        var oUpload = this
            , jScope = oUpload._config.jScope || $(document)
            , fileNameSplit = file.name.split(".")
            , fileNameExt = fileNameSplit[fileNameSplit.length - 1]
            ;

        if ((oUpload.currentAddedFileSize + file.size) > jScope.find(".fileuploadInput").data("blueimpFileupload").options.limitMultiFileUploadSize) {
            $("<div class='errorMessage' style='margin-left: 15px;'>"+ oUpload.limitMultiFileUploadSize / 1000000 +"MB total file size limit reached.</div>").appendTo(oUpload.uploadsBlock).fadeIn();
            return false;
        } else {
            jScope.find('.errorMessage').remove();
        }

        if (!oUpload.isFileTypeAllowed(fileNameExt)) {
            return false;
        }

        oUpload.currentAddedFileSize += file.size;
        return true;
    };

    isFileTypeAllowed (fileExt) {
        let oUpload = this,
            {isImageUpload=false, allowedFileTypes} = oUpload._config,
            msg = !isImageUpload ? `Please only upload files with doc, docx, pdf, xls, xlsx, or csv extensions.` : `Please only upload files with jpg, jpeg, or png extensions.`;

        if (allowedFileTypes.indexOf(fileExt.toLowerCase()) < 0) {
            $(`<div class='errorMessage'>${msg}</div>`).appendTo(oUpload.uploadsBlock).fadeIn();
            return false;
        }

        return true;
    };

    uploadFailed () {
        var oUpload = this;

        oUpload.uploadFailedFlag = true;
        oUpload.uploadsBtn.text('upload').prop("disabled", false).removeClass("disabled");
        oUpload.fileDetails.prop("disabled", false).removeClass("disabled");
    };

    submitAllowed () {
        var oUpload = this;

        oUpload.clearErrorMessages();
        oUpload.uploadsBtn.text('uploading...').prop("disabled", true).addClass("disabled");
        oUpload.fileDetails.prop("disabled", true).addClass("disabled");

        return true;
    };

    fileUploaded (fileInfo) {
        var oUpload = this
            , trHTML = Mustache.render($("#uploadedFileTr").html(), fileInfo)
            , jDisplayTable = $(".file_upload_files--table")
            , jDisplayTableBody = jDisplayTable.find("tbody")
            ;

        jDisplayTableBody.append(trHTML).fadeIn();
    };

    uploadsFinished () {
        var oUpload = this;

        if(!oUpload.uploadFailedFlag){
            oUpload.uploadsBtn.text('upload finished');
        }

        oUpload.fileUpload.prop("disabled", false).removeClass("disabled");
        oUpload.progressBarWrap.fadeOut();
        oUpload.fileUpload_container.removeClass("disabled");

        $(document).trigger("uploadFinished", {ids: oUpload.file_ids});
        setTimeout(function () {
            oUpload.resetForm();
        }, 2000);
    };

    resetForm () {
        var oUpload = this;
        oUpload.file_ids = [];
        if(!oUpload.uploadFailedFlag){
            oUpload.clearErrorMessages();
            oUpload.uploadsBtn.text('upload').prop("disabled", true).addClass("disabled");
        }

        oUpload.fileUpload.prop("disabled", false).removeClass("disabled");
        oUpload.progressBarWrap.find('.progress-bar').css('width', '0%').attr('aria-valuenow', 0).find("span").html("0%");
    };

    destroyFileUploadWidget () {
        this.fileUpload.fileupload('destroy');
    };

    afterFileUploaded (isfileuploaded) {
        var oUpload = this;

        if(isfileuploaded){
            $(document).trigger("fileAddeed", isfileuploaded);
            if (!oUpload.hasmultiple) {
                oUpload.fileUpload_container.addClass("disabled");
            }
        }
    };

    initFileUploadWidget(){
        var oUpload = this,
            {isImageUpload=false, jScope=$(document)} = oUpload._config;

        oUpload.fileUpload.fileupload({
            dataType: 'json',
            acceptFileTypes: !isImageUpload ? /(\.|\/)(doc|docx|pdf|xls|xlsx|csv)$/i : /(\.|\/)(gif|jpe?g|png)$/i,
            limitMultiFileUploadSize: oUpload.limitMultiFileUploadSize,
            maxNumberOfFiles: 1,
            autoUpload: true,
            maxFileSize: 999000,
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
            previewMaxWidth: 100,
            previewMaxHeight: 100,
            previewCrop: true,
            add: function (e, data) {
                var currentFile = data.files[0];
                oUpload.clearErrorMessages();
                if (!oUpload.addFileAllowed(currentFile)) {
                    return false;
                }
                data.context = oUpload.addFileRow(currentFile);
                var isFileUploaded = true;
                oUpload.afterFileUploaded(isFileUploaded);

                data.context.find(".delete").on("click", function () {
                    var self = $(this);
                    swal({
                            title: "Are you sure?",
                            text: "you want to unselect the file?",
                            type: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "Yes",
                        },
                        function(){
                            data.context = null;
                            self.closest(".selectedFile").fadeOut().remove();
                            oUpload.clearErrorMessages();
                            if (jScope.find(".selected_files tr").length < 1) {
                                oUpload.uploadsBtn.text('upload').prop("disabled", true).addClass("disabled");
                                oUpload.fileUpload_container.removeClass("disabled");
                            }
                            oUpload.currentAddedFileSize -= currentFile.size;
                        });
                });

                oUpload.uploadsBtn.click(function (e) {
                    if(oUpload.isValidForm){
                        data.submit();
                    }else {
                        data.submit();
                    }
                    e.preventDefault();

                });
            },
            submit: function (e, data) {
                oUpload.clearErrorMessages();
                if (!data.context || !data.context.is(":visible") || !oUpload.submitAllowed()) {
                    return false;
                }

                data.context.find(".delete").prop("disabled", true);
                data.formData = oUpload.fileDetails.serializeArray();
                oUpload.uploadFailedFlag = false;
            },
            done: function (e, data) {
                var currentFileInfo = null,
                    errors = data.result.errors || [],
                    onError = function(){
                        oUpload.uploadFailedFlag = true;
                        jScope.find(".file_upload_files--upload-block .errorMessage").remove();
                        $.each(data.result.errors, function (index, error) {
                            $("<div class='errorMessage' style='margin-left: 15px;'>" + error + "</div>").appendTo(oUpload.uploadsBlock).fadeIn();
                        });

                        jScope.find('.progressWrap').fadeOut(function () {
                            jScope.find('.progress-bar').css('width', '0%').attr('aria-valuenow', 0).find("span").html("0%");
                        });
                        data.context.find(".delete").prop("disabled", false);
                        oUpload.uploadsBtn.text('upload').prop("disabled", false).removeClass("disabled");
                    };
                if(errors.length){
                    onError();
                } else {
                    var ids = [];
                    if(data.result.files){
                        for(var i=0; i < data.result.files.length; i++){
                            currentFileInfo = data.result.files[i];
                            if (currentFileInfo) {
                                ids.push(currentFileInfo.id);
                                oUpload.file_ids.push(currentFileInfo.id);
                                oUpload.fileUploaded(currentFileInfo);
                                if(data.context) {
                                    data.context.fadeOut().remove();
                                    delete data.context;
                                    oUpload.currentAddedFileSize -= data.files[0].size;
                                }
                                data.files = [];
                            } else {
                                onError();
                            }
                        }
                        if(ids.length){
                            $(document).trigger("uploadedFileIds", {ids: ids});
                        }
                    }else {
                        $(document).trigger("uploadedFileResponse", {html: data.result.html, result: data.result});
                    }
                }
            },
            stop: function (e, data) {
                oUpload.uploadsFinished();
                data.files = [];
            },
            progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                jScope.find('.progressWrap').show();
                jScope.find('.progress-bar').css('width', progress + '%').attr('aria-valuenow', progress).find("span").html(progress + "%");
                if (progress === 100) {
                    jScope.find('.progress-bar').removeClass("active");
                }
            },
            fail: function (e, data) {
                $("<div class='errorMessage'>" + data.response().errorThrown + "</div>").appendTo(oUpload.uploadsBlock).fadeIn();
                data.context.find(".delete").prop("disabled", false);
                oUpload.uploadFailed();
            }
        });
    }

}