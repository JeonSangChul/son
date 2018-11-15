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
			cache:false,
			async : false,
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			url : "<c:url value='/son/comment/commentSave.do'/>",
			data : param,
			beforeSend : function(xhr){
	    		xhr.setRequestHeader("AJAX-CALL", "true");
	    	},
			success : function( data ){
				if(data.resultCd == "Success"){
					$("#cmtList").html(data);
				}else{
					alert("작업중 오류가 발생했습니다.");
        			return false;
				}
				
			},error: function(request,status,e){
    			alert("작업중 오류가 발생했습니다.");
    			return;
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
		<div class="cmtList" id="cmtList" style="margin-top: 15px;" >
			<ul >
				<c:forEach var="result" items="${cmtList}" varStatus="status">
					<li>
						<div class="cmtInfo" style="min-height: 38px;">
							<div class="cmtUser">
								<c:out value="${result.userId}" />
							</div>
							<div class="cmtContent">
								<c:out value="${result.commentContent }"></c:out>
							</div>
							<div class="cmtTime">
								<c:out value="${result.createDt }"></c:out>
							</div>
						</div>
					</li>
				</c:forEach>
			</ul>
		</div>
		<div></div>
	</div>
</div>