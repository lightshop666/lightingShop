<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면 홈으로
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//인코딩은 UTF-8로
	request.setCharacterEncoding("UTF-8");
	
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
				
             	<!-- 회원탈퇴 페이지 -->
             	 <div class="col-md-3"> <!-- [시작] col-md-3 25% 차지 -->
                	<div class="single-products-catagory clearfix">
                        <!-- Hover Content -->
                        <div class="hover-content">
                            <div class="line"></div>
             	
							 <div class="container">
									<h3>회원탈퇴</h3>
									
									<br>
									
									<div class="text-left mb-5">
											<div>사용하고 계신 아이디는 탈퇴할 경우 <span style="font-weight:bold; color:red;">재사용 및 복구가 불가능</span>합니다.</div>
											<br>
											<div>탈퇴 후 회원정보 및 개인형 서비스 이용기록은 모두 삭제됩니다.</div>
											<br>
											<div>모든 내용을 확인하셨으면 동의에 체크 후 비밀번호를 입력해주세요.</div>
											<hr>
											<small>
												<input type="checkbox" class="removeCk" name="cstmAgree" checked="checked">&nbsp;&nbsp;안내사항을 모두 확인하였으며, 이에 동의합니다
											</small>
									</div>
									<form method="post" action="<%=request.getContextPath() %>/customer/removeCustomerAction.jsp">
										<table class="table table-hover" style="text-align: center">
											<tr>
												<td>비밀번호</td>
												<td><input type="password" class="form-control" name="lastPw"></td>
											</tr>
											<tr>
												<td>탈퇴사유를 선택해주세요</td>
												<td>
													<select name="cstmGender">
													<option value="">선택하세요</option>
													<option value="">디자인이 별로임</option>
													<option value="">물건이 부족함</option>
													<option value="">기타</option>
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="2"><button type="submit" class="btn btn-danger btn-sm">회원탈퇴</button></td>
											</tr>
										</table>
									</form>
								</div>
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
	
	
	<!--                    템플릿 적용 전                      -->
	
	
		
	<div style="margin-top: 60px;"></div>
		
</body>
</html>