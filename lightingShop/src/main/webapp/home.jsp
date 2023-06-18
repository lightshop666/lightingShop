<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 메인메뉴 인클루드 -->
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
<!-- 메인메뉴 인클루드 종료 -->	
		
<a href="<%=request.getContextPath()%>/customer/myPage.jsp">마이페이지로</a>
<a href="<%=request.getContextPath()%>/customer/logoutAction.jsp">로그아웃</a>








<!-- 하단 카피라잇 인클루드 -->
<jsp:include page="/inc/copyright.jsp"></jsp:include>
<!-- 하단 카피라잇 인클루드 종료 -->
</body>
</html>