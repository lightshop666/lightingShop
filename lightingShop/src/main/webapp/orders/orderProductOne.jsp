<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 검사
	
	//주문번호 유효성 검사
	int orderNo=0;
	if(request.getParameter("orderNo")!=null){
		orderNo = Integer.parseInt(request.getParameter("orderNo"));
	}
	/*
	주문번호+상품별 배송정보+[상품정보+반품,교환,수취확인 버튼] x n +결제정보 + 적립혜택
	*/
	
	//모델 호출
	OrderDao orderDao = new OrderDao();
	CustomerDao customeDao = new CustomerDao();
	ProductDao productDao = new ProductDao();
	OrderProductDao orderProductDao =new OrderProductDao();
	
	//주문조회 
	HashMap<String, Object> map = orderDao.selectOrdersOne(orderNo);
	Orders orders = (Orders) map.get("orders");
	List<OrderProduct> orderProducts = (List<OrderProduct>) map.get("orderProducts");

	Customer customer = new Customer();
	customer.setId(orders.getId());
	
	//고객정보
	HashMap<String, Object> customerMap = customeDao.selectCustomerOne(customer);
	String customerName = (String)customerMap.get("c.cstm_name");
	
	
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
	<p>연락처 : <%=orders.getOrderNo()  %></p>
	<p>받는 주소 : <%=orders.getOrderAddress()  %></p>
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
	%>
			<div>
				<p>배송 상태: <%= orders.getDeliveryStatus() %></p>
				<p>
					상품 이미지
					<img class="thumbnail" src="<%= request.getContextPath() %>/<%= (String) productInfo.get("productPath") %>/<%= (String) productInfo.get("productSaveFilename") %>" alt="Product Image">
				</p>
				<p>상품 이름: <%= productInfo.get("productName") %></p>
				<p>상품 가격: <%=(int) productInfo.get("discountedPrice") %></p>
				<p>
					<a href="<%= request.getContextPath() %>/orders/returnProduct.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
						반품신청
					</a>			
				</p>
				<p>
					<a href="<%= request.getContextPath() %>/orders/switchProduct.jsp?orderProductNo=<%= orderProducts.get(i).getOrderProductNo() %>">
						교환신청
					</a>			
				</p>
				<p>
					<button type="button" id="confirmReceipt" onclick="confirmReceipt()">수취확인</button>
				</p>
			</div>
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