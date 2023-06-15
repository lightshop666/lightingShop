<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//주문취소 액션	
	request.setCharacterEncoding("utf-8");	

	//유효성 검사. 주문취소를 위해 orderNo가 없으면 안되니까 리다이렉트
	int orderNo = 0;
	if(request.getParameter("orderNo")!=null){
		orderNo = Integer.parseInt(request.getParameter("orderNo"));
	}else{
		System.out.println("orderNo 유효성 검사에서 튕긴다<---orderCancelAction.jsp");
        response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//모델 소환
	OrderDao orderDao = new OrderDao();
	ProductDao productDao = new ProductDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	
	//orderNo에 따른 orderProduct 체크박스 체크를 위한 호출
	HashMap<String, Object> map = orderDao.selectOrdersOne(orderNo);
	Orders orders = (Orders) map.get("orders");
	List<OrderProduct> orderProducts = (List<OrderProduct>) map.get("orderProducts");
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 취소 선택</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">	
	<form action="<%= request.getContextPath() %>/orders/orderCancelAction.jsp" method="post">
	<%
		for(OrderProduct o : orderProducts){
			//만약 배송상태가 주문확인중이 아니라면 튕긴다.
			if(o.getDeliveryStatus().equals("주문확인중")){
		        response.sendRedirect(request.getContextPath() + "/orders/orderProductOne.jsp?orderNo="+o.getOrderNo());
				return;
			}
			
			HashMap<String, Object> productInfo =  productDao.selectProductAndImg(o.getProductNo());
			// 상품 정보와 이미지 가져오기
			Product product = (Product) productInfo.get("product");
			ProductImg productImg = (ProductImg) productInfo.get("productImg");
			
			// 할인된 가격 계산
			int discountedPrice = 0;
			discountedPrice = orderProductDao.discountedByOrders(product.getProductNo(), orders.getCreatedate());
			
	%>
			<input type="checkbox" name="selectedProducts[]" value="<%= product.getProductNo() %>" data-price="<%= discountedPrice * o.getProductCnt() %>">>
			<div>
				<p>
					<!-- 상품이미지 -->
					<!-- 체크박스 (name 속성에 []를 추가하여 배열로 설정) -->
					<img class="thumbnail" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
				</p>
				<p onclick="location.href='<%= request.getContextPath() %>/product/productOne.jsp?productNo=' + <%= product.getProductNo() %>;">
					<!-- 상품이름 -->
					상품 이름: <%= product.getProductName() %>
				</p>
				<p>상품 금액 : <%=discountedPrice * o.getProductCnt()  %></p>
				<p>상품 수량 : <%= o.getProductCnt() %></p>
				<!-- 액션에서 처리할 값 -->
				<input type="hidden" name="productNo" value="<%= o.getOrderProductNo()%>">
				<input type="hidden" name="productCnt" value="<%=o.getProductCnt()%>">		
				<hr>
			</div>
		
	<%
		}
	%>
		<!-- 취소 버튼 -->
		<input type="submit" id="cancelButton" value="취소 신청">		
		<input type="hidden" name="orderNo" value="<%= orders.getOrderNo() %>">
		<input type="hidden" name="totalPriceInput" id="totalPriceInput">
		<input type="hidden" name="unselectedPrice" id="unselectedPrice" value="0">
		
	</form>
</div>
</body>
<script>

	//주문 취소 N건 표시
	let checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedProducts[]"]');
	let submitButton = document.querySelector('#cancelButton');
	
	function updateSubmitButtonText() {
		let checkedCount = Array.prototype.filter.call(checkboxes, function(checkbox) {
			return checkbox.checked;
		}).length;		
		submitButton.value = checkedCount + "건 취소 신청";
	}		
	
	Array.prototype.forEach.call(checkboxes, function(checkbox) {
			checkbox.addEventListener('change', updateSubmitButtonText);
	});
	
	// 체크박스 선택 여부에 따라 합계를 계산하고 넘겨주는 함수
	function calculateTotalPrice() {
		let checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedProducts[]"]');
		let totalPrice = 0;
		let unselectedTotalPrice = 0;
		
		checkboxes.forEach(function(checkbox) {
			let productPrice = parseFloat(checkbox.dataset.price);
			if (checkbox.checked) {
				totalPrice += productPrice;
			} else {
				unselectedTotalPrice += productPrice;
			}
		});
		
		document.querySelector('#totalPriceInput').value = totalPrice;
		document.querySelector('#unselectedPrice').value = unselectedTotalPrice;
	}
</script>
</html>