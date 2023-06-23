<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat" %>

<%
	//세션 로그인 검사
	String loingIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loingIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loingIdListId+"<--새로 들어온 아이디 orderConfirmDelivery.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- orderConfirmDelivery.jsp");
		return;
	}
	
	//주문번호 유효성 검사
	int orderNo =0;
	if(request.getParameter("orderNo")!=null){
		orderNo = Integer.parseInt(request.getParameter("orderNo"));
		System.out.println(orderNo + "<--parm-- orderNo orderProductOne.jsp");

	}else{
		
	}
	/*
	주문번호+상품별 배송정보+[상품정보+반품,교환,수취확인 버튼] x n +결제정보 + 적립혜택
	*/
	
	//모델 호출
	OrderDao orderDao = new OrderDao();
	CustomerDao customeDao = new CustomerDao();
	ProductDao productDao = new ProductDao();
	OrderProductDao orderProductDao =new OrderProductDao();
	ReviewDao reviewDao = new ReviewDao();
	PointHistoryDao pointHistoryDao = new PointHistoryDao();
	
	
	
	//주문조회 
	HashMap<String, Object> map = orderDao.selectOrdersOne(orderNo);
	Orders orders = (Orders) map.get("orders");
	List<OrderProduct> orderProducts = (List<OrderProduct>) map.get("orderProducts");
	System.out.println("getOrderNo: " + orders.getOrderNo());
	System.out.println("orderProducts size: " + orderProducts.size());

	
	// 상품 정보와 이미지 정보를 담을 리스트 생성
	List<HashMap<String, Object>> productInfos = new ArrayList<>();
	
	// 각 주문 상품에 대해 상품 정보와 이미지 정보를 조회하여 리스트에 추가
	for (OrderProduct orderProduct : orderProducts) {
		int productNo = orderProduct.getProductNo();
		
		// 상품 정보와 이미지 정보를 조회하는 메서드 호출
		HashMap<String, Object> productMap = productDao.selectProductAndImg(productNo);
		
		// 상품 가격에 대한 할인 정보를 조회하여 할인된 가격을 추가
		int discountedPrice = orderProductDao.discountedPrice(productNo);
		productMap.put("discountedPrice", discountedPrice);

		// 조회한 정보를 리스트에 추가
		productInfos.add(productMap);
	}
	
	
	//고객정보
	Customer customer = new Customer();
	customer.setId(orders.getId());
	
	HashMap<String, Object> customerMap = customeDao.selectCustomerOne(customer);
	String customerName = (String)customerMap.get("c.cstm_name");
	String customerPhone = (String)customerMap.get("c.cstm_phone");
	
	
	//포인트 정보
	ArrayList<PointHistory> pointHistorys= pointHistoryDao.pointListByOrder(orderNo);
	//적립 포인트 정보만 받아온다
	int pointByOrder = 0;
	for(PointHistory p : pointHistorys){
		if(p.getPointPm().equals("P")){
			pointByOrder = p.getPoint();
		}
	}
	
	//숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
	<meta charset="UTF-8">
	<!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
	<!-- Title  -->
	<title>주문 상세 페이지 | Order Details</title>
	
	<!-- Favicon  -->
	<link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
	
	<!-- Core Style CSS -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
</head>
<style>
.custom-button {
  background-color: #f1bb41;
 border: none;
  color: white;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 8px;
  margin: 4px 2px;
  cursor: pointer;
  transition: background-color 0.3s; /* 색상 변화에 0.3초의 트랜지션 효과 적용 */
}
.custom-button:hover {
  background-color: black; /* 마우스를 올렸을 때 버튼 배경색을 회색으로 설정 */
}

