<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	$("#cmtSave").click(function(){
		var param = {};
		var commentContent = $("#commentContent").val();
		
		if(trim(commentContent).length == 0){
			alert("댓글 내용을 입력해 주십시오.");
			$("#commentContent").focus();
			return;
		}
		
		if(!confirm("댓글을 저장 하시겠습니까?")) return;
		
		param.boardId = "${result.boardId}";
		param.idx = "${result.idx}";
		param.commentContent = encodeURIComponent(commentContent);
		
		$.ajax({
			type : "POST",
			cache:false,
			async : false,
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			url : "<c:url value='/son/comment/commentSave.do'/>",
			data : param,
			beforeSend : function(xhr){
	    		xhr.setRequestHeader("AJAX-CALL", "true");
	    	},
			success : function( data ){
				$("#comtListView").html(data);
				$("#commentContent").val("");
			},error: function(request,status,e){
    			alert("작업중 오류가 발생했습니다.");
    			return;
    		}
			
		});
	});
	
	
});

function fn_commentSearch(pageNo){
	var param = {};
	
	param.boardId = "${result.boardId}";
	param.idx = "${result.idx}";
	param.pageIndex = pageNo;
	
	$.ajax({
		type : "POST",
		async : false,
		cache:false,
		contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		url : "<c:url value='/son/comment/commentList.do'/>",
		data : param,
		beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
		success : function( data ){
			$("#comtListView").html(data);
		}
		
	});
	
}

function fn_commentDelete(obj){
	
	
	if(!confirm("댓글을 삭제 하시겠습니까?")) return;
	
	var commentId = $(obj).attr('comment-id');
	
	var param = {};
	
	param.boardId = "${result.boardId}";
	param.idx = "${result.idx}";
	param.commentId = commentId;
	
	$.ajax({
		type : "POST",
		cache:false,
		async : false,
		contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		url : "<c:url value='/son/comment/commentDelete.do'/>",
		data : param,
		beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
		success : function( data ){
			$("#comtListView").html(data);
			$("#commentContent").val("");
		},error: function(request,status,e){
			alert("작업중 오류가 발생했습니다.");
			return;
		}
	});
}


function fn_commentEdit(obj){
	/* $("#cmtContentTxt").show(); */
	var cmtContent = $(obj).parent().parent().parent().find("#cmtContent");
	var cmtContentTxt = $(obj).parent().parent().parent().find("#cmtContentTxt");
	$(obj).parent().parent().parent().find("#cmtContentTxt textarea").text(cmtContent.html().replace(/<br\s?\/?>/g,"\n"));
	$(obj).parent().find("#commentDelete").hide();
	$(obj).hide();
	$(obj).parent().find("#commentUpdate").show();
	$(obj).parent().find("#commentCancle").show();
	cmtContent.hide();
	cmtContentTxt.show();
	//$(obj).parent().parent().parent().find("#cmtContentTxt")
	
}

function fn_commentUpdate(obj){
	var commentId = $(obj).attr('comment-id');
	var commentContentTxt = $(obj).parent().parent().parent().find("#cmtContentTxt textarea").text();
	var param = {};
	
	if(trim(commentContentTxt).length == 0){
		alert("댓글 내용을 입력해 주십시오.");
		$(obj).parent().parent().parent().find("#cmtContentTxt textarea").focus();
		return;
	}
	
	if(!confirm("댓글을 저장 하시겠습니까?")) return;
	
	
	param.boardId = "${result.boardId}";
	param.idx = "${result.idx}";
	param.commentId = commentId;
	param.commentContent = encodeURIComponent(commentContentTxt);
	
	$.ajax({
		type : "POST",
		cache:false,
		async : false,
		contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		url : "<c:url value='/son/comment/commentUpdate.do'/>",
		data : param,
		beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
		success : function( data ){
			$("#comtListView").html(data);
			$("#commentContent").val("");
		},error: function(request,status,e){
			alert("작업중 오류가 발생했습니다.");
			return;
		}
		
	});
	
	
}

function fn_commentCancle(obj){
	
	if(!confirm("댓글 수정을 취소 하시겠습니까?")) return;
	
	var cmtContent = $(obj).parent().parent().parent().find("#cmtContent");
	var cmtContentTxt = $(obj).parent().parent().parent().find("#cmtContentTxt");
	$(obj).parent().parent().parent().find("#cmtContentTxt textarea").text("");
	$(obj).parent().find("#commentDelete").show();
	$(obj).parent().find("#commentEdit").show();
	$(obj).hide();
	$(obj).parent().find("#commentUpdate").hide();
	
	cmtContent.show();
	cmtContentTxt.hide();
	
}
</script>
<div style="position: relative; margin-top: 10px;">
	<div style="height: 100%; overflow: visible; margin-top: 15px;">
	<sec:authorize access="isAuthenticated()">
		<div class="cmtWrite">
			<div>
				<textarea maxlength="600" id="commentContent"></textarea>
			</div> 
		</div>
		<div class="cmtBtnArea">
			<button type="button" id="cmtSave">댓글등록</button>
		</div> 
	</sec:authorize>
	<sec:authorize access="isAnonymous()">
		<div>
			<a href="/son/user/login.do?redirectYn=Y">로그인</a>을 하시면 댓글을 등록 할 수 있습니다.
		</div>
	</sec:authorize>
		<div id="comtListView">
		<c:import url="/WEB-INF/jsp/son/comment/commentList.jsp"></c:import>
		</div>
	</div>
</div>