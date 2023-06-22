<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat" %>

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
	
	//숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 취소 선택</title>
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


<div class="amado_product_area section-padding-100">
    <div class="container-fluid">
        <form action="<%= request.getContextPath() %>/orders/orderCancelAction.jsp" method="post" enctype="application/x-www-form-urlencoded">
            <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                <h2>주문 취소 선택</h2>
            </div>
            <div class="row">
                <% int orderProductNo = 0;
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
                <div class="col-12 col-sm-6 col-md-12 col-xl-6">
                    <div class="single-product-wrapper">
                        <input type="checkbox" id="selectedProducts[]" name="selectedProducts[]" value="<%=(int) o.getOrderProductNo()%>" data-price="<%= discountedPrice * o.getProductCnt() %>" <%= disableCheckbox ? "disabled" : "" %>>
                        <div class="product-img">
                            <% if(productImg.getProductSaveFilename() == null) { %>
                            <a class="gallery_img" href="<%=request.getContextPath()%>/productImg/no_image.jpg">
                                <img class="d-block w-100" src="<%=request.getContextPath()%>/productImg/no_image.jpg" alt="No Image">
                            </a>
                            <% } else { %>
                            <a class="gallery_img" href="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>">
                                <img class="d-block w-100" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
                            </a>
                            <% } %>
                        </div>
                        <div class="product-description d-flex align-items-center justify-content-between">
                            <div class="product-meta-data">
                                <div class="line"></div>
                                <p class="product-price"><%=decimalFormat.format( discountedPrice * o.getProductCnt() ) %> 원</p>
                                <a href="<%= request.getContextPath() %>/product/productOne.jsp?productNo=<%= product.getProductNo() %>">
                                    <h6><%= product.getProductName() %></h6>
                                </a>
                            </div>
							<div class="ratings-cart text-right">
							    <div class="ratings d-flex align-items-center">
							        <span class="mr-1"><%= o.getProductCnt() %></span>
							        <span>개</span>
							    </div>
							    <div></div>
							</div>
                        </div>
                        <input type="hidden" name="productCnt[]" value="<%=o.getProductCnt()%>">
                    </div>
                </div>
                <% } %>
            </div>
            <input type="hidden" name="orderNo" value="<%= orders.getOrderNo() %>">
            <input type="hidden" name="totalPriceInput" id="totalPriceInput" value="">
            <input type="submit" class="btn amado-btn w-100" id="cancelButton" value="취소 신청">
        </form>
    </div>
</div>
</div></



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
<script>

	//주문 취소 N건 표시
	let checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedProducts[]"]');
	let submitButton = document.querySelector('#cancelButton');
	
	//취소신청 버튼 값 변화
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
		//체크박스 전부 가져오기
		let checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedProducts[]"]');
		console.log(checkboxes +'<--checkboxes 체크박스 전부 가져오기 orderCancel.jsp JS');

		//총 가격 초기화
		let totalPrice = 0;
		//선택되지 않은 상품 가격 초기화
		let unselectedTotalPrice = 0;
		
		//체크박스 돌며 가격 계산
		checkboxes.forEach(function(checkbox) {
			//체크박스에 설정된 가격을 가져온다
			let productPrice = parseFloat(checkbox.dataset.price);
			//체크박스가 선택되었다면
			if (checkbox.checked) {
				//토탈가격에 상품 가격 더해준다
				totalPrice += productPrice;
				console.log(totalPrice +'<--토탈가격에 더한다. orderCancel.jsp JS');
			} 
		});
		
		//총 가격과 선택되지 않은 가격 html에 뿌려준다.
		document.querySelector('#totalPriceInput').value = totalPrice;
		console.log(totalPrice);
		console.log(totalPrice.toFixed(2));

	}
	

    // 폼 전송 시 값을 설정하는 함수 호출
	  calculateTotalPrice();
</script>
</html>