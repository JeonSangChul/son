<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>파일첨부</title> 
<script src="/daumeditor/js/popup.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/js/jquery.form.js"></script>
<link rel="stylesheet" href="/daumeditor/css/popup.css" type="text/css"  charset="utf-8"/>
<link rel="stylesheet" href="/css/image_popup.css" type="text/css"  charset="utf-8"/>

<script type="text/javascript">

//다중파일 업로드로 바꾸자.. 
//http://blueimp.github.io/jQuery-File-Upload/index.html  참고 (Git 에 소스 있음. )


$(document).ready(function (){
	$('.file input[type=file]').change(function (){
		var inputObj = $(this).prev().prev(); 
		var fileLocation = $(this).val(); 
		inputObj.val(fileLocation.replace('C:\\fakepath\\','')); 
	}); 
	
	$('#saveBtn').on('click', function () { 
		var page = '${param.page}';  
		
		$('#fileFrm').ajaxSubmit({
			type:'POST',
			url:'/son/file/fileUpload.do',
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			dataType:'json',
            beforeSubmit: function (data,form,option) {
                //validation체크 
                //막기위해서는 return false를 잡아주면됨
                return true;

            },

            success: function(fileInfo){
                //성공후 서버에서 받은 데이터 처리
                done(fileInfo);
            },

            error: function(request,status,e){
                //에러발생을 위한 code페이지
                alert("code:"+request.status+"\n"+"messgae:"+request.responseText+"\n"+"error:"+e);
            }                               
        });
		
    });
});
	
	function done(fileInfo) {
		
		alert(fileInfo);
		
		if (typeof(execAttach) == 'undefined') { //Virtual Function
	        return;
	    }
		
		var _mockdata = {
			'attachurl': fileInfo.attachurl,
			//'filemime': fileInfo.filemime,
			'filename': fileInfo.filename,
			'filesize': fileInfo.filesize
		};
		execAttach(_mockdata);
		closeWindow();
	}

	function initUploader(){
	    var _opener = PopupUtil.getOpener();
	    if (!_opener) {
	        alert('잘못된 경로로 접근하셨습니다.');
	        return;
	    }
	    
	    var _attacher = getAttacher('file', _opener);
	    registerAction(_attacher);
	}
	
		
</script>
</head>
<body onload="initUploader();">
<div class="wrapper">
	<div class="header">
		<h1>파일 첨부</h1>
	</div>	
	<div class="body">
		<dl class="alert">
		    <dt>5MB이하만 가능합니다.</dt>
		    <dd>
		    	<form id="fileFrm" encType="multipart/form-data" method="post">
		    		<div class="file">
		    			<input disabled class="file-text">
		    			<label class="file-btn" for=uploadInputBox>파일첨부</label>
		    			<input id=uploadInputBox style="display:none;" type="file" name="uploadFile">
		    		</div>
		    	</form>
		    </dd>
		</dl>
	</div>
	<div class="footer">
		<p><a href="#" onclick="closeWindow();" title="닫기" class="close">닫기</a></p>
		<ul>
			<li class="submit"><a href="#" id="saveBtn" title="등록" class="btnlink">등록</a> </li>
			<li class="cancel"><a href="#" onclick="closeWindow();" title="취소" class="btnlink">취소</a></li>
		</ul>
	</div>
</div>
</body>
</body>
</html>