</style>
<body>
<!-- ##### Main Content Wrapper Start ##### -->
<div class="main-content-wrapper d-flex clearfix">

	<!-- Mobile Nav (max width 767px)-->
	<div class="mobile-nav">
		<!-- Navbar Brand -->
		<div class="amado-navbar-brand">
				<a href="<%=request.getContextPath()%>/resources/<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
		</div>
		<!-- Navbar Toggler -->
		<div class="amado-navbar-toggler">
			<span></span><span></span><span></span>
		</div>
	</div>

	<!-- menu 좌측 bar -->
	<!-- Header Area Start -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<!-- Header Area End -->

	<div class="cart-table-area section-padding-50">
		<div class="container-fluid">
			<div class="row">
				<div class="col-12 col-lg-8">
					<div class="cart-title mt-50">
						<h2>Order Details</h2>
					</div>
						<!-- 화면구성		
					1.주문번호
					1-1) 주문일 / 1-2) 주문번호 
					-->
					<p>주문일 : <%=orders.getCreatedate()%></p>
					<p>주문번호 : <%=orders.getOrderNo()  %></p>
					<!--
					2.배송지
					2-1) 받는 사람 / 2-2) 연락처 / 2-3) 받는 주소
					-->
					<p>받는 사람 : <%=customerName%></p>
					<p>연락처 : <%=customerPhone %></p>
					<p>받는 주소 : <%=orders.getOrderAddress()  %></p>
					<!--
					3.상품 타이틀 - 상품별로 레이아웃 감싸기
					3-1) 배송 상태
					3-2)상품 이미지, 상품 타이틀, 판매가 / 
					3-3)반품신청 버튼 -> 반품 페이지 / 
					3-4)교환신청 버튼->교환 페이지 / 
					3-5) 수취확인 버튼 -> db 상태값 변경 
					-->
					<hr>
					<div class="cart-table clearfix">
					<table class="table table-responsive" style="text-align: center;">
					<thead>
						<tr>
							<th style="height: 4em; width: 30%; max-width: 30%; background-color: #f5f7fa;"></th>
							<th style="height: 4em; width: 15%; max-width: 15%; background-color: #f5f7fa; vertical-align: middle;">Name</th>
							<th style="height: 4em; width: 10%; max-width: 10%; background-color: #f5f7fa; vertical-align: middle;">Quantity</th>
							<th style="height: 4em; width: 15%; max-width: 15%; background-color: #f5f7fa; vertical-align: middle;">Price</th>
							<th style="height: 4em; width: 15%; max-width: 15%; background-color: #f5f7fa;">Shipping Status</th>
							<th style="height: 4em; width: 20%; max-width: 10%; background-color: #f5f7fa;"></th>
							<th style="height: 4em; width: 20%; max-width: 10%; background-color: #f5f7fa;"></th>
						</tr>
					</thead>
					<tbody>
					<%
						//원가 계산을 위한 변수 선언
						int oriPrice = 0;
						for (int i = 0; i < productInfos.size(); i++) {
							HashMap<String, Object> productInfo = productInfos.get(i);
							// 주문 상품에 대한 정보
							OrderProduct orderProduct = orderProducts.get(i);
						//디버깅
							System.out.println(orderProduct.getOrderProductNo()+"<--orderPorductNo orderProductOne.jsp");
							int orderProductNo = orderProduct.getOrderProductNo();
							
							//상품 정보와 이미지 가져오기
							Product product = (Product) productInfo.get("product");
							ProductImg productImg = (ProductImg) productInfo.get("productImg");
						
							// 한 달 이후로는 리뷰를 쓸 수 없게 리뷰 버튼 없애기 위한 DB 조회
							HashMap<String, Object> orderProductInfo = orderProductDao.selectOrderProduct(orderProduct.getOrderProductNo());
							String deleveryStatus = (String)orderProductInfo.get("deleveryStatus");
							Date createDate = (Date) orderProductInfo.get("createdate");
							Date todayDate = (Date) orderProductInfo.get("todaydate");
							
						//디버깅	
							//System.out.println(deleveryStatus+"<--deleveryStatus orderProductOne.jsp");
							//System.out.println(createDate+"<--createDate orderProductOne.jsp");
							//System.out.println(todayDate+"<--todayDate orderProductOne.jsp");
							HashMap<String, Object> review = reviewDao.customerReview(orders.getId());
							String reviewWritten = null;
							if (review != null && review.size() != 0) {
							    reviewWritten = (String) review.get("reviewWritten");
							}
							// 리뷰 작성 여부 확인
							boolean isReviewAllowed = orderProductDao.checkReviewEligibility(createDate, todayDate);
							boolean isReviewWritten = reviewWritten != null && reviewWritten.equals("Y");
							// 리뷰 작성 가능 여부 확인
							boolean canWriteReview = isReviewAllowed && !isReviewWritten;

							//원가 더하기
							oriPrice += (int) product.getProductPrice() * orderProduct.getProductCnt();
							System.out.println(oriPrice+"<--oriPrice 원가 orderProductOne.jsp");
					%>
					<tr>
						<td style="width: 30%; max-width: 30%;">	<!-- 상품이미지 -->
							<div class="single_product_thumb">
								<div class="carousel-inner">
									<div class="carousel-item active">					
							<%
										// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
										if(productImg.getProductSaveFilename() == null) {
							%>
											<a class="gallery_img" href="<%=request.getContextPath()%>/productImg/no_image.jpg">
												<img class="d-block w-100" src="<%=request.getContextPath()%>/productImg/no_image.jpg" alt="No Image">
											</a>
							<%
										}else {
							%>
											<a class="gallery_img" href="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>">
												<img class="d-block w-100" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
											</a>				
							<%
										}
							%>
									</div>
								</div>
							</div>
						</td>
						<td style="width: 15%; max-width: 15%;" class="cart_product_desc"><!-- 상품명 -->
						<!-- 상품명 -->
							<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= (int)product.getProductNo()%>">                                            
							<%= product.getProductName() %></a>
						</td>
						
						<!-- 물품 수량 -->
						<td style="width: 25%; max-width: 10%;">
							<%=orderProduct.getProductCnt() %>
						</td>
						
						<!-- 상품 가격 -->
						<td style="width: 15%; max-width: 15%;  font-size: 9px;">
						<%=decimalFormat.format((int) productInfo.get("discountedPrice") * orderProduct.getProductCnt())%>원
						</td>
						
						<!-- 배송상태 -->
						<td style="width: 15%; max-width: 15%; font-size: 9px;"><!-- 배송상태 -->
							<%= deleveryStatus %>
						</td>

						<td style="width: 10%; max-width: 10%;"><!-- 반품,교환 버튼 -->
						<% 
							//반품신청은 한달 이내만 받는다 
							if (isReviewAllowed==true && 
							(deleveryStatus.equals("배송중")
							||deleveryStatus.equals("배송완료"))) { 
						%>   
								<p><!-- 반품신청 -->
									<button class="custom-button" onclick="location.href='<%= request.getContextPath() %>/orders/returnProduct.jsp?orderProductNo=' + <%=orderProductNo %>">반품신청</button>
								</p>
						<%
							}
							//교환신청은 한달 이내만 받는다 
							if (isReviewAllowed==true && 
							(deleveryStatus.equals("배송중")
							||deleveryStatus.equals("배송완료"))) { 
							%>   
								<p><!-- 교환신청 -->
									<button class="custom-button"  onclick="location.href='<%= request.getContextPath() %>/orders/switchProduct.jsp?orderProductNo=<%= orderProductNo%>'">교환신청</button>	
								</p>
						<%
							}
						%>
						</td>
						<td style="width: 10%; max-width: 10%;"><!-- 수취버튼 -->
						<!--
						4. 버튼  4-1)반품신청 버튼 -> 반품 페이지 / 
						4-2)교환신청 버튼->교환 페이지 /
						4-3) 수취확인 버튼 -> db 상태값 변경  ***** 수취확인시 상품평 버튼으로 변경**** ->리뷰 작성 페이지******* 리뷰 작성시 리뷰 수정 페이지
						 -->
						<%
						// 배송상태에 따라 버튼 분기
						if (deleveryStatus.equals("주문확인중")) {
						%><!-- 주문취소 -->
						    <form action="<%= request.getContextPath() %>/orders/orderCancel.jsp" method="GET">
						        <input type="hidden" name="orderNo" value="<%= orderNo %>">
						        <button type="submit" class="custom-button">주문취소</button>
						    </form>
						<%
						} else if (deleveryStatus.equals("배송중") || deleveryStatus.equals("배송완료") || deleveryStatus.equals("교환 중")) {
						%><!-- 수취확인 -->
						    <form action="<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp" method="GET">
						        <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
						        <button type="submit" class="custom-button">수취확인</button>
						    </form>
						<%
						} else if (deleveryStatus.equals("구매확정")) {
						    if (canWriteReview) {
						%><!-- 리뷰작성 -->
						    <form action="<%= request.getContextPath() %>/review/addReview.jsp" method="GET">
						        <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
						        <button type="submit" class="custom-button">상품평</button>
						    </form>
						<%
						    } else if (reviewWritten != null) {
						%><!-- 리뷰수정 -->
						    <form action="<%= request.getContextPath() %>/review/modifyReview.jsp?orderProductNo=<%= orderProductNo %>" method="GET">
						        <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
						        <button type="submit" class="custom-button">리뷰 수정</button>
						    </form>
						<%
						    }
						}
						%>

						</td>
					</tr>					
				<%
					}
				//쉼표 찍어준다
				String formattedOrderPrice = decimalFormat.format(orders.getOrderPrice());
				String formattedOriPrice = decimalFormat.format(oriPrice);
				String formattedDiscountAmount = decimalFormat.format(oriPrice - (int)orders.getOrderPrice());
				%>
				</tbody>
			</table>
		</div>
	</div>
	
 <!--
 5-1)총 결제 금액 / 
 5-2)총 상품 금액 / 
 5-3)총 할인 금액 
 -->
  <!--
 6. 적립 혜택 구매 적립 
 -->
				 <div class="col-12 col-lg-4">
					<div class="cart-summary">
						<h5>Order Summary</h5>
						<ul class="summary-table">
							<li><span style="font-weight: bold; font-size: larger;">Total</span> <span style="font-weight: bold; font-size: larger;"> ₩ <%= formattedOrderPrice %></span></li>
							<li><span style="color: gray; font-size: small; text-decoration: line-through;">총 상품 금액 :</span> <span style="color: gray; text-decoration: line-through;">₩ <%= formattedOriPrice %></span></li>
							<li><span>총 할인 금액 : </span> <span>₩ <%= formattedDiscountAmount %> </span></li>
							<li><span>적립 혜택 : </span> <span> <%= decimalFormat.format(pointByOrder) %> P</span></li>
						</ul>
					</div>
				</div>
				</div>
 			</div>
 		</div>
 	</div>
 	
 	
 	
 	
 	
 	
 	
<!-- ##### Footer Area Start ##### -->
    <div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
<!-- ##### Footer Area End ##### -->

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <div>    
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>
    </div>
</body>
</html>