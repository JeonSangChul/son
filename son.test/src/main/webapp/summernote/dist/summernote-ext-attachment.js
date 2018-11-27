(function (factory) {
    /* global define */
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals
        factory(window.jQuery);
    }
}(function ($) {

    // pull in some summernote core functions
    var ui = $.summernote.ui;
    var dom = $.summernote.dom;

    // define the plugin
    var AttachmentPlugin = function (context) {
        var self = this;
        var options = context.options;
        var lang = options.langInfo;

        self.icon = '<i class="glyphicon glyphicon-paperclip"/>';

        // add context menu button for dialog
        context.memo('button.attachment', function () {
            return ui.button({
                //contents: self.icon,
            	contents: "파일첨부",
                tooltip: lang.attachment.insert,
                click: context.createInvokeHandler('attachment.show')
            }).render();
        });


        self.initialize = function () {
            // create dialog markup
            var $container = options.dialogsInBody ? $(document.body) : context.layoutInfo.editor;

            var body = '<div class="form-group note-form-group note-group-select-from-files">' +
                '<label class="note-form-label">' + lang.attachment.selectFromFiles + '</label>' +
                '<input class="ext-attachment-input form-control note-form-control note-input" type="file" name="files" multiple="multiple"/>' +
                '</div>';
            var footer = '<button href="#" class="btn btn-primary ext-attachment-btn disabled" disabled>'
                + lang.attachment.insert + '</button>';

            self.$dialog = ui.dialog({
                title: lang.attachment.name,
                fade: options.dialogsFade,
                body: body,
                footer: footer
            }).render().appendTo($container);

        };

        self.destroy = function () {
            self.$dialog.remove();
            self.$dialog = null;
        };


        self.show = function () {
            context.invoke('editor.saveRange');
            self.attachmentDialog().then(function (data) { //upload files
                ui.hideDialog(self.$dialog);
                context.invoke('editor.restoreRange');
                if (typeof data === 'string') {
                    console.log('please input local files')
                }else {
                    context.invoke('attachment.attachmentCallback', data); 
                }
            }).fail(function () {
             context.invoke('editor.restoreRange');
            });
        };

        self.attachmentDialog = function () {
            return $.Deferred(function (deferred) {
                var $attachmentInput = self.$dialog.find('.ext-attachment-input');
                var $attachmentBtn = self.$dialog.find('.ext-attachment-btn');

                ui.onDialogShown(self.$dialog, function () {
                    context.triggerEvent('dialog.shown');
                    
                   $attachmentInput.replaceWith($attachmentInput.clone()
                    .on('change', function () {
                    deferred.resolve(this.files || this.value);
                    })
                    .val('')
                     );
                });

                ui.onDialogHidden(self.$dialog, function () {
                    $attachmentInput.off('input keyup');
                    $attachmentBtn.off('click');

                    if (deferred.state() === 'pending') {
                        deferred.reject();
                    }
                });

                ui.showDialog(self.$dialog);
            });
        };

        self.attachmentCallback = function (files) {
            var callbacks = options.callbacks;

            if (callbacks.onAttachmentUpload) {
                context.triggerEvent('attachment.upload', files);
            // else insert Image as dataURL
            } else {
                console.log('attachment.upload')
            // this.insertImages(files);
            }
            
        };

        self.insertAttachmentNode = function (fileurl) {
            var linkUrlDom = document.createElement('a');
             linkUrlDom.setAttribute('target', '_blank')
             linkUrlDom.setAttribute('href', fileurl);
             var RegEx = ".+/(.+)$"; //正则表达式取文件名
             var filename = fileurl.match(RegEx)[1];
             linkUrlDom.innerHTML = filename;
             $("#summernote").summernote('insertNode', linkUrlDom);

        };
    };

    // Extends summernote
    $.extend(true, $.summernote, {
        plugins: {
            attachment: AttachmentPlugin 
        },

          callbacks: {
             onAttachmentUpload:null
          }
        ,
        // add localization texts
        lang: {
            'en-US': {
                attachment: {
                    name: 'Upload Attachment',
                    insert: 'insert attachment',
                    selectFromFiles: 'Select from Files'
                }
            },
            'ko-KR': {
                attachment: {
                    name: '파일 첨부',
                    insert: '파일첨부2',
                    selectFromFiles: '파일선택'
                }
            }
        }

    });

}));