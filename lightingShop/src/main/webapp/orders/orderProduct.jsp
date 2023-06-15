<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");	
//유효성 검사
	//세션 유효성 검사 --> 비회원은 주문할 수 없다 게스트 걸러내기
	Customer customer = new Customer();
	customer.setId("test2");	//-------------------------임시 테스트용-------------------------------------//
	if(session.getAttribute("loginMemberId") != null) {
		customer.setId((String)session.getAttribute("loginMemberId"));
	}
	
	//상품번호,수량 검사
	String[] productNo = {"10"};
	if(request.getParameter("productNo") != null) {
		productNo = request.getParameterValues("productNo");
	}
	
	String[] productCnt = {"2"};
	if(request.getParameter("productCnt") != null) {
		productCnt = request.getParameterValues("productCnt");
	}
	
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
			response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
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
				response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + product.getProductNo());
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
	
	int totalPoint = customerDao.selectPointCustomer(customer.getId());
	
	// 포인트 차등 적립을 위한 고객 정보
	double pointRate = 0;
	if (customerInfo.containsKey("c.cstm_rank")) {
		String rank = (String) customerInfo.get("c.cstm_rank");
		if (rank.equals("금")) {
			System.out.println("고객 랭크 : 금 <--orderProduct.jsp");
		    pointRate = 0.05; // 랭크 금이면 5퍼
		} else if (rank.equals("은")) {
			System.out.println("고객 랭크 : 은 <--orderProduct.jsp");
		    pointRate = 0.03; // 랭크 은이면 3퍼
		} else {
			System.out.println("고객 랭크 : 그 외<--orderProduct.jsp");
		    pointRate = 0.01; // 그 외 1퍼
		}
	} else {
	    System.out.println("고객 랭크가 없습니다 <--orderProduct.jsp");
	    //-----------------------------------------------------------------------어디로 보낼지 고민--//
		//response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + request.getParameterValues("productNo[0]"));
	}

	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문하기</title>
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
    background: rgba(0, 0, 0, 0.7);
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
 	<form action="<%= request.getContextPath()%>/orders/orderProductAction.jsp" method="post">
	<div>
		<p>이름 : <%=customerInfo.get("c.cstm_name") %></p>
		<p>연락처 : <%=customerInfo.get("c.cstm_phone") %></p>
		<p>
			주소 : <%=customerInfo.get("c.cstm_address") %>			
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

	</div>

<!------------------------ 주문상품 -->
	<div>
		<h4>주문상품</h4>
	<%
	    int totalPrice = 0;
		int deliPrice = 0;
	    for (int i = 0; i < productNo.length; i++) {
	        Product product = selectedProducts.get(i);
	        ProductImg productImg = selectedProductImgs.get(i);
	        int discountedPrice = discountedPrices.get(i);
	        totalPrice += discountedPrice *  Integer.parseInt(productCnt[i]);
	%>
	        <p><img class="thumbnail" src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image"></p>
	        <p><!-- 상품명 -->
	        	<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo="<%=product.getProductNo() %>>
	        		상품명 : <%= product.getProductName() %>
	        	</a>
	        </p>
	        <p><%=productCnt[i] %>개</p><!-- 상품갯수 -->
	        <p>상품 가격 : <%= product.getProductPrice() * Integer.parseInt(productCnt[i])  %></p><!-- 상품 원래 가격 * 상품 개수 -->
	        <p>할인된 가격 : <%= discountedPrice * Integer.parseInt(productCnt[i]) %></p><!-- 할인된 가격 * 상품 개수 -->
			<p>배송비 :
			<%
				if(totalPrice >= 25000){
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
			<hr>
			</p>
	<%
	    }
	%>

	</div>
	
<!---------------- 결제
	결제 방법(어떻게할지 고민)
	o 3-1) 상품 총액 
	o 3-2) 포인트 적용 여부(JS로 가능하면)  
	o 3-3)전액 사용+항상 전액 사용 버튼(JS로 가능하면) 
	o 3-4)결제금액- : 상품금액 / 
	o 3-5)배송비(상품금액 일정 이상이면 배송비 0원으로) / 
	o 3-6)총 결제 금액 / 
	o 3-7) 결제 방법 무통장입금 방식 --> 
	<div>
		<p>사용 가능 : <%=totalPoint %> P</p>
		<p>
			<input type="number" min=0 max=<%=totalPoint %> step="100" name="usePoint" id="point">
			<button type="button" id="pointBtn" onclick="togglePoint()">전액사용</button>
		</p>
	</div>
	
