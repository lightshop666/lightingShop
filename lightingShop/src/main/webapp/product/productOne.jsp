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
	int productNo = 33; // 테스트용
	
	// reviewCurrentPage, reviewRowPerPage
	int reviewCurrentPage = 1;
	if(request.getParameter("reviewCurrentPage") != null) {
		reviewCurrentPage = Integer.parseInt(request.getParameter("reviewCurrentPage"));
	}
	int reviewRowPerPage = 10;
	if(request.getParameter("reviewRowPerPage") != null) {
		reviewRowPerPage = Integer.parseInt(request.getParameter("reviewRowPerPage"));
	}
	// questionCurrentPage, questionRowPerPage
	int questionCurrentPage = 1;
	if(request.getParameter("questionCurrentPage") != null) {
		questionCurrentPage = Integer.parseInt(request.getParameter("questionCurrentPage"));
	}
	int questionRowPerPage = 10;
	if(request.getParameter("questionRowPerPage") != null) {
		questionRowPerPage = Integer.parseInt(request.getParameter("questionRowPerPage"));
	}
	
	// searchWord
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	
	// 2. 모델값
	ProductDao dao = new ProductDao();
	OrderProductDao dao2 = new OrderProductDao();
	
	// 리뷰 목록 페이징
	int reviewBeginRow = (reviewCurrentPage - 1) * reviewRowPerPage;
	int reviewPagePerPage = 5;
	int reviewBeginPage = (((reviewCurrentPage - 1) / reviewPagePerPage) * reviewPagePerPage) + 1;
	int reviewEndPage = reviewBeginPage + (reviewPagePerPage - 1);
	int reviewTotalRow = dao.selectProductReviewCnt(searchWord, productNo); // 해당 상품의 리뷰 수
	int reviewLastPage = reviewTotalRow / reviewRowPerPage;
	if(reviewTotalRow % reviewRowPerPage != 0) {
		reviewLastPage = reviewLastPage + 1;
	}
	if(reviewEndPage > reviewLastPage) {
		reviewEndPage = reviewLastPage;
	}
	// 문의 목록 페이징
	int questionBeginRow = (questionCurrentPage - 1) * questionRowPerPage;
	int questionPagePerPage = 5;
	int questionBeginPage = (((questionCurrentPage - 1) / questionPagePerPage) * questionPagePerPage) + 1;
	int questionEndPage = questionBeginPage + (questionPagePerPage - 1);
	int questionTotalRow = dao.selectProductQuestionCnt(productNo); // 해당 상품의 문의 수
	int questionLastPage = questionTotalRow / questionRowPerPage;
	if(questionTotalRow % questionRowPerPage != 0) {
		questionLastPage = questionLastPage + 1;
	}
	if(questionEndPage > questionLastPage) {
		questionEndPage = questionLastPage;
	}
	
	// 2-1. 상품 상세
	// 상품 이미지, 상품 정보, 할인 정보
	HashMap<String, Object> productMap = dao.selectProductAndImgOne(productNo);
	Product product = (Product)productMap.get("product");
	ProductImg productImg = (ProductImg)productMap.get("productImg");
	Discount discount = (Discount)productMap.get("discount");
	// 해당 상품의 할인율이 적용된 최종 가격
	int discountedPrice = (int)product.getProductPrice();
	if(discount.getDiscountStart() != null) { // 할인이 적용되어있으면
		discountedPrice = dao2.discountedPrice(productNo); // 할인가로 바꾸기	
	}
	
	// 2-2. 해당 상품의 리뷰
	ArrayList<HashMap<String, Object>> reviewList = dao.selectProductReviewList(reviewBeginRow, reviewRowPerPage, searchWord, productNo);
	
	// 2-3. 해당 상품의 문의
	ArrayList<Question> questionList = dao.selectProductQuestionListByPage(questionBeginRow, questionRowPerPage, productNo);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>productOne</title>
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
	.tab-container {
      clear: both;
      padding-top: 20px;
    }

    .tab-menu {
      display: inline-block;
      margin-right: 10px;
      cursor: pointer;
    }

    .tab-content {
      display: none;
      padding-top: 10px;
    }
