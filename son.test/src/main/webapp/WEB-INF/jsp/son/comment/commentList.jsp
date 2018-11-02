<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

$(document).ready(function (){
});


</script>
<% pageContext.setAttribute("nl", "\n"); %>
<div class="cmtList" id="cmtList" style="margin-top: 15px;" >
	<ul >
		<c:forEach var="result" items="${cmtList}" varStatus="status">
			<li>
				<div class="cmtInfo" style="min-height: 38px;">
					<div class="cmtUser">
						<c:out value="${result.userId}" />
					</div>
					<div class="cmtContent">
					${fn:replace(fn:escapeXml(result.commentContent),nl,'<br/>') }
					</div>
					<div class="cmtTime">
						<c:out value="${result.createDt }"></c:out>
					</div>
				</div>
			</li>
		</c:forEach>
	</ul>
</div>