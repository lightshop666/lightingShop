<%@page import="javax.script.ScriptContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat" %>

<%
	request.setCharacterEncoding("utf-8");	
//유효성 검사
	//세션 유효성 검사 --> 비회원은 주문할 수 없다 게스트 걸러내기
	Customer customer = new Customer();
	
	if(session.getAttribute("loginIdListId") != null) {
		customer.setId((String)session.getAttribute("loginIdListId"));
		System.out.println(customer.getId()+"<--새로 들어온 아이디 orderProduct.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴");
		return;
	}

	System.out.println(customer.getId()+"<--customer.getId()-- orderProduct.jsp");
	
	if(request.getParameterValues("productNo").length==0){
	    out.println("<script>alert('선택된 상품이없습니다. StrOrderProductList'); history.go(-1);</script>");
	    return;
	}
	String[] productNos = request.getParameterValues("productNo");
	String[] productCnts = request.getParameterValues("productCnt");
	
	//상품번호,수량 검사
	String[] productNo = new String[99];
	if(request.getParameter("productNo") != null) {
	   productNo =  Arrays.stream(productNos)
	             .filter(s -> !s.isEmpty())
	             .toArray(String[]::new);
	}else{
	}
	
	String[] productCnt = new String[99];
	if(request.getParameter("productCnt") != null) {
	   productCnt = Arrays.stream(productCnts)
	             .filter(s -> !s.isEmpty())
	             .toArray(String[]::new);
	}
	// 디버깅을 위해 출력
	System.out.println("Selected Product Numbers: " + Arrays.toString(productNo));
	System.out.println("Selected Product Quantities: " + Arrays.toString(productCnt));
	   
	   
	// 배열의 길이 확인
	if (productNo.length != productCnt.length) {
		 // 배열의 길이가 다른 경우 리스폰 처리
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}


	
	if (productNo == null || productNo.length == 0 || productCnt == null || productCnt.length == 0) {
	    // 선택된 상품이 없거나 수량이 입력되지 않은 경우 처리
	    System.out.println("상품번호 또는 수량이 유효하지 않습니다. <--orderProduct.jsp");
	    //-----------------------------------------------------------------------어디로 보낼지 고민--//
		//response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + request.getParameterValues("productNo[0]"));

   		if (productNo.length > 1) {
			// 카트에서 넘어온 경우
			response.sendRedirect(request.getContextPath() + "/cart/cartList.jsp");
		} else {
			// 단일 주문인 경우
			int singleProductNo = Integer.parseInt(productNo[0]);
			response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + request.getParameterValues("productNo[0]"));
		}
	    return;
	}
	
	 
// 선택된 상품 번호 유효성 검사
	//상품 정보 (product, product_img, discount 테이블 조회) 모델 호출
	ProductDao productDao = new ProductDao();
	List<Product> selectedProducts = new ArrayList<>();
	List<ProductImg> selectedProductImgs = new ArrayList<>();
	
	//할인된 가격 모델 호출
	OrderProductDao orderProductDao = new OrderProductDao();
	List<Integer> discountedPrices = new ArrayList<>();

	for (int i = 0; i < productNo.length; i++) {
	    int intProductNo = Integer.parseInt(productNo[i]);
	    int intProductCnt = Integer.parseInt(productCnt[i]);
	  
	    // 상품 번호의 유효성을 검사하고 상품 상세 저장
	    HashMap<String, Object> map = productDao.selectProductAndImgOne(intProductNo);
	    Product product = (Product) map.get("product");
	    ProductImg productImg = (ProductImg) map.get("productImg");
	    Discount discount = (Discount) map.get("discount");
	    
	    //상품 번호 유효성 검사
	    if (map ==null ||
	    	product.getProductNo() == 0) {
	   	    System.out.println("상품번호 유효성 getProductNo() 검사에서 튕긴다 <--orderProduct.jsp");
	        // 유효하지 않은 상품 번호인 경우 처리
			//-----------------------------------------------------------------------어디로 보낼지 고민--//
	    	response.sendRedirect(request.getContextPath() + "/ .jsp");
	        return;
	        
	    //상품이 품절인 경우    
	    }else if(product.getProductStatus().equals("품절")){
	   	    System.out.println("상품 상태가 품절입니다.<--orderProduct.jsp");
			if (productNo.length > 1) {
				// 카트에서 넘어온 경우
				response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
			} else {
				// 단일 주문인 경우
				int singleProductNo = Integer.parseInt(productNo[0]);
			    out.println("<script>alert('상품이 품절입니다.'); history.go(-1);</script>");
				//response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + product.getProductNo());
			}
			
		//상품의 재고보다 많이 주문한 경우 
	    }else if(intProductCnt > product.getProductStock()){
	   	    System.out.println("재고보다 많이 주문했습니다.<--orderProduct.jsp");
			if (productNo.length > 1) {
				// 카트에서 넘어온 경우
				response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
			} else {
				// 단일 주문인 경우
				int singleProductNo = Integer.parseInt(productNo[0]);
				response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + product.getProductNo());
			}
	    }
