<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//교환 페이지	
	request.setCharacterEncoding("utf-8");	

	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 switchProduct.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- switchProduct.jsp");
		return;
	}

	//유효성 검사. 교환을 위해 orderProductNo가 없으면 안되니까 리다이렉트
	String orderProductNoParam = request.getParameter("orderProductNo");
	int orderProductNo = 0;
	if (orderProductNoParam != null && !orderProductNoParam.isEmpty()) {
		orderProductNo = Integer.parseInt(orderProductNoParam);
		System.out.println(orderProductNo + "<-parm-- orderProductNo switchProduct.jsp");
	} else {
		System.out.println("orderProductNo 유효성 검사에서 튕긴다<---switchProduct.jsp");
		out.println("<script>alert('선택된 상품이 없습니다.'); history.go(-1);</script>");
		return;
	}

	//모델 소환
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//상품 정보, 할인된 가격 소환
	OrderProduct orderProduct = orderProductDao.orderProductOne(orderProductNo);
	int productNo = orderProduct.getProductNo();
	
	// 상품 정보와 이미지 정보를 조회하는 메서드 호출
	HashMap<String, Object> productMap = productDao.selectProductAndImg(productNo);
	//상품 정보와 이미지 가져오기
	Product product = (Product) productMap.get("product");
	ProductImg productImg = (ProductImg) productMap.get("productImg");
	// 상품 가격에 대한 할인 정보를 조회하여 할인된 가격을 추가
	int discountedPrice = orderProductDao.discountedPrice(productNo);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교환 신청</title>
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
		<form action="<%= request.getContextPath() %>/orders/switchProductAction.jsp" method="post">
            <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                <h2>교환 사유를 선택하세요</h2>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="single-product-wrapper">
                        <div class="product-img">
						<%		// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
									if(productImg.getProductSaveFilename() == null) {
						%>
										<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
						<%
									}else {
						%>
										<img class="thumbnail" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
						<%
									}
						%>
                        </div>
                        <div class="product-description d-flex align-items-center justify-content-between">
                            <div class="product-meta-data">
                                <div class="line"></div>
                                <p class="product-price">
	                                <span><%= product.getProductName() %></span>
	                                <br>
									<span><%= orderProduct.getProductCnt() %>개</span>
									<span>₩ <%=discountedPrice * orderProduct.getProductCnt()  %></span>   
                                </p>
                            </div>
									
								</div>
							</div>
							<div class="ratings-cart text-right">
							    <div class="ratings d-flex align-items-center">
									<label>
										<input type="radio" name="exchangeReason" value="changedMind">
											마음이 변했어요
										<span style="float: right; font-size: 12px; color: lightgray;">반품비 구매자 부담</span>
									</label>
									
									<label>
										<input type="radio" name="exchangeReason" value="productProblem">
										상품이 불량이에요
										<span style="float: right; font-size: 12px; color: lightgray;">반품비 판매자 부담</span>
									</label>
									
									<label>
										<input type="radio" name="exchangeReason" value="missDelivery">
										상품이 오배송 됐어요
										<span style="float: right; font-size: 12px; color: lightgray;">반품비 판매자 부담</span>
									</label>
								</div>
									<div>
										<div>
										<label id="detailReasonLabel" style="display: none;">
											상세사유
											<textarea id="detailReason" name="detailReason" rows="3" cols="40" placeholder="판매자에게 추가로 전달할 사유가 있다면 입력해주세요 (100글자)" maxlength="100" disabled></textarea>
										</label>
									</div>
										<input type="hidden" name="orderProductNo" value="<%= orderProductNo%>">
										<button type="submit" class="btn amado-btn w-100">교환 신청</button>		
									</div>
							</div>
						</div>
					</div>
				</form>
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
<!-- JS 유효성 검사 -->
<script>
	document.querySelector("form").addEventListener("submit", function(event) {
		// 선택된 교환 사유 확인
		let exchangeReasons = document.getElementsByName("exchangeReason");
		let selectedReason = false;
		for (let i = 0; i < exchangeReasons.length; i++) {
			if (exchangeReasons[i].checked) {
				selectedReason = true;
				break;
			}
		}

		if (!selectedReason) {
			alert("교환 사유를 선택해주세요.");
			event.preventDefault(); // 폼 제출 중단
			return;
		}
	});
</script>

<script>
	let radioButtons = document.getElementsByName("exchangeReason");
	let detailReasonLabel = document.getElementById("detailReasonLabel");
	let textarea = document.getElementById("detailReason");
	let submitBtn = document.getElementById("submitBtn");

	radioButtons.forEach(function(radio) {
		radio.addEventListener("change", enableTextarea);
	});

	function enableTextarea() {
		for (let i = 0; i < radioButtons.length; i++) {
			if (radioButtons[i].checked) {
				detailReasonLabel.style.display = "block";
				textarea.disabled = false;
				submitBtn.disabled = false;
				return;
			}
		}

		detailReasonLabel.style.display = "none";
		textarea.disabled = true;
		submitBtn.disabled = true;
	}
</script>
</html>