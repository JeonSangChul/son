/*
 * jQuery File Upload Plugin JS Example 8.2
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/*jslint nomen: true, regexp: true */
/*global $, window, navigator, blueimp */

$(function () {
    'use strict';

	if (!_opener) {
		alert('잘못된 경로로 접근하셨습니다.');
		return;
	}

	var file_30_group = new Array();
	
	for (var i=0; i<file_30_group.length; i++) {
		if (id == file_30_group[i]) {
			upload_count_file = 30;
		}
	}

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: '/son/file/multiImgUpload.do',
        autoUpload: true,
		maxFileSize: file_size,
		minFileSize: 1,
        maxNumberOfFiles: upload_count_file,
        sequentialUploads: true,
		acceptFileTypes: /(.|\/)(gif|jpe?g|png|bmp)$/i
    });

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        '/result.html?%s'
    );

});

