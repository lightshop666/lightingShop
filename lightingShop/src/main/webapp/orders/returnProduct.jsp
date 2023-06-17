<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//반품 페이지	
	request.setCharacterEncoding("utf-8");	

	//유효성 검사. 반품을 위해 orderProductNo가 없으면 안되니까 리다이렉트
	String orderProductNoParam = request.getParameter("orderProductNo");
	int orderProductNo = 0;
	if (orderProductNoParam != null && !orderProductNoParam.isEmpty()) {
		orderProductNo = Integer.parseInt(orderProductNoParam);
		System.out.println(orderProductNo + "<-parm-- orderProductNo returnProduct.jsp");
	} else {
		System.out.println("orderProductNo 유효성 검사에서 튕긴다<---returnProduct.jsp");
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
<title>반품 신청</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">	
	<h3>반품 사유를 선택하세요</h3>
	<form action="<%= request.getContextPath() %>/orders/returnProductAction.jsp" method="post">
		<div>
			<p>상품 이미지
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
		</p>
			<p>상품 이름: <%= product.getProductName() %></p>			
			<p>상품 수량 : <%= orderProduct.getProductCnt() %></p>
			<p>상품 금액 : <%=discountedPrice * orderProduct.getProductCnt()  %></p>
		</div>
		
		<label>
			<input type="radio" name="returnReason" value="changedMind">
				마음이 변했어요
			<span style="float: right; font-size: 12px; color: lightgray;">반품비 구매자 부담</span>
		</label>
		
		<label>
			<input type="radio" name="returnReason" value="productProblem">
			상품이 불량이에요
			<span style="float: right; font-size: 12px; color: lightgray;">반품비 판매자 부담</span>
		</label>
		
		<label>
			<input type="radio" name="returnReason" value="missDelivery">
			상품이 오배송 됐어요
			<span style="float: right; font-size: 12px; color: lightgray;">반품비 판매자 부담</span>
		</label>
		<label id="detailReasonLabel" style="display: none;">
			상세사유
			<textarea id="detailReason" name="detailReason" rows="3" cols="40" placeholder="판매자에게 추가로 전달할 사유가 있다면 입력해주세요 (100글자)" maxlength="100" disabled></textarea>
		</label>
		<div>
			<input type="hidden" name="orderProductNo" value="<%= orderProductNo%>">
			<button type="submit">반품 신청</button>		
		</div>
	</form>
</div>
</body>
<!-- JS 유효성 검사 -->
<script>
	document.querySelector("form").addEventListener("submit", function(event) {
		// 선택된 반품 사유 확인
		let returnReasons = document.getElementsByName("returnReason");
		let selectedReason = false;
		for (let i = 0; i < returnReasons.length; i++) {
			if (returnReasons[i].checked) {
				selectedReason = true;
				break;
			}
		}

		if (!selectedReason) {
			alert("반품 사유를 선택해주세요.");
			event.preventDefault(); // 폼 제출 중단
			return;
		}
	});
</script>

<script>
	let radioButtons = document.getElementsByName("returnReason");
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