<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link rel="stylesheet" href="/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>

<script type="text/javascript">

	
	$(document).ready(function (){
		//목록화면 으로 이동
		//목록화면에 조회조건들 추가 하면 그 조건들 담아서 가자..
		//목록화면에서 페이징한거 몇 페이지인지 읽어서 가도록 해야 되나?
		$("#btnList").click(function(){
			var form = document.getElementById("frm")
			form.setAttribute('action', "<c:url value='/son/board/list.do'/>");
			createInputByName(form, "boardId", '${master.boardId}');
			form.submit();
		});

		//수정하기
		//idx 값을 히든으로 만들어 두는게 아니라 수정눌럿을시 실시간으로 생성해서 넘기도록..
		//form도 그냥 그려 두지 말고 스크립트 단에서 그릴까?
		$("#btnModify").click(function(){
			var form = document.getElementById("frm")
			form.setAttribute('action', "<c:url value='/son/board/modify.do'/>");
			createInputByName(form, "boardId", '${master.boardId}');
			createInputByName(form, "idx", '${result.idx}');
            form.submit();
		 });
	 });

</script>

	<div class="pagetit">
		<h3>글상세</h3>
	</div>
	<div class="boardView">
		<div class="top">
			<div class="title"><c:out value="${result.title }" /></div>
		</div>
		<div class="context">
			${result.content }
		</div>
		<c:if test="${not empty imgList}">
			<div class="boardFileList">
				<strong>첨부파일</strong>
				<ul class="boardFileListView">
					<c:forEach var="img" items="${imgList}" varStatus="status">
						<li>
							<a href="/son/file/fileDown.do?imgId=${img.imgId }&imgSrno=${img.imgSrno}"><c:out value="${img.originFileName }"/></a>
						</li> 
					</c:forEach>
				</ul>
			</div>
			
		</c:if>
		
		<div class="boardBtn">
			<button type="button" class="btnList" id ="btnList"><em>목록보기</em></button>
			<button type="button" class="btnModify" id ="btnModify"><em>수정</em></button>
		</div>
		
	</div>
	
	<form name="frm" id="frm" method="post"></form>

