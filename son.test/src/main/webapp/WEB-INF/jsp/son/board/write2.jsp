<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link href="//netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script> 
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
<link href="/summernote/dist/summernote.css" rel="stylesheet">
<script src="/summernote/dist/summernote.js"></script>
<script src="/summernote/dist/lang/summernote-ko-KR.js"></script>
<script src="/summernote/dist/summernote-iframe.js"></script>
<script src="/summernote/dist/summernote-ext-attachment.js"></script> 

<!-- <link href="//cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.css" rel="stylesheet">
<script src="//cdnjs.cloudflare.com/ajax/libs/summernote/0.8.8/summernote.js"></script> --> 


<script type="text/javascript">

var fileCheck = {
		 acceptFileTypes :/(.|\/)(flv|swf|smi|txt|pdf|hwp|xls|xlsx|sql)$/i
		,acceptImageTypes : /(.|\/)(gif|jpe?g|png|bmp)$/i
		,maxImageSize:10485760 //10메가
		,maxFileSize:15728640 //15메가
		,minSize:1 //10메가
	}

$(document).ready(function (){
	$('#summernote').summernote({
		minHeight: 300,
		lang: 'ko-KR', 
		codemirror:{
			theme:'monokai'
		},
		toolbar: [
			['style', ['style']],
			['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
			['color', ['color']],
			['table',['table']],
			['insert', ['link', 'picture', 'hr','video','media','attachment']],
			['view', ['fullscreen', 'codeview']],
		//	['mybtn', ['attachment']],
			['help', ['help']]
			
		],
		callbacks:{
			onImageUpload: function(files, editor, welEditable){
				sendImage(files, this);
			},
			onAttachmentUpload: function (files) {
				sendFile(files);
			},
			onInit: function(){
				if($(window).height() > 400){
					$('.note-editable').css('max-height', $(window).height()-200);
				}
			}
		}
		
	});
	
	$(document).on('click', '.btn_del', function () {
		
		if(!confirm('첨부파일을 삭제 하시겠습니까?')) return;
		
		var tempFileId = $(this).attr('tempFileId');
		var param = {};
		param.tempFileId = tempFileId;
		var delLi = $(this).parent();
		$.ajax({
			type:"POST",
	    	cache:false,
	    	async:false,
	    	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
	    	url:"<c:url value='/son/file/deleteTempFile.do'/>",
	    	data:param,
	    	beforeSend : function(xhr){
	    		xhr.setRequestHeader("AJAX-CALL", "true");
	    	},
	    	success : function(data) {
	    		if(data.success == "Y"){
	    			delLi.remove();
	    		}else{
	    			alert("작업중 오류가 발생했습니다.");
	    		}
	    	}
		});
	});
	
	$("#create").click(function(){
		var title = $("#title").val();
		var fileItem = [];
		
		if($.trim(title).length == 0){
			alert("제목을 입력해 주십시오.");
			$("#title").focus();
			return;
		}
		
		var isEmpty = $('#summernote').summernote('isEmpty');
		
		if(isEmpty){
			alert("내용을 입력해 주십시오.");
			$('#summernote').summernote('focus');
			return;
		}
		
		var frmData = new FormData();
		$("#fileAttach").find('li').each(function(index){
			var fileData = {};
			fileData.tempFileId = $(this).attr("tempFileId");
			fileItem.push(fileData);
			
			frmData.append('tempFileId',$(this).attr("tempFileId"));
		});
		
		frmData.append('boardId',"${master.boardId}");
		frmData.append('title',title);
		frmData.append('content',encodeURIComponent($('#summernote').summernote('code')));
		
		$.ajax({
			type:"POST",
	    	cache:false,
	    	async:false,
	    	contentType:false,
	    	processData:false,
	    	url:"<c:url value='/son/board/save2.do'/>",
	    	data:frmData,
	    	beforeSend : function(xhr){
	    		xhr.setRequestHeader("AJAX-CALL", "true");
	    	},
	    	success : function(data) {
	    		if(data.resultCd == "Success"){
	    			location.href ="<c:url value='/son/board/detail.do?boardId=${master.boardId}&idx='/>"+data.idx;
	    		}else{
	    			alert("작업중 오류가 발생했습니다.");
	    			return false;
	    		}
	    	}
		});
		
	});
});

function sendImage(files, el){
	var frmData = new FormData();
	
	for(var i=0; i<files.length;i++){
		
		if(!(fileCheck.acceptImageTypes.test(files[i].type) || fileCheck.acceptFileTypes.test(files[i].name))){
			alert("'"+files[i].name+"' 해당파일은 등록 가능한 이미지 파일 확장자가 아닙니다.");
			return;
		}
		
		if(fileCheck.maxImageSize < files[i].size){
			alert("'"+files[i].name+"' 해당파일은 업로드 허용용량을 초과 했습니다.");
			return;
		}
		
		if(fileCheck.minSize > files[i].size){
			alert("'"+files[i].name+"' 해당파일의 크기가 0");
			return;
		}
		
		frmData.append('imageFile',files[i]);
	}
	
	
	$.ajax({
		type:"POST",
    	cache:false,
    	async:false,
    	contentType:false,
    	processData:false,
    	url:"<c:url value='/son/file/multiImgUpload2.do'/>",
    	data:frmData,
    	beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
    	success : function(data) {
    		
    		for(var i =0; i < data.files.length; i++){
    			$(el).summernote('editor.insertImage',data.files[i].url);
    		}
    		
    	}
	});
}



function sendFile(files, el){
	
	var frmData = new FormData();
	
	for(var i=0; i<files.length;i++){
		if(!(fileCheck.acceptFileTypes.test(files[i].type) || fileCheck.acceptFileTypes.test(files[i].name))){
			alert("'"+files[i].name+"' 해당파일은 등록 가능한 파일 확장자가 아닙니다.");
			return;
		}
		
		if(fileCheck.maxFileSize < files[i].size){
			alert("'"+files[i].name+"' 해당파일은 업로드 허용용량을 초과 했습니다.");
			return;
		}
		
		if(fileCheck.minSize > files[i].size){
			alert("'"+files[i].name+"' 해당파일의 크기가 0");
			return;
		}
		
		frmData.append('file',files[i]);
	}
	
	$.ajax({
		type:"POST",
    	cache:false,
    	async:false,
    	contentType:false,
    	processData:false,
    	url:"<c:url value='/son/file/multiFileUpload2.do'/>",
    	data:frmData,
    	beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
    	success : function(data) {
    		
    		for(var i =0; i < data.files.length; i++){
    			var fileHtml = "<li tempFileId=\""+data.files[i].tempFileId+"\"><span>"+data.files[i].originFileName+" ("+data.files[i].fileSize+" byte)</span>"
    			fileHtml = fileHtml+"<button type=\"button\" tempFileId=\""+data.files[i].tempFileId+"\" class=\"btn_del\"><span class=\"blind\">삭제</span></button></li>";
    			$("#fileAttach").append(fileHtml);
    		}
    		
    	}
	});
	
	
}

function fn_show(){
	 $('.output').html($('#summernote').summernote('code')); 
}
</script>

<div class="content">
	<h3><c:out value="${master.boardName }" /></h3>
</div>

<div class="panel-body">
	<form class="article-form" name="frm" id="frm" method="post">
		<fieldset class="form">
			<div class="form-group has-feedback">
				<div>
					<input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력해 주세요." required/>
				</div>
			</div>
			<div class="form-group has-feedback">
				<textarea name="content" id="summernote" class="form-control" ></textarea>​
			</div>
		<ul id="fileAttach"></ul>
		<div class="nav" role="navigation">
			<fieldset class="buttons">
				<a class="btn btn-default btn-wide" onclick="return confirm('취소하시겠습니까?')" href="<c:url value='/son/board/list.do?boardId=${master.boardId}'/>">취소</a>
				<button class="create btn btn-success btn-wide pull-right" id="create" name ="create" type="button">저장</button>
			</fieldset>	
		</div>
		</fieldset> 
	</form>
</div>