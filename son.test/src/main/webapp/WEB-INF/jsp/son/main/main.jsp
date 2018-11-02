<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="/js/common.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>

<script type="text/javascript">
	function fn_move(id){
		var form = document.createElement("form");
		form.setAttribute('method', "POST");
		form.setAttribute('action', "<c:url value='/son/board/list.do'/>");
		form.target ="_self";
		createInputByName(form, "boardId", id);
		document.body.appendChild(form);
		form.submit();
	}
</script>
<div style="min-height: 500px;">
	<h3>바디</h3>
	<ul>
	<c:forEach var="result" items="${boardMasterList}" varStatus="status">
		<li>
			<a href="#" onclick="fn_move('${result.boardId }')" ><c:out value="${result.boardName }"></c:out></a>
		</li>
	</c:forEach>
	</ul>
</div>