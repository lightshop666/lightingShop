<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.text.DecimalFormat" %> <!-- 가격에 쉼표 표시 -->
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 유효성 검사
	// productNo
	if(request.getParameter("productNo") == null
			|| request.getParameter("productNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	
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
	
	// 로그인 상태이면 아이디, 회원등급 저장
	String loginId = "";
	String loginRank = "";
	if(session.getAttribute("loginIdListId") != null) {
		loginId = (String)session.getAttribute("loginIdListId");
		loginRank = (String)session.getAttribute("loginIdListRank");
	}
	
	// msg 값이 있으면 받아오기
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	System.out.println(msg);
	
	// 2. 모델값
	ProductDao dao = new ProductDao();
	OrderProductDao dao2 = new OrderProductDao();
	
	// 2-1. 페이징
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
	
	// 2-2. 상품 상세
	// 숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
	
	// 상품 이미지, 상품 정보, 할인 정보
	HashMap<String, Object> productMap = dao.selectProductAndImgOne(productNo);
	Product product = (Product)productMap.get("product");
	ProductImg productImg = (ProductImg)productMap.get("productImg");
	Discount discount = (Discount)productMap.get("discount");
	// 해당 상품의 할인율이 적용된 최종 가격
	int discountedPrice = dao2.discountedPrice(productNo);
	
	// 2-3. 해당 상품의 리뷰
	ArrayList<HashMap<String, Object>> reviewList = dao.selectProductReviewList(reviewBeginRow, reviewRowPerPage, searchWord, productNo);
	
	// 2-4. 해당 상품의 문의
	ArrayList<Question> questionList = dao.selectProductQuestionListByPage(questionBeginRow, questionRowPerPage, productNo);
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
   
   <!-- Title  -->
   <title>조명 가게 | 상품 상세</title>
   
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
	
   <!-- BootStrap5 -->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
   
   <!-- Favicon  -->
   <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
   
   <!-- Core Style CSS -->
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
<script> 
	// msg 띄우기
	function showMessage() {
		let msg = '<%=msg%>';
		if(msg !== "") {
			alert(msg);
		}
	}
	// 페이지 로드시 showMessage 함수를 호출
	window.addEventListener('DOMContentLoaded', showMessage);
	
	// 선택한 상품 수량에 따라 총 금액 계산
	function count(type) {
		// 수량 동적으로 변경
		let quantityElement = document.getElementById('quantity'); // 수량Element 가져오기
		let quantity = parseInt(quantityElement.value); // 수량의 값 가져오기
		let maxQuantity = <%=product.getProductStock()%>; // 상품의 최대 수량(재고량) 가져오기
		
		if (type === 'plus') { // '+' 버튼을 클릭한 경우
		  if (quantity < maxQuantity) { // 현재 수량이 재고량보다 작을 경우에만
		    quantity += 1; // 수량 1 증가
		  }
		} else if (type === 'minus') { // '-' 버튼을 클릭한 경우
		  if (quantity >= 1) { // 현재 수량이 1보다 큰 경우에만
		    quantity -= 1; // 수량을 1 감소
		  }
		}
		
		quantityElement.value = quantity; // 변경된 수량 출력
		
		// 동적으로 바뀌는 quantity 값을 hidden input에 설정
		let hiddenInput = document.getElementsByName('productCnt')[0];
		hiddenInput.value = quantity;
		
		// 총 결제 금액 계산
		let totalElement = document.querySelector('#totalAmount'); // 총 가격Element 가져오기
		let price = <%=discountedPrice%>; // 할인율이 반영된 최종가격
		let totalAmount = price * quantity; // 총 결제 금액
		totalElement.innerHTML = totalAmount.toLocaleString(); // 변경된 총 결제 금액 출력
	}
	
	// 단일구매시 경로 및 수량 검사
	function submit2(frm) {
		let productCnt = document.getElementsByName('productCnt')[0].value;
		if(productCnt == "" || productCnt == 0) {
			alert('수량을 선택해주세요');
			return false;
		}
		frm.action='<%=request.getContextPath()%>/orders/orderProduct.jsp'; 
		frm.submit(); 
		return true; 
	 } 
	
	// 장바구니 선택 시 수량 검사
	function submit1(frm) {
		let productCnt = document.getElementsByName('productCnt')[0].value;
		if(productCnt == "" || productCnt == 0) {
			alert('수량을 선택해주세요');
			return false;
		}
		return true;
	}
	
	
	// 리뷰,문의 tab 메뉴
	function showTab(tabId) {
		// 모든 탭 컨텐츠 숨기기
		let tabContents = document.getElementsByClassName('tab-content');
		for (let i = 0; i < tabContents.length; i++) {
			tabContents[i].style.display = 'none';
		}
		
		// 모든 탭 메뉴에서 active 클래스 제거
		let tabMenus = document.getElementsByClassName('tab-menu');
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
	<!-- Search Wrapper Area Start -->
	<div class="search-wrapper section-padding-100">
	   <div class="search-close">
	      <i class="fa fa-close" aria-hidden="true"></i>
	   </div>
	   <div class="container">
	      <div class="row">
	         <div class="col-12">
	            <div class="search-content">
	               <form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
	                  <input type="search" name="searchWord" id="search" placeholder="키워드를 입력하세요">
	                  <button type="submit"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""></button>
	               </form>
	            </div>
	         </div>
	      </div>
	   </div>
	</div>

   <!-- ##### Main Content Wrapper Start ##### -->
	<div class="main-content-wrapper d-flex clearfix">
       <!-- menu 좌측 bar -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>

        <!-- Product Details Area Start -->
        <div class="single-product-area section-padding-100 clearfix">
            <div class="container-fluid">

                <div class="row">
                    <div class="col-12">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mt-50">
                                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
                                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/product/productList.jsp">Shop</a></li>
                                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/product/productList.jsp?categoryName=<%=product.getCategoryName()%>"><%=product.getCategoryName()%></a></li>
                                <li class="breadcrumb-item active" aria-current="page"><%=product.getProductName()%></li>
                            </ol>
                        </nav>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12 col-lg-7"> <!-- 상품 이미지 -->
                        <div class="single_product_thumb">
                        	<div class="carousel-inner">
								<div class="carousel-item active">
                             		<%
										// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
										if(productImg.getProductSaveFilename() == null) {
									%>
											<a class="gallery_img" href="<%=request.getContextPath()%>/productImg/no_image.jpg">
												<img class="d-block w-100" src="<%=request.getContextPath()%>/productImg/no_image.jpg">
											</a>
									<%
										} else {
									%>
											<a class="gallery_img" href="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>">
												<img class="d-block w-100" src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>">
											</a>
									<%	
										}
									%>
                                 </div>
                        	</div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-5">
                        <div class="single_product_desc">
                            <!-- Product Meta Data -->
                            <div class="product-meta-data">
                                <div class="line"></div>
                               	<%
									if(product.getProductPrice() == discountedPrice) {
								%>
										<span class="product-price">
											₩<%=decimalFormat.format(discountedPrice)%>
										</span>
								<%
									} else {
								%>
										<div>
											<span class="product-price">
												₩<%=decimalFormat.format(discountedPrice)%>
											</span>
											<span class="line-through">
												₩<%=decimalFormat.format(product.getProductPrice())%>
											</span>
											<span class="font-bold font-orange">
												<%=discount.getDiscountRate() * 100%>%
											</span>
										</div>
								<%
									}
								%>
                                <h6><%=product.getProductName()%></h6>
                                <!-- Avaiable -->
                                <p class="avaibility"><i class="fa fa-circle"></i> [<%=product.getProductStatus()%>] 재고 : <%=product.getProductStock()%>개</p>
                            </div>

                            <div class="short_overview my-5">
                                <p><%=product.getProductInfo()%></p>
                            </div>
                            
                            <!-- 로그인 유무와 회원 등급에 따른 포인트 적립률 고지 -->
                            <div class="short_overview my-5">
                            	<%
                            		String pointRate = ""; // 포인트 적립률 고지 멘트
                            		String rank = ""; // 회원등급 영어로
                            		if(!loginId.equals("")) { // 로그인 상태에만
                            			switch(loginRank) {
	                            			case "금": // 회원등급이 금
	                            				rank = "GOLD";
	                            				pointRate = "5%";
	                            				break;
	                            			case "은": // 회원등급이 은
	                            				rank = "SILVER";
	                            				pointRate = "3%";
	                            				break;
	                            			case "동": // 회원등급이 동
	                            				rank = "BRONZE";
	                            				pointRate = "1%";
	                            				break;
	                            		}
                            	%>
                            			<p><%=loginId%>님의 등급 : <%=rank%><br>현재 구매시 <%=pointRate%>가 적립됩니다!</p>
                            	<%
                            		}
                            	%>
                            </div>

                            <!-- Add to Cart Form -->
                            <form action="<%=request.getContextPath()%>/cart/cartListAction.jsp" method="post" class="cart clearfix">
							<input type="hidden" name="productNo" value="<%=product.getProductNo()%>">
							<input type="hidden" name="productCnt" value=""> <!-- 동적으로 값 변경 -->
							<input type="hidden" name="discountedPrice" value="<%=discountedPrice%>">
                                <div class="cart-btn d-flex mb-50">
                                    <p>수량</p>
                                    <div class="quantity">
                                        <span class="qty-minus" onclick="count('minus')"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
                                        <input type="number" class="qty-text" id="quantity" step="1" min="0" max="<%=product.getProductStock()%>" name="quantity" value="0">
                                        <span class="qty-plus" onclick="count('plus')"><i class="fa fa-caret-up" aria-hidden="true"></i></span>
                                    </div>
                                </div>
                                <div class="product-meta-data">
	                                <span class="product-price">Total Price ₩<span id="totalAmount">0</span></span>
	                            </div>
                                <button type="submit" class="btn amado-btn" onclick="return submit1(this.form);">Add to cart</button>
								<button type="submit" onclick="return submit2(this.form);" class="btn amado-btn">Checkout</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- tab 메뉴바 표시 -->
		<div class="tab-container nav nav-pills justify-content-center">
	    	<div id="menu-review" class="tab-menu active btn amado-btn" onclick="showTab('review')">Review</div>
	    	<div id="menu-question" class="tab-menu btn amado-btn" onclick="showTab('question')">Question</div>
		</div>
      
		<!------------- 2) 해당 상품의 리뷰 --------------->
		<div id="review" class="tab-content" style="display: block;">
			<div class="product-topbar d-xl-flex align-items-end justify-content-between">
	        <div class="total-products">
	            <p>총 <%=reviewTotalRow%>건</p>
	            <div style="float:right;">
                    <form action="<%=request.getContextPath()%>/product/productOne.jsp" method="post">
	                    <input type="hidden" name="productNo" value="<%=productNo%>">
						<input type="text" name="searchWord" value="<%=searchWord%>" placeholder="키워드를 입력하세요">
						<button type="submit" class="btn btn-warning">Search</button>
				</div>
	        </div>
            <!-- Sorting -->
            <div class="product-sorting d-flex">
                <div class="view-product d-flex align-items-center">
                    <p>View</p>
	                        <select name="reviewRowPerPage" id="viewProduct" onchange="this.form.submit()">
	                        <%
								for (int i = 5; i <= 50; i = i + 5) {
							%>
									<option value="<%=i%>" <%if (reviewRowPerPage == i) {%> selected <%}%>>
										<%=i%>
									</option>
							<%
								}
							%>
	                        </select>
                    	</form>
              		</div>
            	</div>
        	</div>
        	<div class="row">
				<!-- 리뷰 리스트 출력 -->
				<%
					for(HashMap<String, Object> m : reviewList) {
				%>
					<div class="col-12 col-sm-6 col-md-12 col-xl-6">
						<div class="card" style="width: 25rem;">
							<a class="gallery_img" href="<%=request.getContextPath()%>/<%=m.get("reviewPath")%>/<%=m.get("reviewSaveFilename")%>">
								<img src="<%=request.getContextPath()%>/<%=m.get("reviewPath")%>/<%=m.get("reviewSaveFilename")%>" class="card-img-top">
							</a>
						  <div class="card-body">
						    <h5 class="card-title"><%=m.get("reviewTitle")%></h5>
						    <p class="card-text"><%=m.get("reviewContent")%></p>
						  </div>
						  <ul class="list-group list-group-flush">
						    <li class="list-group-item"><%=m.get("id")%></li>
						    <li class="list-group-item card-subtitle mb-2 text-muted"><%=m.get("reviewCreatedate") %></li>
						  </ul>
						</div>
					</div>
				<%
					}
				
					if(reviewTotalRow == 0) {
				%>
						리뷰가 아직 없습니다
				<%
					}
				%>
			</div>
	        <!------------------ 페이지 출력부 ------------------>
            <div class="row">
            	<div class="col-12">
                	<nav aria-label="navigation">
                    	<ul class="pagination justify-content-end mt-50">
				        	<%
								// 이전은 1페이지에서는 출력되면 안 된다
								if(reviewBeginPage != 1) {
							%>
									<li class="page-item">
										<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&reviewCurrentPage=<%=reviewBeginPage - 1%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>" class="page-link">
											&laquo;
										</a>
									</li>
							<%
								}
								
								for(int i = reviewBeginPage; i <= reviewEndPage; i++) {
									if(i == reviewCurrentPage) { // 현재페이지에서는 a태그 링크 없이 출력
							%>
										<li class="page-item active">
											<a href="#" class="page-link">
												<%=i%>
											</a>
										</li>
							<%
									} else {
							%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&reviewCurrentPage=<%=i%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>" class="page-link">
												<%=i%>
											</a>
										</li>
							<%
									}
								}
								// 다음은 마지막 페이지에서는 출력되면 안 된다
								if(reviewEndPage != reviewLastPage) {
							%>
									<li class="page-item">
										<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&reviewCurrentPage=<%=reviewEndPage + 1%>&reviewRowPerPage=<%=reviewRowPerPage%>&searchWord=<%=searchWord%>" class="page-link">
											&raquo;
										</a>
									</li>
							<%
								}
							%>
						</ul>
					</nav>
				</div>
			</div>
		</div>
	
		<!------------- 3) 해당 상품의 문의 --------------->
		<div id="question" class="tab-content">
			<div class="product-topbar d-xl-flex align-items-end justify-content-between">
		        <div class="total-products">
		            <p>총 <%=questionTotalRow%>건</p>
		            <!-- 해당 제품의 문의글 작성, productNo 값 넘기기 -->
					<button type="button" class="btn btn-warning">
						<a href="<%=request.getContextPath()%>/board/addQuestion.jsp?productNo=<%=productNo%>">
							문의하기
						</a>
					</button>
		        </div>
	            <!-- Sorting -->
	            <div class="product-sorting d-flex">
	                <div class="view-product d-flex align-items-center">
	                    <p>View</p>
	                    	<form action="<%=request.getContextPath()%>/product/productOne.jsp" method="post">
	                    	<input type="hidden" name="productNo" value="<%=productNo%>">
		                        <select name="questionRowPerPage" id="viewProduct" onchange="this.form.submit()">
		                        <%
									for (int i = 5; i <= 50; i = i + 5) {
								%>
										<option value="<%=i%>" <%if (questionRowPerPage == i) {%> selected <%}%>>
											<%=i%>
										</option>
								<%
									}
								%>
		                        </select>
	                    	</form>
	              		</div>
	            	</div>
	        	</div>
				<!-- 문의글 리스트 출력 -->
				<table class="table">
					<thead class="table-dark">
						<tr>
							<th>문의유형</th>
							<th>작성자</th>
							<th>제목</th>
							<th>문의날짜</th>
							<th>문의상태</th>
						</tr>
					</thead>
					<tbody>
						<%
							for(Question q : questionList) {
						%>
								<tr>
									<td>[<%=q.getqCategory()%>]</td>
									<td><h6><%=q.getqName()%></h6></td>
									<td>
										<%
											if(q.getPrivateChk().equals("Y")) { // 비공개인 경우
												if(session.getAttribute("loginIdListId") == null
														|| !session.getAttribute("loginIdListId").equals(q.getId())) {
													// 로그인 상태가 아니거나, 현재 로그인 아이디와 작성자 아이디가 일치하지 않으면
													// 비밀번호 입력 페이지로 이동
										%>
													<a href="<%=request.getContextPath()%>/board/inputPassword.jsp?qNo=<%=q.getqNo()%>">
														<%=q.getqTitle()%>
													</a>
													&#x1F512;
										<%
												} else {
													// 작성자 아이디와 현재 로그인 아이디가 일치하면 바로 문의글 상세페이지로 이동
										%>
													<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
														<%=q.getqTitle()%>
													</a>
													&#x1F512;
										<%
												}
											} else { // 비공개가 아닐경우 바로 문의글 상세 페이지로 이동
										%>
												<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
													<%=q.getqTitle()%>
												</a>
										<%
											}
										%>
									</td>
									<td><%=q.getCreatedate().substring(0,10)%></td>
									<td>
										<%
											if(q.getaChk().equals("Y")) {
										%>	
												<h6><span class="badge bg-primary">답변완료</span></h6>
										<%
											} else {
										%>		
												<h6><span class="badge bg-danger">답변대기</span></h6>
										<%
											}
										%>
									</td>
								</tr>
						<%
							}
						%>
					</tbody>
				</table>
				<%
					if(questionTotalRow == 0) {
				%>
						문의글이 없습니다
				<%
					}
				%>
		        <!------------------ 페이지 출력부 ------------------>
	            <div class="row">
	            	<div class="col-12">
	                	<nav aria-label="navigation">
	                    	<ul class="pagination justify-content-end mt-50">
					        	<%
									// 이전은 1페이지에서는 출력되면 안 된다
									if(questionBeginPage != 1) {
								%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&questionCurrentPage=<%=questionBeginPage - 1%>&questionRowPerPage=<%=questionRowPerPage%>" class="page-link">
												&laquo;
											</a>
										</li>
								<%
									}
									
									for(int i = questionBeginPage; i <= questionEndPage; i++) {
										if(i == questionCurrentPage) { // 현재페이지에서는 a태그 링크 없이 출력
								%>
											<li class="page-item active">
												<a href="#" class="page-link">
													<%=i%>
												</a>
											</li>
								<%
										} else {
								%>
											<li class="page-item">
												<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&questionCurrentPage=<%=i%>&questionRowPerPage=<%=questionRowPerPage%>" class="page-link">
													<%=i%>
												</a>
											</li>
								<%
										}
									}
									// 다음은 마지막 페이지에서는 출력되면 안 된다
									if(questionEndPage != questionLastPage) {
								%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>&questionCurrentPage=<%=questionEndPage + 1%>&questionRowPerPage=<%=questionRowPerPage%>" class="page-link">
												&raquo;
											</a>
										</li>
								<%
									}
								%>
							</ul>
						</nav>
					</div>
				</div>
		 </div>
        <!-- Product Details Area End -->
	</div>
</div>
<!-- ##### Main Content Wrapper End ##### -->

<!-- ##### Footer Area Start ##### -->
    <div>
      <jsp:include page="/inc/copyright.jsp"></jsp:include>
   </div>
<!-- ##### Footer Area End ##### -->

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>
</body>
</html>