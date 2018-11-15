<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	
});



</script>
<% pageContext.setAttribute("nl", "\n"); %>
<div class="cmtList" id="cmtList" style="margin-top: 15px;" >
	<ul >
		<c:forEach var="cmtList" items="${cmtList}" varStatus="status">
			<li>
				<div class="cmtInfo" style="min-height: 38px; display: inline-block;">
					<div class="cmtUser">
						<span>
							<c:out value="${cmtList.userName}" />
							<span>
								<c:out value="${cmtList.userIp}" />
							</span>
						</span>
					</div>
					<div class="cmtContent" id="cmtContent" ">${fn:replace(fn:escapeXml(cmtList.commentContent),nl,'<br/>') }</div >
					
					<div class="cmtContent" id ="cmtContentTxt" style="display:none;">
						<textarea maxlength="600" style="width: 580px; height: 78px;"></textarea>
					</div> 
					<div class="cmtTime">
						<c:out value="${cmtList.createDt }"></c:out>
						<sec:authorize ifAnyGranted="ROLE_USER">
						<sec:authentication  property="principal.userId" var="secUserId" />
							<c:if test="${cmtList.userId == secUserId}">	
								<div style="float: right;" >
									<button type="button" id="commentDelete" onclick="fn_commentDelete(this)" comment-id="${cmtList.commentId}">삭제</button>
									<button type="button" id="commentEdit"   onclick="fn_commentEdit(this)"   comment-id="${cmtList.commentId}">수정</button>
									<button type="button" id="commentUpdate" onclick="fn_commentUpdate(this)" comment-id="${cmtList.commentId}" style="display: none;">저장</button>
									<button type="button" id="commentCancle" onclick="fn_commentCancle(this)" comment-id="${cmtList.commentId}" style="display: none;">취소</button>
								</div>
							</c:if>
						</sec:authorize>
						
					</div>
					
				</div>
			</li>
		</c:forEach>
	</ul>
	
	<c:if test="${not empty cmtList}">
	<div class="paging">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_commentSearch" />
	</div>
	</c:if>
</div>