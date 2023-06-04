<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
홈입니다.
<a href="<%=request.getContextPath()%>/customer/myPage.jsp">마이페이지로</a>
<a href="<%=request.getContextPath()%>/customer/logoutAction.jsp">로그아웃</a>
</body>
</html>