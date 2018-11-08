<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	$("#btnJoin").click(function(){
		$("#frm").attr("action", "<c:url value='/son/user/joinSave.do' />");
		$("#frm").submit();
		
		
	});
});

</script>
<div>
	<form name="frm" id="frm"  method="POST" >
		<input type="text" name="email" id="email" value="" placeholder="이메일" required >
		<input type="password" name="userPassword" id="userPassword" value="" placeholder="비밀번호" required >
		<input type="text" name="userName" id="userName" value="" placeholder="성명" required>
		<input type="text" name="nickName" id="nickName" value="" placeholder="닉네임" required>
		
		<button type="button" name="btnJoin" id="btnJoin" >회원가입</button>
	</form>
</div>