<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<link rel="stylesheet" href="/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	
	$(document).ready(function (){
		//목록화면 으로 이동
		//목록화면에 조회조건들 추가 하면 그 조건들 담아서 가자..
		//목록화면에서 페이징한거 몇 페이지인지 읽어서 가도록 해야 되나?
		$("#btnList").click(function(){
			var form = document.getElementById("frm")
			form.setAttribute('action', "<c:url value='/son/board/list.do'/>"+"?boardId=${master.boardId}");
			form.submit();
		});

		$("#btnModify").click(function(){
			var form = document.getElementById("frm")
			form.setAttribute('action', "<c:url value='/son/board/modify.do'/>"+"?boardId=${master.boardId}&idx=${result.idx}");
			
            form.submit();
		 });
		
		$("#btnDelete").click(function(){
			if(!confirm("삭제 하시겠습니까?")) return;
			
			
			$.ajax({
				type:"POST",
		    	cache:false,
		    	async:false,
		    	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		    	url:"<c:url value='/son/board/delete.do'/>",
		    	data:{boardId : '${master.boardId}'
		    		 ,idx : '${result.idx}'
		    		 ,imgId : '${result.imgId}'
		    		},
	    		beforeSend : function(xhr){
		    		xhr.setRequestHeader("AJAX-CALL", "true");
		    	},
	    		success : function(data) {
	    			if(data.resultCd == "Success"){
	    				var form = document.getElementById("frm")
		    			form.setAttribute('action', "<c:url value='/son/board/list.do'/>"+"?boardId=${master.boardId}");
		                form.submit();
	    			}else{
	        			alert("작업중 오류가 발생했습니다.");
	        			return false;
	        		}
	    			
	    		},
	    		error: function(request,status,e){
	    			alert("작업중 오류가 발생했습니다.");
	    			return;
	    		}
			});
		 });
		
		$("#btnGood").click(function(){
			recommend("1");
		});
		
		$("#btnBad").click(function(){
			
			recommend("2");
		});
	 });
	
	
	function recommend(type){
		<sec:authorize access="isAnonymous()">
			alert("로그인이 필요한 서비스 입니다.");
			return ;
		</sec:authorize>
		
		
		$.ajax({
			type:"POST",
			cache:false,
	    	async:false,
	    	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
	    	url:"<c:url value='/son/board/recommend.do'/>",
	    	data:{boardId : '${master.boardId}'
	    		 ,idx : '${result.idx}'
	    		 ,typeCd:type
	    		},
	    	beforeSend : function(xhr){
	    		xhr.setRequestHeader("AJAX-CALL", "true");
	    	},
    		success : function(data) {
    			if(data.resultCd == "Success"){
    				$("#recommentGoodCnt").html(data.goodCnt);
        			$("#recommentBadCnt").html(data.badCnt);
    			}else{
    				alert("작업중 오류가 발생하였습니다.");
        			return;
    			}
    			
    		},
    		error: function(request,status,e){
    			alert("작업중 오류가 발생하였습니다.");
    			return;
    		}
		});
	}

</script>

	<div class="pagetit">
		<h3><c:out value="${master.boardName }" /></h3>
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
		<%-- <sec:authorize ifAllGranted="ROLE_USER"> --%>
			<div>
				<button type="button" id="btnGood">추천</button><span id="recommentGoodCnt">${recommedMap.goodCnt }</span>
				<button type="button" id="btnBad">비추천</button><span id="recommentBadCnt">${recommedMap.badCnt }</span>
			</div>
		<%-- </sec:authorize> --%>
		<div class="btnArea">
			<button type="button" class="btnList" id ="btnList"><em>목록보기</em></button>
			<sec:authorize ifAnyGranted="ROLE_USER">
				<sec:authentication  property="principal.userId" var="secUserId" />
				<c:if test="${result.userId == secUserId}">
					<button type="button" class="btnModify" id ="btnModify"><em>수정</em></button>
					<button type="button" class="btnDelete" id ="btnDelete">삭제</button>
				</c:if>
			</sec:authorize>
		</div>
		
	</div> 
	<form name="frm" id="frm" method="post"></form>
	<c:if test="${master.commentYn == 'Y'}">
		<c:import url="/WEB-INF/jsp/son/comment/commentMain.jsp"></c:import>
	</c:if>
	
	

