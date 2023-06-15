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
	int currentPage= 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 3;
	
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	// 객체생성 -> 로그인으로 사용
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	
	// 객체생성 -> selectCustomerOne 메서드에서 사용
	Customer customer = new Customer();
	customer.setId(id);
	// Customer(로그인, 고객정보) 모델호출
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> loginIdList = cDao.loginMethod(idList);
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	//모델 호출
	OrderDao orderDao = new OrderDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//총 행을 구하기 위한 메소드
	int totalRow = orderProductDao.CustomerOrderListCnt(loginMemberId);
	
	//마지막 페이지
	int lastPage = totalRow / rowPerPage;
	//마지막 페이지는 딱 나누어 떨어지지 않으니까 몫이 0이 아니다 -> +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	//페이지 목록 중 가장 작은 숫자의 페이지
	int minPage = ((currentPage - 1) / pageRange ) * pageRange + 1;
	//페이지 목록 중 가장 큰 숫자의 페이지
	int maxPage = minPage + (pageRange - 1 );
	//maxPage 가 last Page보다 커버리면 안되니까 lastPage를 넣어준다
	if (maxPage > lastPage){
		maxPage = lastPage;
	}
	
	//order모델 소환
	ArrayList<Orders> orderList  = orderDao.justOrders(beginRow, rowPerPage, loginMemberId);   
	ArrayList<HashMap<String, Object>> orderByOrderProduct = new ArrayList<HashMap<String, Object>>();
	
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

				<%
					// 로그인했다면 마이페이지
					if(session.getAttribute("loginIdListId") != null) {
				%>
			 
			 <!-- [시작] 회원등급 표시 -->
			 <section class="section-padding-100-0">
		        <div class="container">
		            <div class="row align-items-center">
		                <div class="col-12 col-lg-8">
		                    <div class="mb-100">
		                    	
		                    	고객님은 <%=customerOne.get("c.cstm_rank") %> 등급입니다.
		                    	<br>
		                    
		                    </div>
	                	</div>
					</div>
				</div>
			</section>	<!-- [끝] 회원등급 표시 -->
		                    
			 
             <!-- [시작] 주문정보 리스트 -->
             <section class="section-padding-100-0">
		        <div class="container">
		            <div class="row align-items-center">
		                <div class="col-12 col-lg-8">
		                    <div class="mb-100">
								<h1>주문내역 리스트</h1>
								<div>
									<!-- 
										템플릿 적용 후 수정 사항
										모든 리뷰 출력, 글 누르면 상품페이지로
										사진 누르면 사진 확대
									 -->
								<%
								System.out.println(orderList.size()+"<--orderList.size()-- orderProductList.jsp");
									for (Orders o : orderList) {
										System.out.println(o.getOrderNo()+"<--getOrderNo-- orderProductList.jsp");
								%>
							
										<p>
											<a href="<%=request.getContextPath()%>/orders/orderProductOne.jsp?orderNo=<%= o.getOrderNo() %>">
											주문 상세
											</a>
										</p>
										<p>주문일: <%= o.getCreatedate() %></p>
								<%
										orderByOrderProduct = orderProductDao.selectOrderNoByOrderProductNo(o.getOrderNo());
										for (HashMap<String, Object> m : orderByOrderProduct) {
											int productNo = (int) m.get("productNo");
											String deliveryStatus = (String) m.get("deliveryStatus");
											String reviewWritten = (String) m.get("reviewWritten");
											
											// 상품 정보 및 이미지를 가져옵니다.
											HashMap<String, Object> productMap = productDao.selectProductAndImgOne(productNo);
											Product product = (Product) productMap.get("product");
											ProductImg productImg = (ProductImg) productMap.get("productImg");
								%>
											<p>상세상품번호 : <%= productNo%></p>			
											<p>배송 상태: <%= deliveryStatus %></p>
											<p>상품 이미지
												<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= productNo%>">
													<img class="thumbnail" src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image">
												</a>
											</p>
											<p>상품 이름
												<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= productNo%>">
													<%= product.getProductName() %>
												</a>
											</p>	
											<p><!-- 버튼 분기 -->
								<%	
											if (deliveryStatus.equals("주문확인중")) {
								   			 // 주문 취소 버튼 클릭 시 동작
								%>
												<button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelAction.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">주문취소</button>
								<%
											} else if (deliveryStatus.equals("배송중") || deliveryStatus.equals("배송시작") || deliveryStatus.equals("교환중")) {
									    	// 수취 확인 버튼 클릭 시 동작
								%>
												<button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">수취확인</button>
								<%
											} else if (deliveryStatus.equals("배송완료")) {
									   		 // 구매 확정 버튼 클릭 시 동작
								%>
												<button onclick="location.href='<%= request.getContextPath() %>/orders/orderPurchase.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">구매확정</button>
								<%
											//주문 취소는 
											} else if (deliveryStatus.equals("취소중")) {
									 		   // 취소 철회 버튼 클릭 시 동작
								%>
												<button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelWithdraw.jsp?orderNo=<%= m.get("orderNo") %>'">취소철회</button>
								<%
											} else if (deliveryStatus.equals("구매확정") && reviewWritten.equals("N")) {
									    		// 상품평 버튼 클릭 시 동작
								%>
												<button onclick="location.href='<%= request.getContextPath() %>/review/addReview.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">상품평</button>
								<%
											} else if (deliveryStatus.equals("취소완료")) {
									 		   // 상품평 버튼 클릭 시 동작
								%>
												<button disabled>취소완료</button>
								<%
											}
								%>
										</p>
								<%
										}
								%>
									<hr>
								<%
									}
								%>
								</div>
								
								
								<div class="center" >
								<%
									//1번 페이지보다 작은데 나오면 음수로 가버린다
									if (minPage > 1) {
								%>
										<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage-pageRange%>">이전</a>
								
								<%	
									}
									for(int i=minPage; i <= maxPage; i=i+1){
										if ( i == currentPage){		
								%>
											<span><%=i %></span>
								<%
										}else{
								%>
											<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=i%>"><%=i %></a>
								<%
										}
									}
								
									//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
									if(maxPage != lastPage ){
								%>
										<!-- maxPage+1해도 동일하다 -->
										<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage+pageRange%>">다음</a>
								<%
									}
								%>
								</div>
	                        </div>
	                	</div>
					</div>
				</div>
			</section>	<!-- [끝] 주문정보 리스트 -->
								<%
									} else { // 로그인 전이라면 로그인 폼
								%>
								
			<!--[시작] 로그인 폼 출력 -->
			<section class="login-area section-padding-100">
		        <div class="container">
		             <div class="row justify-content-center">
		                 <div class="col-12 col-lg-8">
		                    <div class="login-content">
		                    	<div class="logo">
					                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
					            </div>
					            <br>
		                    	<div class="login-form">
									<form action="<%=request.getContextPath()%>/customer/loginAction.jsp" method="post" id="signinForm">
										<!-- 세션에 저장할 active값과 emp_level 값 -->
										<input type="hidden" name="active" value="<%=loginIdList.get("active")%>">
										<input type="hidden" name="empLevel" value="<%=loginIdList.get("empLevel")%>">
										<!-- Input Fields for ID and Password-->
								        <input type ='text' class = 'form-control my-input-field' id ='id' name = 'id' required placeholder="아이디">
								        <span id="idMsg" class="msg"></span>
								        <input type ='password' class = 'form-control my-input-field' id ='lastPw' name = 'lastPw' required placeholder="비밀번호는 4자"><br>
								        <span id="lastPwMsg" class="msg"></span>
										<button type="submit" class="btn btn-warning btn-lg mt-6" id="signBtn">로그인</button>
									</form>
									<a href="<%=request.getContextPath()%>/customer/addCustomer.jsp">회원가입</a>
								</div>
	                        </div>
	                	</div>
					</div>
				</div>
			</section> <!--[끝] 로그인 폼 출력 -->
			
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

	<!-- js 유효성 검사 - DOM API 사용 -> 현재 동작 안함 -->
	<script>
	
    document.querySelector('form').addEventListener('submit', function(event) {
      
       let loginIdInput = document.querySelector('input[name="id"]');
       let loginLastPwInput = document.querySelector('input[name="lastPw"]');

       if (loginIdInput.value.trim() === '') {
           event.preventDefault();
           alert('아이디를 입력해주세요.');
           return;
       } 
	
       if (loginLastPwInput.value.trim() === '') {
           event.preventDefault();
           alert('비밀번호를 입력해주세요.');
           return;
       } else if (isNaN(loginLastPwInput.value.trim())) {
           event.preventDefault();
           alert('비밀번호는 숫자만 입력해주세요.');
           return;
       }
       
    });  
      
     /* 
      
      // HTML이 로드된 후에 동작
	  window.onload = function() {
	  // 시작시 id입력폼에 포커스
	  document.getElementById('id').focus();
	  
	  let allCheck = false;
		  
		  // id 유효성 체크
		  document.getElementById('id').addEventListener('blur', function() {
		    if (this.value.length < 2) { 
		      document.getElementById('idMsg').innerHTML="ID는 최소한 두 글자 이상이어야 합니다.";
		      this.focus();
		    } else {
		      console.log(this.value);
		      document.getElementById("lastPw").focus();
		    }
		   });
		  
		  // lastPw 유효성 체크
	      document.getElementById('lastPw').addEventListener('blur', function() {
		    if (this.value.length < 4) { 
		      document.getElementById('lastPwMsg').innerHTML="비밀번호는 최소한 4자 이상이어야 합니다.";
		      this.focus();
		    } else {
		      console.log(this.value);
		      // 유효성 체크를 마치고 로그인버튼으로 포커스를 옮긴다.
		      document.getElementById("signinBtn").focus();
		      // 체크를 확인한다.
		      allCheck = true;
		    }
		   });
		  
	   	  // signinBtn click
	   	  document.getElementById('signBtn').addEventListener.('click', (function() {
	   		// 바로 버튼 누름 방지
	   		if(allCheck == false) { 
	   			document.getElementById('id').focus();
	   			return;
	   		}
	   		document.getElementById('signinForm').submit();
	   	  }); 
	  */
	  
	</script>	
</body>
</html>