//-----------------------------------------------------------------유효성 검사 종료--//	    

	    // 할인된 가격 조회
	    int discountedPrice = orderProductDao.discountedPrice(intProductNo);
	    
		// 상품 정보와 이미지를 리스트에 추가
		selectedProducts.add(product);
		selectedProductImgs.add(productImg);
	    discountedPrices.add(discountedPrice);
	}

	
	//고객 정보 출력을 위한 모델 소환
	CustomerDao customerDao = new CustomerDao();
	HashMap<String, Object> customerInfo = customerDao.selectCustomerOne(customer);
	System.out.println(customerInfo.get("c.id")+"<--c.id--orderProduct.jsp");
	
	int totalPoint = customerDao.selectPointCustomer(customer.getId());
	
	// 포인트 차등 적립을 위한 고객 정보
	double pointRate = 0;
	if (customerInfo.containsKey("c.cstm_rank")) {
		String rank = (String) customerInfo.get("c.cstm_rank");
		if (rank.equals("금")) {
		    pointRate = 0.05; // 랭크 금이면 5퍼
			System.out.println(pointRate + "고객 랭크 : 금 <--orderProduct.jsp");
		} else if (rank.equals("은")) {
		    pointRate = 0.03; // 랭크 은이면 3퍼
			System.out.println(pointRate + "고객 랭크 : 은 <--orderProduct.jsp");
		} else {
		    pointRate = 0.01; // 그 외 1퍼
			System.out.println(pointRate + "고객 랭크 : 그 외<--orderProduct.jsp");
		}
	} else {
	    System.out.println("고객 랭크가 없습니다 <--orderProduct.jsp");
	    //-----------------------------------------------------------------------어디로 보낼지 고민--//
		//response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + request.getParameterValues("productNo[0]"));
	}

	//숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문하기</title>
<head>
   <meta charset="UTF-8">
   <!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
   
   <!-- Title  -->
   <title>조명 가게 | 주문서</title>
   
	<style>
		.font-bold {
			font-weight:bold;
		}
		.font-orange {
			color:#FF5E00;
		}
		.line-through {
		  text-decoration: line-through;
		}
		
		
	</style>
	
	<!-- BootStrap5 -->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
   
   <!-- Favicon  -->
   <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
   
   <!-- Core Style CSS -->
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
   
