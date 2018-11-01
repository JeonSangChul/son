<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/common.css'/>"/>
	<script src="/daumeditor/js/popup.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" href="/daumeditor/css/popup.css" type="text/css"  charset="utf-8"/>
	<link rel="stylesheet" href="/css/image_popup.css" type="text/css"  charset="utf-8"/>
	<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/js/jquery.form.js"></script>
	<script type='text/javascript' src='<c:url value="/js/html5shiv.min.js"/>'></script>
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css"></link>
	<noscript><link rel="stylesheet" href="/css/jquery.fileupload-ui-noscript.css"></noscript>
	
	<!--[if lt IE 9]>
	<script type='text/javascript' src='<c:url value="/js/jquery-1.7.2.min.js"/>'></script>
	<![endif]-->
	<!--[if gte IE 9]>
	<script type='text/javascript' src='<c:url value="/js/jquery-3.2.1.min.js"/>'></script>
	<![endif]-->
	<!--[if !IE]> -->
	<script type='text/javascript' src='<c:url value="/js/jquery-3.2.1.min.js"/>'></script>
	<!-- <![endif]-->
	<script type='text/javascript' src='<c:url value="/js/jquery-ui.min.js"/>'></script>
	

<script type="text/javascript">
	var _mockdata = new Array();
	
	var _opener = PopupUtil.getOpener();
	var file_size = 10485760; 
	var upload_count_file = 5;
	var file_tmp = new Array();
	var file_result = new Array();
	var file_cnt = -1;
	
	function done() {

        if (typeof(execAttach) == 'undefined') { //Virtual Function
            return;
        }
        
        for (var i=0; i<_mockdata.length; i++) {
        	
        	var allAttachmentList = _opener.Editor.getAttachBox().datalist;
			var nCount = 0;
			for( var j=0, n=allAttachmentList.length; j<n; j++ ){
				var entry = allAttachmentList[j];
				if( entry.deletedMark == true ){
					//alert("첨부상자에서 삭제된 파일 : " + entry.data.imageurl);
				} else {
					//alert("첨부상자에 존재하는 파일 : " + entry.data.imageurl);
					nCount++;
				}
			}
			if(nCount >= upload_count_file) {
				alert("최대 업로드 갯수를 초과하였습니다. 허용 첨부파일"+upload_count_file+"개 입니다. 파일첨부 박스에서 다른 첨부파일을 제거하고 업로드 하세요");

			} else {
				execAttach(_mockdata[i]);
				var upload_status = 'Y';
			}
		}
		closeWindow();

    }
	
	function initUploader(){

        if (!_opener) {
            alert('잘못된 경로로 접근하셨습니다.');
            return;
        }
		
        var agent = navigator.userAgent, match;
		var app, version;

		if((match = agent.match(/MSIE ([0-9]+)/)) || (match = agent.match(/Trident.*rv:([0-9]+)/))) app = 'Internet Explorer';
		else if(match = agent.match(/Chrome\/([0-9]+)/)) app = 'Chrome';
		else if(match = agent.match(/Firefox\/([0-9]+)/)) app = 'Firefox';
		else if(match = agent.match(/Safari\/([0-9]+)/)) app = 'Safari';
		else if((match = agent.match(/OPR\/([0-9]+)/)) || (match = agent.match(/Opera\/([0-9]+)/))) app = 'Opera';
		else app = 'Unknown';

		if(app !== 'Unknown') version = match[1];
		
		if(window.outerWidth && window.innerWidth ) {
			window.resizeTo( $('.pop_wrap').width() + (window.outerWidth - window.innerWidth) + 2, $('.pop_wrap').height() + (window.outerHeight - window.innerHeight) + 3);
		}
		
		var _attacher = getAttacher('file', _opener);
	    registerAction(_attacher);
	    
		var allAttachmentList = _opener.Editor.getAttachBox().datalist;

        var nCount = 0;
        for( var i=0, n=allAttachmentList.length; i<n; i++ ){
            var entry = allAttachmentList[i];
            if( entry.deletedMark == true ){
                //alert("첨부상자에서 삭제된 파일 : " + entry.data.imageurl);
            } else {
                //alert("첨부상자에 존재하는 파일 : " + entry.data.imageurl);
                nCount++;
            }
        }

        if(nCount >= upload_count_file) {
            alert("최대 업로드 갯수를 초과하였습니다. 허용 첨부 파일" + upload_count_file + "개 입니다.");
            closeWindow();
            return false;
        }
    }
	
	$(document).ready(function(){
		$(document).on('click', '.btn_del', function () {
			var datano = $(this).attr('data-no');
			
			alert('첨부파일을 삭제합니다.');
			if(datano) {
				for(var i in _mockdata) {
					if(_mockdata[i]['tempFileId'] == datano) {
						_mockdata.splice(i, 1);
					}
				}
				$(this).parents('li').remove();

			} else {
				$(this).parents('li').remove();
			}

		});
	});
	</script>