</style>
<script> 
	// 단일구매 경로
	function submit2(frm) { 
	   frm.action='<%=request.getContextPath()%>/orders/orderProduct.jsp'; 
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
	
	// 리뷰,문의 tab 메뉴
	 function showTab(tabId) {
      // 모든 탭 컨텐츠 숨기기
      const tabContents = document.getElementsByClassName('tab-content');
      for (let i = 0; i < tabContents.length; i++) {
        tabContents[i].style.display = 'none';
      }

      // 모든 탭 메뉴에서 active 클래스 제거
      const tabMenus = document.getElementsByClassName('tab-menu');
      for (let i = 0; i < tabMenus.length; i++) {
        tabMenus[i].classList.remove('active');
      }

      // 선택한 탭 컨텐츠 표시 및 해당하는 메뉴에 active 클래스 추가
      document.getElementById(tabId).style.display = 'block';
      document.getElementById('menu-' + tabId).classList.add('active');
    }
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
					<%
						// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
						if(productImg.getProductSaveFilename() == null) {
					%>
							<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
					<%
						} else {
					%>
							<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>">
					<%	
						}
					%>
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
								<%=(int)product.getProductPrice()%>원
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
			<!-- 등급별 포인트 적립 고지 문구 출력예정 -->
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
					<br> 총 결제 금액 : <!-- 구현 예정 -->
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
	<!-- tab 메뉴바 표시 -->
	<div class="tab-container">
    	<div id="menu-review" class="tab-menu active" onclick="showTab('review')">리뷰 목록</div>
    	<div id="menu-question" class="tab-menu" onclick="showTab('question')">문의 목록</div>
	</div>
	
	<!------------- 2) 해당 상품의 리뷰 --------------->
	<div id="review" class="tab-content" style="display: block;">
		<h1>리뷰 목록</h1>
		<span>총 <%=reviewTotalRow%>건</span>
		<span>
			<form action="<%=request.getContextPath()%>/product/productOne.jsp" method="post">
				리뷰 키워드 : <input type="text" name="searchWord">
				<button type="submit">검색</button>
			</form>
		</span>
		<span><br>이미지 모아보기<br></span>
		<%	
			// 자바스크립트) 슬라이드 구현 예정 // 이미지 클릭시 해당 리뷰 상세페이지 새창열림
			for(HashMap<String, Object> m : reviewList) {
		%>
				<img src="<%=request.getContextPath()%>/<%=m.get("reviewPath")%>/<%=m.get("reviewSaveFilename")%>">
		<%
			}
		%>
		<table>
			<%
				for(HashMap<String, Object> m : reviewList) {
			%>
				<tr>
					<td><!-- 리뷰제목 -->
						<%=m.get("reviewTitle")%> <br>
						<!-- 리뷰내용 -->
						<%=m.get("reviewContent")%> <br>
						<!-- 리뷰사진 -->
						<img src="<%=request.getContextPath()%>/<%=m.get("reviewPath")%>/<%=m.get("reviewSaveFilename")%>">
					</td>
					<td>
						<!-- 수정일자 -->
						<%=m.get("reviewCreatedate") %>
						<!-- 작성자 -->
						<%=m.get("id")%>
					</td>
				</tr>
			<%
				}
			%>
		</table>
		<%
			if(reviewTotalRow == 0) {
		%>
				리뷰가 아직 없습니다
		<%
			}
		%>
		<!-- 페이지 출력부 -->
		<%
			// 이전은 1페이지에서는 출력되면 안 된다
			if(reviewBeginPage != 1) {
		%>
				<a href="<%=request.getContextPath()%>/product/productList.jsp?reviewCurrentPage=<%=reviewBeginPage - 1%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>">
					&laquo;
				</a>
		<%
			}
		
			for(int i = reviewBeginPage; i <= reviewEndPage; i++) {
				if(i == reviewCurrentPage) { // 현재페이지에서는 a태그 없이 출력
		%>
					<span><%=i%></span>&nbsp;
		<%
				} else {
		%>
					<a href="<%=request.getContextPath()%>/product/productList.jsp?reviewCurrentPage=<%=i%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>">
						<%=i%>
					</a>&nbsp;
		<%
				}
			}
			// 다음은 마지막 페이지에서는 출력되면 안 된다
			if(reviewEndPage != reviewLastPage) {
		%>
				<a href="<%=request.getContextPath()%>/product/productList.jsp?reviewCurrentPage=<%=reviewEndPage + 1%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>">
					&raquo;
				</a>
		<%
			}
		%>
	</div>
	
	<!------------- 3) 해당 상품의 문의 --------------->
	<div div id="question" class="tab-content">
		<h1>문의 목록</h1>
		총 <%=questionTotalRow %>건
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
			if(questionTotalRow == 0) {
		%>
				문의글이 없습니다
		<%
			}
		%>
		<!-- 페이지 출력부 -->
		<%
			// 이전은 1페이지에서는 출력되면 안 된다
			if(questionBeginPage != 1) {
		%>
				<a href="<%=request.getContextPath()%>/product/productList.jsp?questionCurrentPage=<%=questionBeginPage - 1%>&questionRowPerPage=<%=questionRowPerPage%>">
					&laquo;
				</a>
		<%
			}
		
			for(int i = questionBeginPage; i <= questionEndPage; i++) {
				if(i == questionCurrentPage) { // 현재페이지에서는 a태그 없이 출력
		%>
					<span><%=i%></span>&nbsp;
		<%
				} else {
		%>
					<a href="<%=request.getContextPath()%>/product/productList.jsp?questionCurrentPage=<%=i%>&questionRowPerPage=<%=questionRowPerPage%>">
						<%=i%>
					</a>&nbsp;
		<%
				}
			}
			// 다음은 마지막 페이지에서는 출력되면 안 된다
			if(questionEndPage != questionLastPage) {
		%>
				<a href="<%=request.getContextPath()%>/product/productList.jsp?questionCurrentPage=<%=questionEndPage + 1%>&questionRowPerPage=<%=questionRowPerPage%>">
					&raquo;
				</a>
		<%
			}
		%>
	</div>
</body>
<script>
    showTab('review'); // 기본적으로 리뷰 탭 컨텐츠 표시
</script>
</html>