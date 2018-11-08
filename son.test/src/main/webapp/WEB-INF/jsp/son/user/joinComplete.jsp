<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

$(document).ready(function (){
	$("#btnJoin").click(function(){
		$("#frm").attr("action", "<c:url value='/son/user/login.do' />");
		$("#frm").submit();
		
		
	});
});

</script>
<div>
	<form name="frm" id="frm"  method="POST" >
		<div>
			<p>회원 가입이 완료 되었씁니다.</p>
		</div>
		<button type="submit" name="btnLogin" id="btnLogin" >로그인</button>
	</form>
</div>