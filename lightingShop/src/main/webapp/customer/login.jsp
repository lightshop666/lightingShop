<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션검사
	if (session.getAttribute("loginCustomerId") != null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		if(session.getAttribute("loginCustomerId") == null) {
	%>
	<!-- 로그인 폼-->
	<div>
		<lable>Email address</lable>
		<input type="email" class="form-control" placeholder="Enter email">
	</div>
	<div>
		<lable>Password</lable>
		<input type="email" class="form-control" placeholder="Password">
	</div>
	
	<%
		}
	%>
</body>
</html>