<!---------------- 최종 결제 금액 -->
	<div>
		<h4>결제 금액</h4>
		<p>상품 금액 : <%= totalPrice %> 원</p>
		<p>배송비 : <%=deliPrice %> 원</p>
		<p>최종 결제 금액 : <span id="finalPrice"> </span></p>
	</div>
	
<!---------------- 적립예정 포인트 -->
	<div>	
		<p>
			<%= customer.getId() %>님 포인트 <span id="pointByOrder"></span>점 적립 예정입니다.
		</p>
	</div>

<!-------- 결제 버튼  넘겨줄 것 : productNo배열, productCnt배열, 최종금액 -->
	<% 
		for(int i=0; i<productNo.length; i+=1) { 
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
		
		<button type="submit" id="orderButton">
			<span id="paymentAmount"><%=totalPrice %>원</span>결제
		</button>
	</form>


</div>
</body>
<script>
// 이미지 클릭 시 확대/축소
	document.querySelector('.thumbnail').addEventListener('click', function() {
		let img = document.createElement('img');
		img.src = this.src;
		img.classList.add('fullscreen');
		img.addEventListener('click', function() {
			document.body.removeChild(this);
		});
		document.body.appendChild(img);
	});
	
	
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


		
	
	
	
//포인트 적용시 최종 금액 변동
	let input = document.querySelector('#point');							//포인트 인풋박스
	let finalPriceElement = document.querySelector('#finalPrice');	//최종 가격 받아오기
	let pointBtn = document.querySelector('#pointBtn');					//포인트 버튼
	let orderButton = document.querySelector('#orderButton');		//결제 버튼
	let maxPoint = <%= totalPoint %>;					//포인트
	let deliPrice = <%= deliPrice %>;						// 배송비
	let totalPrice = <%= totalPrice %> ; 					// 상품 총액

	document.getElementById('finalPriceInput').value = totalPrice;	//기본값으로 상품 총액 세팅
	
	// input 값이 변경될 때마다 계산 함수를 호출
	input.addEventListener('blur', calculateAmount);
	
	// input 범위 제한 유효성
	input.addEventListener('blur', function() {
	  let value = parseInt(input.value) || 0;
	  
		// 입력이 허용 범위를 벗어나면 값을 조정
		if (value < 0) {
			input.value = 0;
		} else if (value > maxPoint) {
			input.value = maxPoint;
		} else if (value > totalPrice){
			input.value = totalPrice;
		}
	});

		
//포인트 값 다르게 할 때마다 
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
		// 취소 버튼을 클릭한 경우
		} else {
			input.value = ''; // 입력 상자를 비웁니다.
			input.removeAttribute('readonly'); // 입력 상자의 읽기 전용 속성을 제거
			pointBtn.innerHTML = '전액사용'; // 버튼 텍스트를 '전액 사용'으로 변경
			finalPriceElement.innerHTML = totalPrice +'원'; // 최종 결제 금액을 초기화합니다.
			document.getElementById('paymentAmount').innerHTML = totalPrice + deliPrice  + '원 '; // 결제 도 초기화합니다.
		}
	}
	
		// 최종 금액 계산
	function calculateAmount() {
	// 입력된 포인트 값을 가져오기
	let usedPoint = parseInt(input.value);
	
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
	  finalPriceElement.innerHTML = finalPrice;
	  // 최종 결제 금액을 숨겨진 input 태그에 설정
	  document.getElementById('finalPriceInput').value = finalPrice;

	  // 결제 버튼의 텍스트에 최종 결제 금액을 추가
	  document.getElementById('paymentAmount').innerHTML = finalPrice.toLocaleString() +'원';
	}


//주문에 따른 포인트
	function calculatePointByOrder() {
		let finalPriceElement = document.querySelector('#finalPrice');
		let pointByOrderElement = document.querySelector('#pointByOrder');
		
		let finalPrice = parseFloat(finalPriceElement.innerHTML);
		let pointByOrder = Math.floor(pointRate * finalPrice);
		
		pointByOrderElement.innerHTML = pointByOrder;
	}
	// 최종 결제 금액이 변경될 때마다 적립 예정 포인트를 계산
	input.addEventListener('change', calculatePointByOrder);


</script>
</html>