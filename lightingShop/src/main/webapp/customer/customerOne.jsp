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
    <title>Amado - signUp</title>

    <!-- Favicon  -->
    <link rel="icon" href="img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="css/core-style.css">
    <link rel="stylesheet" href="style.css">
    <!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

 <!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">

        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="index.html"><img src="img/core-img/logo.png" alt=""></a>
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
                <a href="index.html"><img src="img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul>
                    <li class="active"><a href="index.html">Home</a></li>
                    <li><a href="shop.html">Shop</a></li>
                    <li><a href="product-details.html">Product</a></li>
                    <li><a href="cart.html">Cart</a></li>
                    <li><a href="checkout.html">Checkout</a></li>
                    <!-- 내정보 상세보기 -->
                    <li><a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/customerOne.jsp" role="button">내정보 상세보기</a></li>
					<!-- 배송지 관리 -->
					<li><a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/addressList.jsp" role="button">배송지 관리</a></li>
					<!-- 포인트 내역 - 추가 예정-->
					<li><a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/customerPointList.jsp" role="button">포인트 내역 확인</a></li>
					<!-- 리뷰등록  -->
					<li><a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/review/addReview.jsp" role="button">리뷰등록</a></li>
					<!-- 문의등록 -->
					<li><a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/board/addQuestion.jsp" role="button">문의등록</a></li>
					
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
                <a href="cart.html" class="cart-nav"><img src="img/core-img/cart.png" alt=""> Cart <span>(0)</span></a>
                <a href="#" class="fav-nav"><img src="img/core-img/favorites.png" alt=""> Favourite</a>
                <a href="#" class="search-nav"><img src="img/core-img/search.png" alt=""> Search</a>
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
				
             	<!-- 고객상세 페이지 -->
             	 <div class="col-md-3"> <!-- [시작] col-md-3 25% 차지 -->
                	<div class="single-products-catagory clearfix">
                        <!-- Hover Content -->
                        <div class="hover-content">
                            <div class="line"></div>
             	
							   <!-- [시작] 고객상세정보 출력 -->
								<div class="container">
									<h3>개인정보 관리</h3>
									
									<br>
									
									<table class="table table-hover" style="text-align: center">
										<tr>
											<td>아이디</td>
											<td><%=customerOne.get("c.id")%></td>
										</tr>
										<tr>
											<td>고객명</td>
											<td><%=customerOne.get("c.cstm_name")%></td>
										</tr>
										<tr>
											<td>배송지명</td>
											<td>
												<%=customerOne.get("a.address_name")%>
											</td>
										</tr>
									 	<tr>
											<td>주소</td>
											<td><%=customerOne.get("c.cstm_address")%></td>
										</tr>
										<tr>
											<td>이메일</td>
											<td><%=customerOne.get("c.cstm_email")%></td>
										</tr>
										<tr>
											<td>생년월일</td>
											<td><%=customerOne.get("c.cstm_birth")%></td>
										</tr>
										<tr>
											<td>전화번호</td>
											<td><%=customerOne.get("c.cstm_phone")%></td>
										</tr>
										<tr>
											<td>성별</td>
											<td><%=customerOne.get("c.cstm_gender")%></td>
										</tr>
										<tr>
											<td>고객등급</td>
											<td><%=customerOne.get("c.cstm_rank")%></td>
										</tr>
										<tr>
											<td>포인트점수</td>
											<td><%=customerOne.get("c.cstm_point")%></td>
										</tr>
										<tr>
											<td>마지막 로그인 시간</td>
											<td><%=customerOne.get("c.cstm_last_login")%></td>
										</tr>
										<tr>
											<td>약관 동의 여부</td>
											<td><%=customerOne.get("c.cstm_agree")%></td>
										</tr>
										<tr>
											<td>가입일</td>
											<td><%=customerOne.get("c.createdate").toString().substring(0, 10)%></td>
										</tr> 
										<tr>
											<td>정보수정</td>
											<td>
												<button type="button" class="btn btn-warning btn-sm" onclick="location.href='<%=request.getContextPath()%>/customer/modifyCustomer.jsp'">정보수정</button>
											</td>
										</tr>
										<tr>
											<td>회원탈퇴</td>
											<td>
												<button type="button" class="btn btn-danger btn-sm" onclick="location.href='<%=request.getContextPath() %>/customer/removeCustomer.jsp'">회원탈퇴</button>
											</td>
										</tr>
									</table>
								</div>
								<!-- [끝] 고객상세정보 출력 -->	
							</div>
                        </div>
                	</div>
				</div>	<!-- [끝] col-md-3 25% 차지 -->
            </div>
        </div>
        <!-- Product Catagories Area End -->
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
                            <a href="index.html"><img src="img/core-img/logo2.png" alt=""></a>
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
                                            <a class="nav-link" href="index.html">Home</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="shop.html">Shop</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="product-details.html">Product</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="cart.html">Cart</a>
                                        </li>
                                        <li class="nav-item">
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

</body>
</html>