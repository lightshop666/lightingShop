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
		System.out.println(orderNo + "<-parm-- orderNo orderCancel.jsp");

	}else{
		System.out.println("orderNo 유효성 검사에서 튕긴다<---orderCancel.jsp");
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
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	
	/*이미지 사이즈, 클릭시 풀스크린*/
	.thumbnail {
    max-width: 200px;
    cursor: pointer;
  	}
	.fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background-color: white;
    display: flex;
    align-items: center;
    justify-content: center;
  	}
	.fullscreen img {
    max-width: 80%;
    max-height: 80%;
	}
</style>
</head>
<body>
<div class="container">	
	<form action="<%= request.getContextPath() %>/orders/orderCancelAction.jsp" method="post" enctype="application/x-www-form-urlencoded">
	<%
		int orderProductNo = 0;
		for(OrderProduct o : orderProducts){
			orderNo =(int)orders.getOrderNo();
			orderProductNo = o.getOrderProductNo();
			System.out.println(orderNo + "<--(int)orders.getOrderNo()--orderCancel.jsp");

			
			HashMap<String, Object> productInfo =  productDao.selectProductAndImg(o.getProductNo());
			// 상품 정보와 이미지 가져오기
			Product product = (Product) productInfo.get("product");
			ProductImg productImg = (ProductImg) productInfo.get("productImg");
			
			// 할인된 가격 계산
			int discountedPrice = 0;
			discountedPrice = orderProductDao.discountedByOrders(product.getProductNo(), orders.getCreatedate());
			

		    // 배송 상태가 주문확인중이 아니라면 체크박스를 체크할 수 없도록 처리
			boolean disableCheckbox = !o.getDeliveryStatus().equals("주문확인중");
	%>
			<input type="checkbox" name="selectedProducts[]" value="<%=(int) o.getOrderProductNo()%>" data-price="<%= discountedPrice * o.getProductCnt() %>" <%= disableCheckbox ? "disabled" : "" %>>
			<div>
				<p>
					<!-- 상품이미지 -->
					<!-- 체크박스 (name 속성에 []를 추가하여 배열로 설정) -->
					<img class="thumbnail" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
				</p>
				<p onclick="location.href='<%= request.getContextPath() %>/product/productOne.jsp?productNo=' + <%= product.getProductNo()%>;">
					<!-- 상품이름 -->
					상품 이름: <%= product.getProductName() %>
				</p>
				<p>상품 금액 : <%=discountedPrice * o.getProductCnt()  %></p>
				<p>상품 수량 : <%= o.getProductCnt() %></p>
				<!-- 액션에서 처리할 값 -->
				<input type="hidden" name="productCnt[]" value="<%=o.getProductCnt()%>">		
				<hr>
			</div>
		
	<%
		}
	%>
		<input type="hidden" name="orderNo" value="<%= orders.getOrderNo() %>">
		<input type="hidden" name="totalPriceInput" id="totalPriceInput">
		<input type="hidden" name="unselectedPrice" id="unselectedPrice" value="0">
		<!-- 취소 버튼 -->
		<input type="submit" id="cancelButton" value="취소 신청">		
		
		<script>
		    // 폼 전송 시 값을 설정하는 함수 호출
		    calculateTotalPrice();
		</script>
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