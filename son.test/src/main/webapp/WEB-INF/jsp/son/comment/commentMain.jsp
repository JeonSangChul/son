<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	$("#cmtSave").click(function(){
		var param = {};
		
		param.boardId = "${result.boardId}";
		param.idx = "${result.idx}";
		param.commentContent = encodeURIComponent($("#commentContent").val());
		
		$.ajax({
			type : "POST",
			async : false,
			url : "<c:url value='/son/comment/commentSave.do'/>",
			data : param,
			success : function( data ){
				$("#comtListView").html(data);
				$("#commentContent").val("");
			}
			
		});
	});
});


</script>
<div style="position: relative; margin-top: 10px;">
	<div style="height: 100%; overflow: visible; margin-top: 15px;">
		<div class="cmtWrite">
			<div>
				<textarea maxlength="600" id="commentContent"></textarea>
			</div> 
		</div>
		<div class="cmtBtnArea">
			<button type="button" id="cmtSave">댓글등록</button>
		</div> 
		<div id="comtListView">
		<c:import url="/WEB-INF/jsp/son/comment/commentList.jsp"></c:import>
		</div>
	</div>
</div>