<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

$(document).ready(function (){
});

function fn_search(pageNo){
	var form = document.getElementById("listForm");
	form.setAttribute('action', "<c:url value='/son/board/list.do?boardId=${master.boardId}&pageIndex='/>"+pageNo);
    form.submit();
}

function fn_write(){
	
	var form = document.getElementById("listForm");
	form.setAttribute('action', "<c:url value='/son/board/write.do?boardId=${master.boardId}'/>");
    form.submit();
}

function fn_detail(idx){
	
	var form = document.getElementById("listForm")
	form.setAttribute('action', "<c:url value='/son/board/detail.do?boardId=${master.boardId}&idx='/>"+idx);
    form.submit();
}

</script>
<div class="pagetit">
	<h3><c:out value="${master.boardName }" /></h3>
</div>
<form name="listForm" id="listForm" method="post">
<div class="boardList">
   <table summary='<c:out value="${master.boardName }" />'>
	   <caption><c:out value="${master.boardName }" /></caption>
	   <colgroup>
			<col width="10%" />
			<col width="60%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
		</colgroup>
		<thead>
	      <tr>
	         <th scope="col">글번호</th>
	         <th scope="col">제목</th>
	         <th scope="col">작성자</th>
	         <th scope="col">등록일</th>
	         <th scope="col">조회수</th>
	      </tr>
		</thead>
		<tbody>
			<c:forEach var="result" items="${resultList}" varStatus="status">
				<tr>
					<td class="no"><c:out value="${result.idx }"></c:out> </td>
					<td class="tit"><a href="javascript:fn_detail('${result.idx }');"><c:out value="${result.title }"></c:out></a> </td>
					<td class="tit"><c:out value="${result.userName }"></c:out> </td>
					<td class="date"><c:out value="${result.createDt }"></c:out> </td>
					<td class="no"><c:out value="${result.viewCnt }"></c:out> </td>
				</tr>
			</c:forEach>
		</tbody>
   </table>
   
	<div class="paging">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_search" />
	</div>
	<div class="btnArea">
		<button type="button" onclick="fn_write();">글쓰기</button>
	</div>
</div>
</div>

</form>