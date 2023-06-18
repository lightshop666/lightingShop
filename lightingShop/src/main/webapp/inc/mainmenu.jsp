<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main menu</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	}
	h1{	
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	/*이미지 사이즈, 클릭시 풀스크린*/
	.thumbnail {
    max-width: 200px;
    cursor: pointer;
  	}
	.fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
  	}
	.fullscreen img {
    max-width: 80%;
    max-height: 80%;
	}
	
</style>
</head>
<body>
<!-- 세로형 메인메뉴 inclue 페이지 -->
	<!-- 로고 -->
	<!-- 
	아이콘 참조 사이트 : https://icons8.kr/icons/set/login
	 -->
	 <a href="<%=request.getContextPath()%>/home.jsp">
			홈으로
	</a>

	<!-- 비로그인 : 회원가입 버튼 / 로그인 : 로그아웃 버튼-->
<%//비로그인 : 회원가입
	if(session.getAttribute("loginMemberId") == null) {//로그인 전
%>
		<a href="<%=request.getContextPath()%>/customer/addCustomer.jsp">
			회원가입
		</a>
<%
	//로그인시 : 로그아웃
	}else{
%>
		<a href="<%=request.getContextPath()%>/customer/logoutAction.jsp">
			<img width="50" height="50" src="https://img.icons8.com/ios/50/exit--v1.png" alt="exit--v1"/>
		</a>
		
<%
	}
%>
	<!-- 비로그인 : 로그인 버튼 / 로그인 : 마이페이지 버튼-->
<%//비로그인 : 로그인
	if(session.getAttribute("loginMemberId") == null) { // 로그인전
%>
		<a href="<%=request.getContextPath()%>/customer/loginAction.jsp">
			<img width="50" height="50" src="https://img.icons8.com/ios/50/enter-2.png" alt="enter-2"/>
		</a>
<%
	//로그인시 : 마이페이지
	}else{
%>
		<a href="<%=request.getContextPath()%>/customer/myPage.jsp">
			<img width="50" height="50" src="https://img.icons8.com/ios/50/user--v1.png" alt="user--v1"/>
		</a>
		
<%
	}
%>
	<!-- 카트-->
		<a href="<%=request.getContextPath()%>/cart/cartList.jsp">
			<img width="50" height="50" src="https://img.icons8.com/ios/50/shopping-cart--v1.png" alt="shopping-cart--v1"/>
		</a>

	<!-- 카테고리 n개(모든 상품, 카테고리별 상품)-->
		<a href="<%=request.getContextPath()%>/product/productList.jsp">상품목록</a>
	
	<!-- 검색창 (serchResult)-->
	

</body>
</html>