</head>
<body onload="initUploader();">
	<div class="pop_wrap file">
		<div class="pop_content ">
			<div class="pop_head">
				<h2>파일 업로드 하기</h2>
			</div>
			<form name="fileupload" id="fileupload" action="/son/file/multiFileUpload.do" method="post" enctype="multipart/form-data">
				<input type="hidden" name="upload_ing" id="upload_ing" value="N">
				<noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
				<div class="add_area">
					<input type="file" name = "files[]" title="파일 추가" class="file_add" multiple>
					<button type="button" class="btn_add"><em class="sp_img icon_add "></em>파일 추가</button>
				</div>
				<div class="content_box file_upcont">
					<ul class="file_upbox files"></ul>
					
					<script id="template-upload" type="text/x-tmpl">

					{% for (var i=0, file; file=o.files[i]; i++) { %}
					
						<li class="template-upload fade">
						<span>{%=file.name%} ({%=o.formatFileSize(file.size)%})
						{% if (file.error) { %}
							<em class="font_red">{%=file.error%}</em>
						{% } %}
						</span>
						<button type="button" class="btn_del"><span class="blind">닫기</span><em class="sp_img icon_del "></em></button>
						</li>
					{% } %}
					</script>
					
					<script id="template-download" type="text/x-tmpl">
					{% for (var i=0, file; file=o.files[i]; i++) { %}

						{% if (file.error) { %}
						<li class="template-upload fade">
						<span>{%=file.originFileName%} ({%=o.formatFileSize(file.fileSize)%})
						{% if (file.error) { %}
							<em class="font_red">{%=file.error%}</em>
						{% } %}
						</span>
						<button type="button" class="btn_del"><span class="blind">닫기</span><em class="sp_img icon_del "></em></button>
						</li>
						{% } else { %}
						{%

								_mockdata[_mockdata.length]  = {

									'attachurl': file.url,
									'filesize': file.fileSize,
									'filename': file.originFileName,
									'filepath': file.filePath,
									'tempFileId': file.tempFileId,
									'storedName' : file.storedFileName,
									'fileExtsn' : file.fileExtsn


								};

							}
						%}

					   <li class="template-download fade">
						<span>{%=file.originFileName%} ({%=o.formatFileSize(file.fileSize)%})
						{% if (file.error) { %}
							<em class="font_red">{%=file.error%}</em>
						{% } %}
						</span>
						<button type="button" class="btn_del" data-no="{%=file.tempFileId%}" ><span class="blind">닫기</span><em class="sp_img icon_del"></em></button>
						</li>
					{% } %}
					</script>
					
					<div class="file_txtinfo">
					<script type="text/javascript">
						document.write("<p>파일은 각각 최대  MB, 총 "+upload_count_file+"개까지 업로드 하실 수 있습니다.</p>");
					</script>
					<p>파일명이 한글, 숫자, 영문이 아닌 다른 언어일 경우 파일이 업로드 되지 않거나 깨질 수가 있습니다.</p>
					<p class="font_red">저작권 등 다른 사람의 권리를 침해하거나 명예를 훼손하는 파일은 운영 원칙 및 관계 법률에 의해<br>
					<em>제재를 받을 수 있습니다.</em>
					</p>
					</div>
				</div>
				<div class="btn_box">
					<button type="button" onclick="done();" class="btn_apply" >적용</button>
				</div>
			</form>
		</div>
	</div>
<script src="/js/tmpl.min.js"></script>
<script src="/js/jquery.fileupload.js"></script>
<script src="/js/jquery.fileupload-process.js"></script>
<script src="/js/jquery.postmessage-transport.js"></script>
<script src="/js/jquery.fileupload-validate.js"></script>
<script src="/js/jquery.fileupload-ui.js"></script>
<script src="/js/file.js"></script>
</body>

