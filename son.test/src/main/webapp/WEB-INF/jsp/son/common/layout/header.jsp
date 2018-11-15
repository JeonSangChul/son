<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div style="border-bottom: 1px solid #e7e7e7; background-color: #f9f9f9; position: relative; ">
	<div style="width: 1000px; position: relative; margin: 0 auto; height: 30px;">
		<div style="position: absolute; top: 9px; right: 5px;">
			<ul style="overflow: hidden;">
				<sec:authorize access="isAnonymous()">
				<li style="float: left;">
					<a href="/son/user/join.do">회원가입</a>
				</li>
				<li style="float: left;">
					<a href="/son/user/login.do?redirectYn=Y">로그인</a>
				</li>
				</sec:authorize>
				<sec:authorize access="isAuthenticated()">
				<li style="float: left;">
					<a href="/son/user/logout.do">로그아웃</a>
				</li>
				</sec:authorize>
			</ul>
		</div>
	</div>
</div>