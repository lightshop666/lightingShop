<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1. 유효성 검사
	// productNo
	/*
	if(request.getParameter("productNo") == null
			|| request.getParameter("productNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	*/
	int productNo = 4; // 테스트용
	// currentPage, rowPerPage
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	// searchWord
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	
	// 2. 모델값
	ProductDao dao = new ProductDao();
	OrderProductDao dao2 = new OrderProductDao();
	// 페이징 // 작업중 : 리뷰와 문의 페이징 분리!
	int beginRow = (currentPage - 1) * rowPerPage;
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	int totalRow = dao.selectProductQuestionCnt(productNo);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
		
	// 2-1. 상품 상세
	// 상품 이미지, 상품 정보, 할인 정보
	HashMap<String, Object> productMap = dao.selectProductAndImgOne(productNo);
	Product product = (Product)productMap.get("product");
	ProductImg productImg = (ProductImg)productMap.get("productImg");
	Discount discount = (Discount)productMap.get("discount");
	// 해당 상품의 할인율이 적용된 최종 가격
	int discountedPrice = dao2.discountedPrice(productNo);
	
	// 2-2. 해당 상품의 리뷰
	ArrayList<HashMap<String, Object>> reviewList = dao.selectProductReviewList(beginRow, rowPerPage, searchWord, productNo);
	
	// 2-3. 해당 상품의 문의
	ArrayList<Question> questionList = dao.selectProductQuestionListByPage(beginRow, rowPerPage, productNo);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ProductOne</title>
<style>
	div {
		display:table;
		float:left;
	}
	p {
		display:table-cell;
	}
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
<script> 
	// 단일구매 경로
	function submit2(frm) { 
	   frm.action='request.getContextPath() + "/orders/orderProduct.jsp'; 
	   frm.submit(); 
	   return true; 
	 } 
	
	// 상품 수량 증가감소
	function count(type)  {
	  // 결과를 표시할 element
	  const resultElement = document.getElementById('result');
	  
	  // 현재 화면에 표시된 값
	  let number = resultElement.innerText;
	  
	  // 더하기/빼기
	  if(type === 'plus') {
	    number = parseInt(number) + 1;
	  }else if(type === 'minus')  {
	    number = parseInt(number) - 1;
	  }
	  
	  // 결과 출력
	  resultElement.innerText = number;
	}
	
	/* 구현예정
		// 수량에 따른 총 결제금액 계산
		function totalPrice() {
			
		}
	*/
</script> 
</head>
<body>
	<!------------- 1) 상품 상세 --------------->
	<h1><%=productNo%>번 상품의 상세 정보</h1>
	<!-- 상품 카테고리 -->
	> 카테고리 > 조명 > <%=product.getCategoryName()%>
	<form action="<%=request.getContextPath()%>/cart/cartList.jsp" method="post">
	<input type="hidden" name="productNo" value="<%=product.getProductNo()%>">
		<table>
			<tr> <!-- 상품 이미지, 상품 이름 -->
				<td rowspan="5">
					<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>">
				</td>
				<td>
					<%=product.getProductName()%>
				</td>
			</tr>
			<tr> <!-- 상품 가격 + 할인율 -> 우정님DAO 사용 -->
				<td>
					<%
						if(product.getProductPrice() == discountedPrice) {
					%>
							<p class="font-bold">
								<%=(int)product.getProductPrice()%>
							</p>
					<%
						} else {
					%>
							<div>
								<p class="font-bold">
									<%=discountedPrice%>원
								</p>
								<p class="line-through">
									<%=(int)product.getProductPrice()%>원
								</p>
								<p class="font-bold font-orange">
									<%=discount.getDiscountRate() * 100%>%
								</p>
							</div>
					<%
						}
					%>
				</td>
			</tr>
			<!-- 포인트 적립 고지 문구 출력예정 -->
			<tr> <!-- 상품 상태, 상품 재고량 -->
				<td>
					[<%=product.getProductStatus()%>] 재고 : <%=product.getProductStock()%>개
				</td>
			</tr>
			<tr><!-- 수량, 수량에 따른 총 결제금액 표시 -->
				<td>
					수량 :
					<input type='button'
					       onclick='count("plus")'
					       value='+'/>
					<span id='result'>0</span>
					<input type='button'
					       onclick='count("minus")'
					       value='-'/>
					<input type="hidden" name="productCnt">
					<br> 총 결제 금액 : <!-- 구현 예정, 자바스크립트 -->
				</td>
			</tr>
			<tr> <!-- 결제 / 장바구니 버튼 -->
				<td>
					<button type="submit">장바구니</button>
					<button type="submit" onclick='return submit2(this.form);'>결제하기</button>
				</td>
			</tr>
		</table>
	</form>
	<span> <!-- 상품설명 -->
		<%=product.getProductInfo()%>
	</span>
	
	<!------------- 2) 해당 상품의 리뷰 --------------->
	<h1>리뷰 목록</h1>
	<!-- 작업예정 : 리뷰 리스트 출력 + 검색 form -->
	
	
	<!------------- 3) 해당 상품의 문의 --------------->
	<h1>문의 목록</h1>
	총 <%=totalRow %>건
	<!-- 해당 제품의 문의글 작성, productNo 값 넘기기 -->
	<a href="<%=request.getContextPath()%>/board/addQuestion.jsp?productNo=<%=productNo%>">
		문의하기
	</a>
	<table>
		<tr>
			<th>문의유형</th>
			<th>작성자</th>
			<th>제목</th>
			<th>문의날짜</th>
			<th>문의상태</th>
		</tr>
		<%
			for(Question q : questionList) {
		%>
				<tr>
					<td>[<%=q.getqCategory()%>]</td>
					<td><%=q.getqName()%></td>
					<td>
						<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
							<%=q.getqTitle()%>
							<%
								if(q.getPrivateChk().equals("Y")) {
							%>
									(잠긴 자물쇠 아이콘)
							<%
								} else {
							%>
									(열린 자물쇠 아이콘)
							<%
								}
							%>
						</a>
					</td>
					<td><%=q.getCreatedate().substring(0,10)%></td>
					<td>
						<%
							if(q.getaChk().equals("Y")) {
						%>	
								답변완료
						<%
							} else {
						%>		
								답변대기	
						<%
							}
						%>
					</td>
				</tr>
		<%
			}
		%>
	</table>
	<%
		if(totalRow == 0) {
	%>
			문의글이 없습니다
	<%
		}
	%>
	<!-- 페이지 출력부 출력예정 -->
</body>
</html>