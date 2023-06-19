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
<head>
	<meta charset="UTF-8">
	<meta name="description" content="">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
	<!-- Title  -->
	<title>main menu</title>
	
	<!-- Favicon  -->
	<link rel="icon" href="img/core-img/favicon.ico">
	
	<!-- Core Style CSS -->
	<link rel="stylesheet" href="css/core-style.css">
	<link rel="stylesheet" href="style.css">

	<!-- 
	아이콘 참조 사이트 : https://icons8.kr/icons/set/login
	 -->
</head>




<body>
	<nav class="navbar navbar-expand-lg justify-content-end">
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#footerNavContent" aria-controls="footerNavContent" aria-expanded="false" aria-label="Toggle navigation"><i class="fa fa-bars"></i></button>
		<div class="collapse navbar-collapse" id="footerNavContent">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item active">
					<a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">
						<img width="50" height="50" src="https://img.icons8.com/ios/50/home--v1.png" alt="home--v1"/>
					</a>
				</li>
				<li class="nav-item">
					<!-- 비로그인 : 회원가입 버튼 / 로그인 : 로그아웃 버튼-->
			<%//비로그인 : 회원가입
					if(session.getAttribute("loginMemberId") == null) {//로그인 전
			%>
						<a class="nav-link" href="<%=request.getContextPath()%>/customer/addCustomer.jsp">
							<img width="50" height="50" src="<%=request.getContextPath()%>/img/core-img/join.png" alt="exit--v1"/>
						</a>
			<%
					//로그인시 : 로그아웃
					}else{
			%>
						<a class="nav-link" href="<%=request.getContextPath()%>/customer/logoutAction.jsp">
							<img width="50" height="50" src="https://img.icons8.com/ios/50/exit--v1.png" alt="exit--v1"/>
						</a>
			<%
					}
			%>
				</li>
				<li class="nav-item">
				<!-- 비로그인 : 로그인 버튼 / 로그인 : 마이페이지 버튼-->
				<%//비로그인 : 로그인
					if(session.getAttribute("loginMemberId") == null) { // 로그인전
				%>
						<a class="nav-link" href="<%=request.getContextPath()%>/customer/loginAction.jsp">
							<img width="50" height="50" src="https://img.icons8.com/ios/50/enter-2.png" alt="enter-2"/>
						</a>
				<%
				//로그인시 : 마이페이지
					}else{
				%>
						<a class="nav-link" href="<%=request.getContextPath()%>/customer/myPage.jsp">
							<img width="50" height="50" src="https://img.icons8.com/ios/50/user--v1.png" alt="user--v1"/>
						</a>
				<%
					}
				%>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/cart/cartList.jsp">
						<img width="50" height="50" src="https://img.icons8.com/ios/50/shopping-cart--v1.png" alt="shopping-cart--v1"/>
					</a>
				</li>
			</ul>
		</div>
	</nav>
</body>