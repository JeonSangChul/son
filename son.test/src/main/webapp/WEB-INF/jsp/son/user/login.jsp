<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	/* $("#btnLogin").click(function(){
		$("#frm").attr("action", "<c:url value='/j_spring_security_check' />");
		$("#frm").submit();
		
		
	}); */
});

</script>
<div>
	<form name="f" id="f"  method="POST" action="/j_spring_security_check">
		<input type="text" name="j_username" id="j_username" value="${loginId }" required>
		<input type="text" name="j_password" id="j_password" value="" required>
		
		<input type="text" name="loginRedirect" id="loginRedirect" value="${loginRedirect }" >
		<input type="text" name="useReferer" id="useReferer" value="${useReferer }" >
		
		<input type="checkbox"  name="_spring_security_remember_me" id="remember-me"> 자동 로그인
		<button type="submit" name="btnLogin" id="btnLogin" >로그인</button>
		
		<c:if test="${not empty param.fail }">
			<p>로그인실패</p>
			<p>${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message }</p>
			<c:remove scope="session" var="SPRING_SECURITY_LAST_EXCEPTION"/>
		</c:if>
	</form>
</div>