</head>
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

		<!-- 주문 상품 출력
		이름	연락처			변경(누르면 배송지 변경 --배송지 리스트 출력)
		주소
		배송시 요청사항을 선택해주세요(셀렉트)
		--
		주문상품
		상품이미지	상품정보
		상품원래 가격 /  할인된 가격
		--
		결제 방법(어떻게할지 고민)
		3-1) 상품 총액
		3-2) 포인트 적용 여부(JS로 가능하면)  
		3-3)전액 사용+항상 전액 사용 버튼(JS로 가능하면) 
		3-4)결제금액- : 상품금액 / 
		3-5)배송비(상품금액 일정 이상이면 배송비 0원으로) / 
		3-6)총 결제 금액 / 
		3-7) 결제 방법(??? 도움) 
		--
		최종 결제 금액
		(상품 금액, 포인트 금액, 배송비)
		--
		적립예정 포인트
		--
		총 할인된 가격 / ~~~원 결제 (최종금액)
		 -->
		<!-- 넘겨줄 것 : productNo배열, productCnt배열, 최종금액 -->
	<!----------------------- 주문인 정보
		이름	연락처			변경(누르면 배송지 변경 --배송지 리스트 출력)
		주소
		배송시 요청사항을 선택해주세요(셀렉트
	 -->
		<div class="cart-table-area section-padding-80">
			<div class="container-fluid">
				<div class="row">
					<div class="col-12 col-lg-8">
						<div class="cart-title mt-50">
							<h2>주문서</h2>
						</div>
						<div class="cart-table clearfix">
							<form action="<%= request.getContextPath()%>/orders/orderProductAction.jsp" method="post">
								<p>이름: <%=customerInfo.get("c.cstm_name") %></p>
								<p>연락처: <%=customerInfo.get("c.cstm_phone") %></p>
								<p>
									 주소: <%=customerInfo.get("c.cstm_address") %>&nbsp;&nbsp;&nbsp;&nbsp;
									<a href="<%= request.getContextPath()%>/customer/addressList.jsp">변경</a>
								</p>
								<p>
									배송시 요청사항
									<select name="deliOption" id="deliOption" onchange="showHideInput()">
										<option value="">선택하세요</option>
										<option value=" 직접 배송해주세요">직접 배송해주세요</option>
										<option value=" 문 앞에 놓아주세요">문 앞에 놓아주세요</option>
										<option value=" 기타">기타</option>
									</select>
									<input type="text" name="otherDeliOption" id="otherDeliOption" style="display: none;">
								</p>
								<!-- 주문상품 -->
								<% 
								int totalPrice = 0;
								int deliPrice = 0;
								for (int i = 0; i < productNo.length; i++) {
									Product product = selectedProducts.get(i);
									ProductImg productImg = selectedProductImgs.get(i);
									int discountedPrice = discountedPrices.get(i);
									totalPrice += discountedPrice * Integer.parseInt(productCnt[i]);
								%>
								<!-- Single Product Area -->
								<div class="single-product-wrapper">
									<!-- Product Image -->
									<div class="product-img">
									<% 
									// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
									if (productImg.getProductSaveFilename() == null) { 
									%>
										<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
									<% 
									} else { 
									%>
										<img src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image">
									<% 
									} 
									%>
									</div>
									<!-- Product Description -->
									<div class="product-description d-flex align-items-center justify-content-between">
										<!-- Product Meta Data -->
										<div class="product-meta-data">
											<div class="line"></div>
												<span class="product-price">
													₩ <%=decimalFormat.format((int)(product.getProductPrice() * Integer.parseInt(productCnt[i]))) %>
												</span>
												<!-- 상품명 -->
												<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo="<%=product.getProductNo() %>">
												<%= product.getProductName() %>
												</a>
												<!-- 상품갯수 -->
												<div class="ratings-cart text-right">
													<div class="ratings d-flex align-items-center">
														<span class="mr-1"><%=productCnt[i] %></span>
														<span>개</span>
													</div>
													<div>
													<!-- 상품 원래 가격 * 상품 개수 -->
									                  <% 
														if (discountedPrice == product.getProductPrice()) { 
									                  %>
									                	  할인된 가격: 0 원
									                  <% 
									                    } else { 
									                  %>
													<!-- 할인된 가격 * 상품 개수 -->
															할인된 가격: <%= decimalFormat.format(discountedPrice * Integer.parseInt(productCnt[i])) %> 원
									                  <% 
									                    } 
									                  %>
													</div>
													<p>배송비:
													<% 
														if (totalPrice >= 25000) { 
													%>
															무료
													<% 
														} else { 
													%>
															3000원
													<% 
															deliPrice += 3000;
														} 
													%>
													</p>
												</div>
											</div>
										</div>
									</div>
								<% 
								} 
								%>
        					</form>
						</div>
    				</div>
 					<div class="col-12 col-lg-4">
<!-- 결제 -->
						<div class="cart-summary">
							<h5>Point</h5>
							<ul class="summary-table">
								<li>
									<span style="font-weight: bold; font-size: larger;">Available Points :</span>
									<span style="font-weight: bold; font-size: larger;"><%=decimalFormat.format(totalPoint) %>P</span>
								</li>
								<li><input type="number" min=0 max=<%=totalPoint %> step="100" name="usePoint" id="point"></li>
								<li><button class="btn amado-btn w-100" type="button" id="pointBtn" onclick="togglePoint()">전액사용</button></li>
								<li>
									<button class="btn amado-btn w-100" type="submit" id="orderButton">
										<span id="paymentAmount">₩ <%=decimalFormat.format(totalPrice) %></span>
									</button>
								</li>
							</ul>
							<% 
							for (int i = 0; i < productNo.length; i += 1) { 
							%>
							<input type="hidden" name="productNo" value="<%= productNo[i] %>">
							<input type="hidden" name="productCnt" value="<%= productCnt[i] %>">
							<% 
							} 
							%>
							<input type="hidden" name="finalPrice" id="finalPriceInput">
							<input type="hidden" name="customerName" value="<%= customerInfo.get("c.cstm_name") %>">
							<input type="hidden" name="customerPhone" value="<%= customerInfo.get("c.cstm_phone") %>">
							<input type="hidden" name="customerAddress" value="<%= customerInfo.get("c.cstm_address") %>">

<!-- 최종 결제 금액 -->
							<div class="cart-summary">
								최종 결제 금액
								<ul class="summary-table">
									<li>
										<span>상품 금액 ₩ </span>
										<span><%= decimalFormat.format(totalPrice) %></span>
									</li>
									<li>
										<span>배송비 : ₩ </span>
										<span><%=decimalFormat.format(deliPrice) %></span>
									</li>
									<li>
										<span>최종 금액 : ₩ </span>
										<span id="finalPrice"></span>
									</li>
								</ul>
							<span><%= customer.getId() %>님 포인트 </span>
							<span id="pointByOrder"></span>점 적립 예정입니다.
						</div>
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
<script>
	
	
//셀렉트 박스 기타 선택시 인풋박스 등장
	function showHideInput() {
		let selectBox = document.querySelector('#deliOption');
		let inputBox = document.querySelector('#otherDeliOption');
		
		if (selectBox.value === " 기타") {
			inputBox.style.display = "inline-block";	
		} else {
			inputBox.style.display = "none";
		}
	}
	
	
	// 포인트 적용시 최종 금액 변동
	let input = document.querySelector('#point'); // 포인트 인풋박스
	let finalPriceElement = document.querySelector('#finalPrice'); // 최종 가격 받아오기
	let pointBtn = document.querySelector('#pointBtn'); // 포인트 버튼
	let orderButton = document.querySelector('#orderButton'); // 결제 버튼
	let maxPoint = <%= totalPoint %>; // 포인트
	let deliPrice = <%= deliPrice %>; // 배송비
	let totalPrice = <%= totalPrice %> ; // 상품 총액

	document.querySelector('#finalPriceInput').value = totalPrice; // 기본값으로 상품 총액 세팅

	// input 값이 변경될 때마다 계산 함수를 호출
	input.addEventListener('input', calculateAmount);

	// input 범위 제한 유효성
	input.addEventListener('blur', function() {
	  let value = parseInt(input.value) || 0;

	  // 입력이 허용 범위를 벗어나면 값을 조정
	  if (value < 0) {
	    input.value = 0;
	  } else if (value > maxPoint) {
	    input.value = maxPoint;
	  } else if (value > totalPrice) {
	    input.value = totalPrice;
	  }
	});

	// 포인트 값 다르게 할 때마다
	function togglePoint() {
	  // 입력된 포인트 값을 가져옵니다.
	  let usedPoint = parseInt(input.value);

	  // 전액 사용 버튼을 클릭한 경우
	  if (pointBtn.innerHTML === '전액사용') {
	    if (totalPrice < maxPoint) {
	      input.value = totalPrice;
	    } else {
	      input.value = maxPoint;
	    }
	    input.setAttribute('readonly', 'readonly'); // 입력 상자를 읽기 전용으로 설정
	    pointBtn.innerHTML = '취소'; // 버튼 텍스트를 '취소'로 변경
	    calculateAmount(); // 포인트 사용에 따른 최종 결제 금액을 계산
	    calculatePointByOrder(); // 포인트도 계산
	  }
	  // 취소 버튼을 클릭한 경우
	  else {
	    input.value = ''; // 입력 상자를 비웁니다.
	    input.removeAttribute('readonly'); // 입력 상자의 읽기 전용 속성을 제거
	    pointBtn.innerHTML = '전액사용'; // 버튼 텍스트를 '전액 사용'으로 변경
	    calculateAmount(); // 포인트 사용에 따른 최종 결제 금액을 계산
	    calculatePointByOrder(); // 포인트도 계산
	  }
	}

	// 최종 금액 계산
	function calculateAmount() {
	  // 입력된 포인트 값을 가져오기
	  let usedPoint = parseInt(input.value);
	  
	  // 포인트 값이 NaN이면 0으로 설정
	  if (isNaN(usedPoint)) {
	    usedPoint = 0;
	  }

	  // 입력이 허용 범위를 벗어나면 값을 조정
	  if (usedPoint < 0) {
	    usedPoint = 0;
	    input.value = 0;
	    alert('잘못된 입력입니다.');
	  } else if (usedPoint > totalPrice || usedPoint > maxPoint) {
	    if (totalPrice < maxPoint) {
	      usedPoint = totalPrice;
	      input.value = totalPrice;
	      alert('최대 사용 가능 포인트는 ' + totalPrice + '입니다.');
	    } else {
	      usedPoint = maxPoint;
	      input.value = maxPoint;
	      alert('최대 사용 가능 포인트는 ' + maxPoint + '입니다.');
	    }
	  }

	  // 최종 결제 금액을 계산
	  let calculatedPrice = totalPrice - usedPoint;

	  // 배송비를 최종 결제 금액에 추가
	  let finalPrice = calculatedPrice + deliPrice;

	  // 음수 금액은 0으로 제한
	  finalPrice = Math.max(finalPrice, 0);

	  // 최종 결제 금액을 화면에 표시
	  finalPriceElement.innerHTML = finalPrice.toLocaleString();

	  // 최종 결제 금액을 숨겨진 input 태그에 설정
	  document.querySelector('#finalPriceInput').value = finalPrice;

	  // 결제 버튼의 텍스트에 최종 결제 금액을 추가
	  document.querySelector('#paymentAmount').innerHTML = finalPrice.toLocaleString();

	  // 포인트에 따른 적립 예정 포인트도 계산
	  calculatePointByOrder();
	}

	// 주문에 따른 포인트 계산
	function calculatePointByOrder() {
	  // id 값 가져와서 JS 변수로 변경
	  let finalPriceElement = document.querySelector('#finalPrice');
	  let pointByOrderElement = document.querySelector('#pointByOrder');
	  let pointRate = <%= pointRate %>;

	  let finalPriceText = finalPriceElement.innerHTML.replace(/,/g, ''); // 쉼표(,) 제거
	  let finalPrice = parseFloat(finalPriceText);

	  // 최종 결제 금액이 NaN이면 0으로 설정
	  if (isNaN(finalPrice)) {
	    finalPrice = 0;
	  }

	  let pointByOrder = Math.floor(pointRate * finalPrice);

	  pointByOrderElement.innerHTML = pointByOrder.toLocaleString();
	}

	// 최종 결제 금액이 변경될 때마다 적립 예정 포인트를 계산
	input.addEventListener('change', calculateAmount);
	input.addEventListener('mouseup', calculateAmount);


</script>
</html>