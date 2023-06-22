<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");	

	// 1. 유효성 검사
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	int searchPrice1 = 0;
	if(request.getParameter("searchPrice1") != null && !request.getParameter("searchPrice1").equals("")) {
		searchPrice1 = Integer.parseInt(request.getParameter("searchPrice1"));
	}
	int searchPrice2 = 0;
	if(request.getParameter("searchPrice2") != null && !request.getParameter("searchPrice2").equals("")) {
		searchPrice2 = Integer.parseInt(request.getParameter("searchPrice2"));
	}
	String orderBy = "";
	if(request.getParameter("orderBy") != null) {
		orderBy = request.getParameter("orderBy");
	}
	
	// 2. 모델값
	// 2-1. 데이터 출력부
	int beginRow = (currentPage - 1) * rowPerPage;
	// 메서드 호출
	ProductDao dao = new ProductDao();
	CategoryDao dao2 = new CategoryDao();
	// 상품 검색
	ArrayList<HashMap<String, Object>> list = dao.searchResultListByPage(searchWord, categoryName, searchPrice1, searchPrice2, orderBy, beginRow, rowPerPage);
	// 카테고리 조회
	List<String> categoryList = dao2.getCategoryList();
	
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 검색 결과 상품 수 메서드 호출
	int totalRow = dao.searchResultCnt(searchWord, categoryName, searchPrice1, searchPrice2);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
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
	<title>조명 가게 | 검색 결과</title>
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
    <!-- Search Wrapper Area End -->
   <!-- ##### Main Content Wrapper Start ##### -->
	<div class="main-content-wrapper d-flex clearfix">
       <!-- menu 좌측 bar -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
	
        <div class="amado_product_area section-padding-100">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                    	<div class="checkout_details_area mt-50 clearfix">
                    	
                    		<div class="cart-title">
                                <h2>Search</h2>
                            </div>
                            
                            <form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
                            	<div class="row">
                            		<div class="col-12 mb-3">
	                            		<input type="text" class="form-control" name="searchWord" value="<%=searchWord%>" placeholder="키워드를 입력하세요">
	                            	</div>
	                            	<div class="col-12 mb-3">
		                            	<select class="w-100">
		                            		<option value="">Category</option>
		                            		<!-- CategoryDao 사용해서 버튼 출력, categoryName -->
											<%
												for(String s : categoryList) {
													if(!s.equals("관리자") && !s.equals("파격세일")) { // 관리자 카테고리는 출력하지 않는다
											%>
														<option value="<%=s%>" <%if(categoryName.equals(s)) {%> selected <%}%>><%=s%></option>
											<%
												
													}
												}
											%>
		                                </select>
		                            </div>
	                                <div class="col-md-6 mb-3">
	                            		<input type="number" class="form-control" name="searchPrice1" value="<%=searchPrice1%>" placeholder="최소금액">
	                            	</div>
	                                <div class="col-md-6 mb-3">
	                            		<input type="number" class="form-control" name="searchPrice2" value="<%=searchPrice2%>" placeholder="최대금액">
	                            	</div>
	                                 <div class="col-12 mb-3">
										<button type="submit" class="btn amado-btn w-100">Search</button>
									</div>
								</div>
                            </form>
                    	</div>
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                            <!-- Total Products -->
                            <div class="total-products">
                                <p>총 <%=totalRow%>개의 상품</p>
                            </div>
                            <!-- Sorting -->
                            <div class="product-sorting d-flex">
                                <div class="sort-by-date d-flex align-items-center mr-15">
                                    <p>Sort by</p>
                                    <!-- 정렬 선택 -->
									
									<input type="hidden" name="categoryName" value="<%=categoryName%>">
										<select name="orderBy" onchange="this.form.submit()" id="sortBydate">
											<option value="newItem" <%if(orderBy.equals("newItem")) {%> selected <%}%>>Newest</option>
											<option value="lowPrice" <%if(orderBy.equals("lowPrice")) {%> selected <%}%>>LowPrice</option>
											<option value="highPrice" <%if(orderBy.equals("highPrice")) {%> selected <%}%>>HighPrice</option>
										</select>
                                </div>
                                <div class="view-product d-flex align-items-center">
                                    <p>View</p>
                                    <input type="hidden" name="categoryName" value="<%=categoryName%>">
                                        <select name="rowPerPage" id="viewProduct" onchange="this.form.submit()">
	                                        <%
												for (int i = 5; i <= 50; i = i + 5) {
											%>
													<option value="<%=i%>" <%if (rowPerPage == i) {%> selected <%}%>>
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
                    </div>
                </div>

                <div class="row">
					<%
						for(HashMap<String, Object> m : list) {
							if(!m.get("categoryName").equals("관리자")) { 
					%>
			                    <!-- Single Product Area -->
			                    <div class="col-12 col-sm-6 col-md-12 col-xl-6">
			                        <div class="single-product-wrapper">
			                            <!-- Product Image -->
			                            <div class="product-img">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
			                                <!-- 상품 이미지 or 이름 클릭시 상품 상세로 이동 -->
												<%
													// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
													if(m.get("productImgSaveFilename") == null) {
												%>
														<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
												<%
													} else {
												%>
														<img src="<%=request.getContextPath()%>/<%=m.get("productImgPath")%>/<%=m.get("productImgSaveFilename")%>">
												<%	
													}
												%>
											</a>
			                            </div>
			                            <!-- Product Description -->
			                            <div class="product-description d-flex align-items-center justify-content-between">
			                                <!-- Product Meta Data -->
			                                <div class="product-meta-data">
			                                    <div class="line"></div>
			                                    <div>
			                                    	<!-- 할인유무에 따라 분기 -->
													<%
														if((int)m.get("productPrice") == (int)m.get("discountedPrice")) {
													%>
															<!-- 원가 출력 -->
															<span class="product-price">
																₩<%=m.get("productPrice")%>
															</span>
													<%
														} else {
													%>
															<div>
																<span class="product-price"> <!-- 할인 가격 굵게 출력 -->
																	₩<%=m.get("discountedPrice")%>
																</span>
																<span class="line-through"> <!-- 원가 취소선 출력 -->
																	₩<%=m.get("productPrice")%>
																</span>
																<span class="font-bold font-orange"> <!-- 할인율 -->
																	<%=(Double)m.get("discountRate") * 100%>%
																</span>
															</div>
													<%
														}
													%>
			                                    </div>
				                                <a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
			                                        <h6><%=m.get("productName")%>[<%=m.get("productStatus")%>]</h6>
			                                    </a>
			                                    <div class="cart text-right"> <!-- List에서 Cart로 넘길 때 listAction = 1 -->
			                                    	<a href="<%=request.getContextPath()%>/cart/cartListAction.jsp?productNo=<%=m.get("productNo")%>&productCnt=1&discountedPrice=<%=m.get("discountedPrice")%>&listAction=1" data-toggle="tooltip" data-placement="left" title="Add to Cart"><img src="<%=request.getContextPath()%>/resources/img/core-img/cart.png"></a>
			                                   	</div>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
	                <%
							}
						}
	                %>
	            <!------------------ 페이지 출력부 ------------------>
                <div class="row">
                    <div class="col-12">
                    	<nav aria-label="navigation">
                            <ul class="pagination justify-content-end mt-50">
				                <%
									// 이전은 1페이지에서는 출력되면 안 된다
									if(beginPage != 1) {
								%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>" class="page-link">
												&laquo;
											</a>
										</li>
								<%
									}
								
									for(int i = beginPage; i <= endPage; i++) {
										if(i == currentPage) { // 현재페이지에서는 a태그 링크 없이 출력
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
												<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>" class="page-link">
													<%=i%>
												</a>
											</li>
								<%
										}
									}
									// 다음은 마지막 페이지에서는 출력되면 안 된다
									if(endPage != lastPage) {
								%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>" class="page-link">
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
        </div>
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