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
	
	// 2. 모델값
	ProductDao dao = new ProductDao();
	OrderProductDao dao2 = new OrderProductDao();
	// 2-1. 상품 상세 (이미지 + 상품 정보)
	HashMap<String, Object> productMap = dao.selectProductAndImgOne(productNo);
	Product product = (Product)productMap.get("product");
	ProductImg productImg = (ProductImg)productMap.get("productImg");
	Discount discount = (Discount)productMap.get("discount");
	int discountedPrice = dao2.discountedPrice(productNo);
	
	// 2-2. 해당 상품의 리뷰
	
	// 2-3. 해당 상품의 문의
	// 페이징
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
	// 문의 리스트
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
	.strike-through {
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
</script> 
</head>
<body>
	<h1><%=productNo%>번 상품의 상세 정보</h1>
	<!-- 상품 카테고리 -->
	<form action="<%=request.getContextPath()%>/cart/cartList.jsp" method="post">
	<!-- 장바구니 경로 -->
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
								<p class="strike-through">
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
			<!-- 포인트 적립 고지 -->
			<tr> <!-- 상품 상태, 상품 재고량 -->
				<td></td>
			</tr>
			<tr><!-- (수량에 따른) 결제금액 -->
				<td></td>
			</tr>
			<tr> <!-- 결제 / 장바구니 버튼 -->
				<td>
					<button type="submit">장바구니</button>
					<button type="submit" onclick='return submit2(this.form);'>결제하기</button>
				</td>
			</tr>
		</table>
	</form>
	<div> <!-- 상품설명 -->
		<%=product.getProductInfo()%>
	</div>
	<h1><%=productNo%>번 상품의 리뷰 출력 예정</h1>
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
	<!-- 페이지 출력부 출력예정 -->
</body>
</html>