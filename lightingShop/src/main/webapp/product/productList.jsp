<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.text.DecimalFormat" %> <!-- 가격에 쉼표 표시 -->
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
	String orderBy = "";
	if(request.getParameter("orderBy") != null) {
		orderBy = request.getParameter("orderBy");
	}
	String categoryName = ""; // 전체조회
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	
	// 2. 모델값
	// 숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
	
	// 2-1. 데이터 출력부
	int beginRow = (currentPage - 1) * rowPerPage;
	// 메서드 호출
	ProductDao dao = new ProductDao();
	CategoryDao dao2 = new CategoryDao();
	// 해당 카테고리의 특가할인 상품 상위 n개 조회 메서드 호출
	int n = 4; // 몇개 조회할지 선택
	ArrayList<HashMap<String, Object>> discountProductTop = dao.selectDiscountProductTop(categoryName, n);	
	// 카테고리별 상품 리스트 조회 메서드 호출
	ArrayList<HashMap<String, Object>> list = dao.selectProductListByPage(categoryName, orderBy, beginRow, rowPerPage);
	// 카테고리 조회
	List<String> categoryList = dao2.getCategoryList();
	
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 카테고리별 상품 수 메서드 호출
	int totalRow = dao.selectProductCnt(categoryName);
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
   <title>조명 가게 | 상품 목록</title>
   
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

   <!-- ##### Main Content Wrapper Start ##### -->
	<div class="main-content-wrapper d-flex clearfix">
       <!-- menu 좌측 bar -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		
		<div class="shop_sidebar_area">
            <!-- ##### Single Widget ##### -->
            <div class="widget catagory mb-50">
                <!-- Widget Title -->
                <h6 class="widget-title mb-30">Catagories</h6>
                <!--  Catagories  -->
                <div class="catagories-menu">
                    <ul>
                        <li <%if(categoryName.equals("")) {%> class="active" <%} %> ><a href="<%=request.getContextPath()%>/product/productList.jsp">All</a></li>
                        <%
							for(String s : categoryList) {
								if(!s.equals("관리자") && !(s.equals("파격세일"))) { // 관리자,파격세일 카테고리는 출력하지 않는다
						%>
								<li <%if(categoryName.equals(s)) {%> class="active" <%} %> ><a href="<%=request.getContextPath()%>/product/productList.jsp?categoryName=<%=s%>"><%=s%></a></li>
						<%
							
								}
							}
						%>
                    </ul>
                </div>
            </div>
        </div>

        <div class="amado_product_area section-padding-100">
            <div class="container-fluid">
				<!-- 해당 카테고리의 특가할인 상품 상위 n개 출력 -->
				<h1>SALE</h1>
				<h6>최저가 구매를 놓치지 마세요!</h6>
				<div class="row">
					<!-- (자바스크립트) 자동 슬라이드 효과 예정 -->
					<%
						for(HashMap<String, Object> m : discountProductTop) {
							// 할인율이 적용된 최종 가격과 비교해야 할인 날짜까지 고려가능
							if((int)m.get("productPrice") != (int)m.get("discountedPrice")) {
					%>
								<!-- Single Product Area -->
			                    <div class="col-12 col-sm-6 col-md-12 col-xl-6">
			                        <div class="single-product-wrapper">
			                            <!-- Product Image -->
			                            <div class="product-img">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
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
												<span class="product-price"> <!-- 할인 가격 굵게 출력 -->
													₩<%=decimalFormat.format(m.get("discountedPrice"))%>
												</span>
												<span class="line-through"> <!-- 원가 취소선 출력 -->
													₩<%=decimalFormat.format(m.get("productPrice"))%>
												</span>
												<span class="font-bold font-orange"> <!-- 할인율 -->
													<%=(Double)m.get("discountRate") * 100%>%
												</span>
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
		        	</div>
		        	<div class="row">
	                    <div class="col-12">
	                        <nav aria-label="breadcrumb">
	                            <ol class="breadcrumb mt-50">
	                                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
	                                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/product/productList.jsp">Shop</a></li>
	                                <%
	                                	if(!categoryName.equals("")) {
	                                %>
	                                		<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/product/productList.jsp?categoryName=<%=categoryName%>"><%=categoryName%></a></li>
	                            	<%
	                                	}
	                            	%>
	                            </ol>
	                        </nav>
	                    </div>
	                </div>
                <div class="row">
                    <div class="col-12">
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
									<form action="<%=request.getContextPath()%>/product/productList.jsp" method="post">
									<input type="hidden" name="categoryName" value="<%=categoryName%>">
										<select name="orderBy" onchange="this.form.submit()" id="sortBydate">
											<option value="newItem" <%if(orderBy.equals("newItem")) {%> selected <%}%>>Newest</option>
											<option value="lowPrice" <%if(orderBy.equals("lowPrice")) {%> selected <%}%>>LowPrice</option>
											<option value="highPrice" <%if(orderBy.equals("highPrice")) {%> selected <%}%>>HighPrice</option>
										</select>
                                </div>
                                <div class="view-product d-flex align-items-center">
                                    <p>View</p>
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
																₩<%=decimalFormat.format(m.get("productPrice"))%>
															</span>
													<%
														} else {
													%>
															<div>
																<span class="product-price"> <!-- 할인 가격 굵게 출력 -->
																	₩<%=decimalFormat.format(m.get("discountedPrice"))%>
																</span>
																<span class="line-through"> <!-- 원가 취소선 출력 -->
																	₩<%=decimalFormat.format(m.get("productPrice"))%>
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
											<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>" class="page-link">
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
												<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>" class="page-link">
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
											<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>" class="page-link">
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