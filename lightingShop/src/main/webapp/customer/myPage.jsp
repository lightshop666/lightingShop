<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	//변수저장
	String id = (String)session.getAttribute("loginIdListId");
	String lastPw = (String)session.getAttribute("loginIdListLastPw");
	String loginMemberId = id;
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 5;
	
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage;
	
	// 객체생성 -> 로그인으로 사용
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	
	// 객체생성 -> selectCustomerOne 메서드에서 사용
	Customer customer = new Customer();
	customer.setId(id);
	
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> loginIdList = cDao.loginMethod(idList);
	
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	OrderProductDao oDao = new OrderProductDao();
	ArrayList<HashMap<String, Object>> AllReviewList = oDao.selectCustomerOrderList(beginRow, rowPerPage, loginMemberId);
	
	ProductDao pDao = new ProductDao();
	
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

				<%
					// 로그인했다면 마이페이지
					if(session.getAttribute("loginIdListId") != null) {
				%>

                <!-- 주문내역 리스트 -->
                <div class="col-md-3"> <!-- [시작] col-md-3 25% 차지 -->
                	<div class="single-products-catagory clearfix">
                        <!-- Hover Content -->
                        <div class="hover-content">
                            <div class="line"></div>
								<h1>주문내역 리스트</h1>
								<div><!-- 
										템플릿 적용 후 수정 사항
										모든 리뷰 출력, 글 누르면 상품페이지로
										사진 누르면 사진 확대
									 -->
								<%
									for (HashMap<String, Object> m : AllReviewList) {
										//product 모델 소환
										HashMap<String, Object> productOne =  pDao.selectProductAndImgOne((int)m.get("productNo"));
									    // productOne에서 필요한 데이터 가져오기
									    Product product = (Product) productOne.get("product");
									    ProductImg productImg = (ProductImg) productOne.get("productImg");		
								%>
										<h4>주문 번호 : <%= m.get("orderNo") %></h4>
										<p>
											<a href="<%=request.getContextPath()%>/review/reviewOne.jsp?orderNo=<%=m.get("orderNo")%>">
												주문 상세
											</a>
										</p>			
										<p>주문일: <%= m.get("createdate") %></p>
										<p>배송 상태: <%= m.get("deliveryStatus") %></p>
										<p>
										    <a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
										        <img class="thumbnail" src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image">
										    </a>
										</p>
										<p>
										    <a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
										        <%= product.getProductName() %>
										    </a>
										</p>			
									<%
										System.out.println(m.get("deliveryStatus"));
										System.out.println(m.get("reviewWritten"));
									    if (m.get("deliveryStatus").equals("구매확정")) {	//주문확인중 이 맞는데 임시로
									        // 주문 취소 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelAction.jsp?orderNo=<%=m.get("orderNo")%>'">주문취소</button>
									<%
									    } else if (m.get("deliveryStatus").equals("배송중")) {
									        // 수취 확인 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
									<%
									    } else if (m.get("deliveryStatus").equals("배송시작")) {
									        // 수취 확인 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
									<%
									    } else if (m.get("deliveryStatus").equals("배송완료")) {
									        // 구매 확정 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderPurchase.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">구매확정</button>
									<%
									    } else if (m.get("deliveryStatus").equals("취소중")) {
									        // 취소 철회 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelWithdraw.jsp?orderNo=<%=m.get("orderNo")%>'">취소철회</button>
									<%
									    } else if (m.get("deliveryStatus").equals("교환중")) {
									        // 수취 확인 버튼 클릭 시 동작
									%>
									        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
									<%
									    } else if (m.get("deliveryStatus").equals("구매확정")
									    && m.get("reviewWritten").equals("N")) {
									        // 상품평 버튼 클릭 시 동작
									%>
											<button onclick="location.href='<%= request.getContextPath() %>/review/addReview.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">상품평</button>
									<%
									    } else if (m.get("deliveryStatus").equals("취소완료")) {
									        // 상품평 버튼 클릭 시 동작
									%>
											<button disabled>취소완료</button>
									<%
									    }
									%>
							
										<hr>
								<%
								    }
								%>
							</div>
                        </div>
                	</div>
				</div>	<!-- [끝] col-md-3 25% 차지 -->
				
								<%
									} else { // 로그인 전이라면 로그인 폼
								%>
								
				<!-- 로그인 폼 출력 -->
				<div class="col-md-3"> <!-- [시작] col-md-3 25% 차지 -->
                	<div class="single-products-catagory clearfix">
                        <!-- Hover Content -->
                        <div class="hover-content">
                            <div class="line"></div>
                            <!-- 로그인 폼-->
							<div class="logo">
				                <a href="index.html"><img src="img/core-img/logo.png" alt=""></a>
				            </div>
								<form action="<%=request.getContextPath()%>/customer/loginAction.jsp" method="post">
								<!-- 세션에 저장할 active값과 emp_level 값 -->
								<input type="hidden" name="active" value="<%=loginIdList.get("active")%>">
								<input type="hidden" name="empLevel" value="<%=loginIdList.get("empLevel")%>">
								<table>
									<tr>
										<td>아이디</td>
										<td><input type="text" name="id"></td>
									</tr>
									<tr>
										<td>비밀번호</td>
										<td><input type="password" name="lastPw"></td>
									</tr>
								</table>
								<button type="submit">로그인</button>
							</form>
							<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/addCustomer.jsp" role="button">회원가입</a>
                        </div>
                	</div>
				</div>	<!-- [끝] col-md-3 25% 차지 -->
				
								<%
										}
								%>
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
