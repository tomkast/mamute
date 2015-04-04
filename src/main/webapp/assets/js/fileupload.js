if (Globals.inHouseUploading) {
    $(function() {
        $(".add-file").click(function(e) {
            e.preventDefault();
            createUploader();
        });

        function putInQuestionContent() {
            var link = $(this);
            var id = link.data("attachment-id");
            var fileMarkup = "![/questions/attachments/" + id + "][" + id + "]";

            var fileRef = "[" + id+ "]: /questions/attachments/" + id;

            var content = $(".description-input").text();
            $(".description-input").text(content + " " + fileMarkup + "\n\n" + fileRef);
        }

        function removeAttachment(e) {
            e.preventDefault();
            var link = $(this);
            link.css("pointer-events", "none");
            var id = link.data("attachment-id");
            $.ajax({
                url: '/questions/attachments/' + id,
                type: 'DELETE',
                success: function(result) {
                    $("#attachment-" + id).remove();
                    $("#input-attachment-" + id).remove();
                }
            });
        }

        Globals.removeAttachment = removeAttachment;
        $(".remove-attachment").on("click", removeAttachment);
    });

    function createUploader(chunk, postProcessing) {
        var uploader = $(".attachment-uploader").show();
        $(".cancel-upload").click(function(e){
            e.preventDefault();
            uploader.hide();
        });

        uploader.find("input").remove();
        var uploaderContent = uploader.find(".upload-content");
        var uploadInput = uploaderContent.append($("<input type='file'>"));
        var uploadCompleted = function (err, xhr) {
            if (err) {
                var error = $("<p class='error' style='margin:0'>").text("An error occurred during upload");
                uploaderContent.append(error);
            } else {
                var attachment = JSON.parse(xhr.response);
                var attachmentId = $("<input>")
                    .attr("type" ,"hidden")
                    .attr("name", "attachmentsIds[]")
                    .attr("value", attachment.id)
                    .attr("id", "input-attachment-" + attachment.id);
                $(".question-form").append(attachmentId);
                addUploadedFile(attachment);
                if (chunk) {
                    var commandProto = Globals.markdownCommandManager;
                    commandProto.doLinkOrImage(chunk, postProcessing, true, "/questions/attachments/" + attachment.id);
                }
                uploader.hide();
            }
        };

        var onUpload = function (e) {
            $(this).unbind(e);
            var file = FileAPI.getFiles(e)[0];
            FileAPI.upload({
                url: '/questions/attachments',
                files: {file: file},
                complete: uploadCompleted
            });
        };
        uploadInput.change(onUpload);

        var addUploadedFile = function(attachment) {
            var line = $("<tr>");
            var id = attachment.id;
            line.attr("id", "attachment-" + id);

            line.append($("<td>").text(attachment.name));
            line.append($("<td>").append(attachmentLink()));
            line.append($("<td>").append(removeLink(attachment)));

            $(".uploaded-files").append(line);
            $(".uploaded-files").removeClass("hidden");


            function removeLink(attachment) {
                return $("<a href='#'>").text("Remove")
                    .attr("data-attachment-id", attachment.id)
                    .click(Globals.removeAttachment)
                    .addClass("remove-attachment");
            }
            function attachmentLink() {
                return $("<a>")
                    .attr("href", '/questions/attachments/' + attachment.id)
                    .text('/questions/attachments/' + attachment.id);
            }

        }
    }
    Globals.doimage = createUploader;
} else {
    Globals.doimage = function (chunk, postProcessing) {
        var commandProto = Globals.markdownCommandManager;
        filepicker.setKey(INK_API_KEY);
        var fp;
        var featherEditor = new Aviary.Feather({
            apiKey: AVIARY_API_KEY,
            apiVersion: 2,
            tools: 'crop,resize,draw,text',
            fileFormat: 'jpg',
            onClose: function(isDirty){
                if(isDirty){
                    filepicker.remove(fp);
                }
            },
            onSave: function(imageID, newURL) {
                filepicker.storeUrl(
                    newURL,
                    function(FPFile){
                        filepicker.remove(
                            fp,
                            function(){
                                commandProto.doLinkOrImage(chunk, postProcessing, true, FPFile.url);
                            }
                        );
                    }
                );

                featherEditor.close();
            },

            language: 'pt_BR'
        });

        var preview = document.getElementById('image-editor-preview');

        filepicker.pick({
            mimetype: 'image/*',
            container: 'modal',
            maxSize: 400*1024,
            services: ['COMPUTER', 'URL']
        },

        function(fpfile){
            fp = fpfile;
            preview.src = fpfile.url;
            featherEditor.launch({
                image: preview,
                url: fpfile.url
            });
        });
    };
}