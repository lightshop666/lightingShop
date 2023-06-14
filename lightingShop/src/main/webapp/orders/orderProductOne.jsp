<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 검사
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	
	//주문번호 유효성 검사
	int orderNo=11;
	if(request.getParameter("orderNo")!=null){
		orderNo = Integer.parseInt(request.getParameter("orderNo"));
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
	
	
	
	//주문조회 
	HashMap<String, Object> map = orderDao.selectOrdersOne(orderNo);
	Orders orders = (Orders) map.get("orders");
	List<OrderProduct> orderProducts = (List<OrderProduct>) map.get("orderProducts");

	
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
	
	

	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
</head>
<body>
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
	<hr>
<!--
3.상품 타이틀 - 상품별로 레이아웃 감싸기
3-1) 배송 상태
3-2)상품 이미지, 상품 타이틀, 판매가 / 
3-3)반품신청 버튼 -> 반품 페이지 / 
3-4)교환신청 버튼->교환 페이지 / 
3-5) 수취확인 버튼 -> db 상태값 변경 
-->
	<%
		for (int i = 0; i < productInfos.size(); i++) {
			HashMap<String, Object> productInfo = productInfos.get(i);
			// 주문 상품에 대한 정보
			OrderProduct orderProduct = orderProducts.get(i);
		//디버깅
			System.out.println(orderProduct.getOrderProductNo()+"<--orderPorductNo orderProductOne.jsp");
		
			//상품 정보와 이미지 가져오기
			Product product = (Product) productInfo.get("product");
			ProductImg productImg = (ProductImg) productInfo.get("productImg");

			
			// 한 달 이후로는 리뷰를 쓸 수 없게 리뷰 버튼 없애기 위한 DB 조회
			HashMap<String, Object> orderProductInfo = orderProductDao.selectOrderProduct(orderProduct.getOrderProductNo());
			String deleveryStatus = (String)orderProductInfo.get("deleveryStatus");
			Date createDate = (Date) orderProductInfo.get("createdate");
			Date todayDate = (Date) orderProductInfo.get("todaydate");
			boolean isReviewAllowed = orderProductDao.checkReviewEligibility(createDate, todayDate);
			
		//디버깅	
			System.out.println(deleveryStatus+"<--deleveryStatus orderProductOne.jsp");
			System.out.println(createDate+"<--createDate orderProductOne.jsp");
			System.out.println(todayDate+"<--todayDate orderProductOne.jsp");
			System.out.println(isReviewAllowed+"<--isReviewAllowed orderProductOne.jsp");
				
			//리뷰가 이미 작성된 경우 조건문을 위한 호출
			HashMap<String, Object> review = reviewDao.customerReview(orders.getId());
			String reviewWritten = (String)review.get("reviewWritten");
		    
	%>
			<div>
				<p>배송 상태: <%=deleveryStatus %></p>
				
				<div onclick="location.href='<%= request.getContextPath() %>/product/productOne.jsp?productNo=' + <%= product.getProductNo() %>;">
					<p>
						상품 이미지
						<img class="thumbnail" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
					</p>
					<p>상품 이름: <%= product.getProductName() %></p>
				</div>
				
				<p>상품 가격: <%=(int) productInfo.get("discountedPrice") %>원</p>
				<% 
					//반품신청은 한달 이내만 받는다 
					if (isReviewAllowed==true && 
					(deleveryStatus.equals("배송중")
					||deleveryStatus.equals("배송완료")
					||deleveryStatus.equals("교환 중"))) { 
				%>   
					<p>
						<a href="<%= request.getContextPath() %>/orders/returnProduct.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
							반품신청
						</a>			
					</p>
				<%
					}
				//반품신청은 한달 이내만 받는다 
				if (isReviewAllowed==true && 
				(deleveryStatus.equals("배송중")
				||deleveryStatus.equals("배송완료")
				||deleveryStatus.equals("교환 중"))) { 
				%>   
					<p>
						<a href="<%= request.getContextPath() %>/orders/switchProduct.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
							교환신청
						</a>			
					</p>
				<%
					}
				%>
				<p>
				<%
					//배송상태에 따라 버튼 분기
					if(deleveryStatus.equals("배송중")
					||deleveryStatus.equals("배송완료")
					||deleveryStatus.equals("교환 중")){				
				%>
						<a href="<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
							수취확인
						</a>					
				<%
					//배송 상태가 구매확정이고 리뷰 상태가 아직 쓰여지지 않은 경우
					}else if(deleveryStatus.equals("구매확정")
					//주문한지 한 달 이내인지
					&& isReviewAllowed==true
					//작성여부가 N인지
					&& reviewWritten.equals("N")){
				%>
						<a href="<%= request.getContextPath() %>/review/addReview.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
							리뷰작성
						</a>				
				<%
					}else if(deleveryStatus.equals("구매확정")
							//주문한지 한 달 이내인지
							&& isReviewAllowed==true
							//작성여부가 Y인지
							&& reviewWritten.equals("Y")){
				%>
						<a href="<%= request.getContextPath() %>/review/modifyReview.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
							리뷰수정
						</a>		
				<%
					}
				%>
				</p>
			</div>
			<hr>
	<%
		}
	%>

<!--
4. 버튼  4-1)반품신청 버튼 -> 반품 페이지 / 
4-2)교환신청 버튼->교환 페이지 /
4-3) 수취확인 버튼 -> db 상태값 변경  ***** 수취확인시 상품평 버튼으로 변경**** ->리뷰 작성 페이지******* 리뷰 작성시 리뷰 수정 페이지
 
 5-1)장바구니 번호  / 
 5-2)주문일 / 
 5-3)결제방식 / 
 5-4)총 결제 금액 / 
 5-5)총 상품 금액 / 
 5-6)총 할인 금액 
 
 6. 적립 혜택 구매 적립 
 -->
</body>
</html>