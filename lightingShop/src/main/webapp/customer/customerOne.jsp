<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListActive").equals("N")) { // 비회원 || 탈퇴회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	System.out.println("[customerOne컨트롤러 진입]");
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	
	// 회원정보 불러오기
	Customer customer = new Customer();
	customer.setId(sessionId);
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	String DefaultAddress = (String)customerOne.get("a.default_address");
	System.out.println(DefaultAddress + "[customerOne컨트롤러 DefaultAddress]");
%>   
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Amado - MyPage</title>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
    <!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	
	<!-- Font Awesome -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Dongle:wght@300&display=swap" rel="stylesheet">
</head>
<body>

 <!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">

        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Navbar Toggler -->
            <div class="amado-navbar-toggler">
                <span></span><span></span><span></span>
            </div>
        </div>

        <!-- [시작] 왼쪽 메뉴바 -->
        <header class="header-area clearfix">
            <!-- Close Icon -->
            <div class="nav-close">
                <i class="fa fa-close" aria-hidden="true"></i>
            </div>
            <!-- Logo -->
            <div class="logo">
                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul>
                    <li ><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
                    <!-- 임시로 HOME -->
                    <li><a href="<%=request.getContextPath()%>/home.jsp">Shop</a></li>
                    <li><a href="<%=request.getContextPath()%>/orders/orderProductList.jsp">Product</a></li>
                    <li><a href="<%=request.getContextPath()%>/cart/cartList.jsp">Cart</a></li>
                    <!-- 결제창 -->
                    <li><a href="checkout.html">Checkout</a></li>
                    <!-- 내정보 상세보기 -->
                    <li><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">내정보 상세보기</a></li>
					<!-- 배송지 관리 -->
					<li><a href="<%=request.getContextPath()%>/customer/addressList.jsp">배송지 관리</a></li>
					<!-- 포인트 내역 - 추가 예정-->
					<li><a href="<%=request.getContextPath()%>/customer/customerPointList.jsp">포인트 내역 확인</a></li>
					<!-- 리뷰등록  -->
					<li><a href="<%=request.getContextPath()%>/review/addReview.jsp">리뷰등록</a></li>
					<!-- 문의등록 -->
					<li><a href="<%=request.getContextPath()%>/board/addQuestion.jsp">문의등록</a></li>
					<!-- 로그아웃 -->
					<li><a href="<%=request.getContextPath()%>/customer/logoutAction.jsp">로그아웃</a></li>
					
					<%-- 사용하지 않는 기능	
					<!-- 등급확인 - 등급에 따른 이미지 출력-->
					<%=id%>님의 등급은 <%=customerOne.get("c.cstm_rank")%>입니다. 
					--%>
					
                </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="#" class="btn amado-btn mb-15">%Discount%</a>
                <a href="#" class="btn amado-btn active">New this week</a>
            </div>
            <!-- Cart Menu -->
            <div class="cart-fav-search mb-100">
                <a href="<%=request.getContextPath()%>/cart/cartList.jsp" class="cart-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/cart.png" alt=""> Cart <span>(0)</span></a>
                <a href="#" class="fav-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/favorites.png" alt=""> Favourite</a>
                <a href="#" class="search-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""> Search</a>
            </div>
            <!-- Social Button -->
            <div class="social-info d-flex justify-content-between">
                <a href="#"><i class="fa fa-pinterest" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-instagram" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-facebook" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-twitter" aria-hidden="true"></i></a>
            </div>
        </header>
        <!-- [끝] 왼쪽 메뉴바 -->

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

			 <!-- [시작] 고객상세정보 출력 -->
			 <section class=" login-area section-padding-100-0">
		        <div class="container">
		            <div class="row justify-content-center">
		                <div class="col-12 col-lg-8">
		                	<div class="login-content">
		                  
							<h3>개인정보 관리</h3>
							
							<div class="font-bold mb-5">
								<%=customerOne.get("c.cstm_name")%>(<%=customerOne.get("c.id")%>)님 반갑습니다.
							</div>
							
							<div class="row">
					    		<div class="col">
						    		<div>
										보유 포인트 : <%=customerOne.get("c.cstm_point")%>
									</div>
									<div>
										등급 : <%=customerOne.get("c.cstm_rank")%>
									</div>
									<div class="mt-3">
										가입날짜 : <%=customerOne.get("c.createdate").toString().substring(0, 10)%>
									</div>
									<div>
										전화번호 : <%=customerOne.get("c.cstm_phone")%>
									</div>
									<div>
										생년월일 : <%=customerOne.get("c.cstm_birth")%>
									</div>
									<div>
										이메일 : <%=customerOne.get("c.cstm_email")%>
									</div>
									<div>
										마지막 로그인 시간 : <br> <%=customerOne.get("c.cstm_last_login")%>
									</div>
						    	</div>
						    	<div class="col text-right">
						    		<div>
										<a class="btn btn-sm btn-outline-dark" href='<%=request.getContextPath()%>/customer/modifyCustomer.jsp'">회원정보수정</a>
									</div>
									<div class="mt-3">
										<a class="btn btn-sm btn-outline-dark" href='<%=request.getContextPath() %>/customer/removeCustomer.jsp'">회원탈퇴</a>
									</div>
						    	</div>
						    </div>       
							
							<hr>
							
							<!-- 기본배송지는 1개만 설정가능 기본배송지만 출력 -->
							<div class="font-bold pb-3" >
								기본배송지
							</div>
							
							<%
								if(DefaultAddress.equals("Y")) {
							%>
								<div>
									배송지명 : <%=customerOne.get("a.address_name")%>
								</div>
								<div>
									주소 : <%=customerOne.get("c.cstm_address")%>
								</div>
							<%
								} else {
							%>
									기본배송지 없음.
							<%
									}
							%>
							
							</div>
	                	</div>
					</div>
				</div>
			</section>	<!-- [끝] 고객상세정보 출력 -->	
		                    
            </div>
        </div>
        <!-- Product Catagories Area End -->
    </div>
    <!-- ##### Main Content Wrapper End ##### -->

    <!-- ##### Newsletter Area Start ##### -->
    <section class="newsletter-area section-padding-100-0">
        <div class="container">
            <div class="row align-items-center">
                <!-- Newsletter Text -->
                <div class="col-12 col-lg-6 col-xl-7">
                    <div class="newsletter-text mb-100">
                        <h2>Subscribe for a <span>25% Discount</span></h2>
                        <p>Nulla ac convallis lorem, eget euismod nisl. Donec in libero sit amet mi vulputate consectetur. Donec auctor interdum purus, ac finibus massa bibendum nec.</p>
                    </div>
                </div>
                <!-- Newsletter Form -->
                <div class="col-12 col-lg-6 col-xl-5">
                    <div class="newsletter-form mb-100">
                        <form action="#" method="post">
                            <input type="email" name="email" class="nl-email" placeholder="Your E-mail">
                            <input type="submit" value="Subscribe">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- ##### Newsletter Area End ##### -->

    <!-- ##### Footer Area Start ##### -->
    <footer class="footer_area clearfix">
        <div class="container">
            <div class="row align-items-center">
                <!-- Single Widget Area -->
                <div class="col-12 col-lg-4">
                    <div class="single_widget_area">
                        <!-- Logo -->
                        <div class="footer-logo mr-50">
                            <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo2.png" alt=""></a>
                        </div>
                        <!-- Copywrite Text -->
                        <p class="copywrite"><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a> & Re-distributed by <a href="https://themewagon.com/" target="_blank">Themewagon</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                    </div>
                </div>
                <!-- Single Widget Area -->
                <div class="col-12 col-lg-8">
                    <div class="single_widget_area">
                        <!-- Footer Menu -->
                        <div class="footer_menu">
                            <nav class="navbar navbar-expand-lg justify-content-end">
                                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#footerNavContent" aria-controls="footerNavContent" aria-expanded="false" aria-label="Toggle navigation"><i class="fa fa-bars"></i></button>
                                <div class="collapse navbar-collapse" id="footerNavContent">
                                    <ul class="navbar-nav ml-auto">
                                        <li class="nav-item active">
                                            <a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">Home</a>
                                        </li>
                                        <li class="nav-item">
                                        	<!-- 임시로 HOME -->
                                            <a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">Shop</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp">Product</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="<%=request.getContextPath()%>/cart/cartList.jsp">Cart</a>
                                        </li>
                                        <li class="nav-item">
                                        	 <!-- 결제창 -->
                                            <a class="nav-link" href="checkout.html">Checkout</a>
                                        </li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- ##### Footer Area End ##### -->

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="js/plugins.js"></script>
    <!-- Active js -->
    <script src="js/active.js"></script>

	<!-- js 유효성 검사 - DOM API 사용  -->
	<script>
		<%
			String loginMsg =  request.getParameter("loginMsg");
    		if(loginMsg != null) {
	   	%>
			alert('아이디와 비밀번호가 일치하지 않습니다.');
		<%
			}
		%>
	</script>	
</body>
</html>								
