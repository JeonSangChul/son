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
	var upload_count_file = 20;
	var file_tmp = new Array();
	var file_result = new Array();
	var file_cnt = -1;
	
	function done() {

        if (typeof(execAttach) == 'undefined') { //Virtual Function
            return;
        }
		
        if($("#upload_ing").val() == 'Y'){
			alert('이미지 업로드 중입니다');
			return;
		}
        
        $( "#sortable li" ).each(function(i) {
			file_tmp[i] = $( this ).attr('data-key');
		  //console.log( index + ": " + $( this ).children().attr('data-no') );
		});
        
        $.each(file_tmp , function (i,v){
			file_result[i] = _mockdata[v];
		});
        
        for (var i=0; i < file_result.length; i++) {
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
				execAttach(file_result[i]);
				var upload_status = 'Y';
			}
		}
        
        //opener.document.getElementById("upload_status").value = upload_status;
		closeWindow();
        /* var _mockdata = { 'imageurl': fileInfo.imageurl
        				, 'filename': fileInfo.filename
        				, 'filesize': fileInfo.filesize
        				, 'imagealign': fileInfo.imagealign
        				, 'originalurl': fileInfo.originalurl
        				, 'thumburl': fileInfo.thumburl
        				}; 

        execAttach(_mockdata);
        closeWindow(); */

    }
	
	function initUploader(){

        //var _opener = PopupUtil.getOpener();

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
		
		if(app === 'Internet Explorer' &&  version < 10) {
			$('.info_img').hide();
			$('.info_txt').show();
		} else {
			$('.info_img').show();
		}

		if(app !== 'Chrome') {
			if(window.outerWidth && window.innerWidth ) {
				window.resizeTo( $('.pop_wrap').width() + (window.outerWidth - window.innerWidth) + 2, $('.pop_wrap').height() + (window.outerHeight - window.innerHeight) + 3);
			}
		}
		
		var _attacher = getAttacher('image', _opener);
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
        
        //var _attacher = getAttacher('image', _opener);
        //registerAction(_attacher);
    }
	
	function del_file(em) {
		if($(em).hasClass('template-download')) {
			for(var i in _mockdata) {
				if(_mockdata[i]['tempFileId'] == $(em).find('.listDelip_img').attr('data-no')) {
					/*_mockdata.splice(i, 1);
					if(_mockdata.length == 0) {
						$('#upload_status').val('N');
					}*/
				}
			}

			//_filedata_del.push({ file_no: $(em).find('.listDelip_img').attr('data-no') });
			$(em).remove();
			//console.log(_mockdata);
		}
		else {
			del_file($(em).parent());
		}
	}
	
	$(document).ready(function(){
		$('#sortable').sortable();
	});
	</script>
	
</head>
<body onload="initUploader();">
	<div class="pop_wrap file">
		<div class="pop_content ">
			<div class="pop_head">
				<h2>이미지 업로드 하기</h2>
			</div>
			<form name="fileupload" id="fileupload" action="/son/file/multiImgUpload.do" method="post" enctype="multipart/form-data">
				<input type="hidden" name="upload_ing" id="upload_ing" value="N">
				<noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
				<div class="add_area">
					<input type="file" name = "files[]" title="이미지 추가" class="file_add" multiple>
					<button type="button" class="btn_add"><em class="sp_img icon_add "></em>이미지 추가</button>
				</div>
				
				<div class="content_box img_upcont">
					<div class="info_box">
						<div class="info_img">
							<span class="sp_bgimg upload_bgimg"></span>
							<strong>이미지 쉽게 올리기</strong>
							<p>이미지를 드래그&amp;드롭으로 이곳에 올려주시면 됩니다.</p>
						</div>
						<div class="info_txt" style = "display:none;">
							<strong>이미지 쉽게 올리기는</strong>
							<strong>Internet Explorer 10 버전 이상에서 지원합니다.</strong>
							<p>이미지 추가를 클릭해 이미지를 선택해 주십시오.</p>
						</div>
					</div>
					<ul id ="sortable" class = "img_uplist files ui-sortable" style="display: none;"></ul>
				</div>
				
				<div class="file_txtinfo bg">
					<p>이미지 파일은 각각 최대 10MB, 총 20개까지 업로드 가능합니다.</p>
					<p>이미지 파일명이 한글, 숫자, 영문이 아닌 다른 언어일 경우 파일이 업로드되지 않거나 깨질 수 있습니다.</p>
					<p class="font_red">저작권 등 다른 사람의 권리를 침해하거나 명예를 훼손하는 파일은 운영 원칙 및 관계 법률에 의해<br> <em>제재를 받을 수 있습니다.</em></p>
				</div>
			</form>
			<!-- The template to display files available for upload -->
			<script id="template-upload" type="text/x-tmpl">
				{%
					$('.info_img').hide();
					$('.img_uplist').show();
					for (var i=0, file; file=o.files[i]; i++) {
						if (file.error) {
							alert(file.name + ' : '+ file.error);
							return false;
						}
				%}
					<div class="pop_wrap type1" style="left:95px;top:15px;display:block">
						<div class="loding_box">
							<strong class="state_txt">이미지 업로드 중</strong>
							<div class="inner clear fileupload-progress">
								<div class="loding_progress progress" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
									<div class="loding_bar bar" style="width:0%"></div>
								</div>
								<span class="loding_caunt fr">0%</span>
							</div>
						</div>
					</div>
				{% } %}
			</script>
			<script id="template-download" type="text/x-tmpl">
				{%
					$('.info_box').hide();
					$('.img_uplist').show();
					for (var i=0, file; file=o.files[i]; i++) {
						if (file.error) {
							(file.error);
							$('.template-upload').eq(i).remove();
							$('.info_box').show();
							continue;
						}
						file_cnt++;

				%}
                    {% 
                            _mockdata[_mockdata.length]  = {
                                'imageurl': file.url,
                                'filename': file.originFileName,
								'filepath': file.filePath,
                                'filesize': file.fileSize,
                                'imagealign': 'L',
                                'originalurl': file.url,
                                'thumburl': file._s_url,
                                'tempFileId': file.tempFileId,
								'storedName' : file.storedFileName,
								'fileExtsn' : file.fileExtsn
                            };
                    %}
                    <li class="template-download fade" data-key = {%=file_cnt%}>
						{% if (file._s_url) { %}
							<img class="listDelip_img" data-no="{%=file.tempFileId%}" src="{%=file._s_url%}">
							<button type="button" onclick = "del_file(this)"><span class="blind">이미지 삭제</span><em class="sp_img icon_imgup_del"></em></button>
						{% } %}
                    </li>

                {%
					}

				%}
			</script>
			<div class="btn_box">
				<button type="button" class="btn_apply" onclick="done();" title="등록">적용</button>
			</div>
		</div>
		<table role="presentation" class="table"><tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody></table>
	</div>
<script src="/js/vendor/jquery.ui.widget.js"></script>
<script src="/js/tmpl.min.js"></script>
<script src="/js/load-image.min.js"></script>
<script src="/js/canvas-to-blob.min.js"></script>
<script src="/js/jquery.iframe-transport.js"></script>
<script src="/js/jquery.fileupload.js"></script>
<script src="/js/jquery.fileupload-process.js"></script>
<script src="/js/jquery.postmessage-transport.js"></script>
<script src="/js/jquery.fileupload-validate.js"></script>
<script src="/js/jquery.fileupload-ui.js"></script>
<script src="/js/image.js"></script>
</body>

