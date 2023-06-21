<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	//모델 호출
	ReviewDao reviewDao = new ReviewDao();
	CategoryDao cateDao = new CategoryDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println(currentPage + "<--crt-- ReviewList.jsp 새로 들어간 페이지 넘버");
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 5;
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 2;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = reviewDao.selectUserReviewCnt(loginMemberId);
	
	//마지막 페이지
	int lastPage = totalRow / rowPerPage;
	//마지막 페이지는 딱 나누어 떨어지지 않으니까 몫이 0이 아니다 -> +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	//페이지 목록 중 가장 작은 숫자의 페이지
	int minPage = ((currentPage - 1) / pageRange ) * pageRange + 1;
	//페이지 목록 중 가장 큰 숫자의 페이지
	int maxPage = minPage + (pageRange - 1 );
	//maxPage 가 last Page보다 커버리면 안되니까 lastPage를 넣어준다
	if (maxPage > lastPage){
		maxPage = lastPage;
	}
	
	//Review 출력
	 ArrayList<HashMap<String, Object>> reviewList  = reviewDao.selectReviewListByPage(beginRow, rowPerPage, loginMemberId);
	
	//카테고리 목록 출력
	List<String> category = cateDao.getCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Review Page</title>
<head>
	<meta charset="UTF-8">
	<!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
	<!-- Title  -->
	<title>조명 가게 - 나의 리뷰 | My review</title>
	
	<!-- Favicon  -->
	<link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
	
	<!-- Core Style CSS -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
</head>
<style>
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
    
        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="<%=request.getContextPath()%>/home.jsp"><img src = "<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
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
             <!-- 정렬 상품 카테고리 별로 -->
                <div class="row">
                    <div class="col-12">
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                            <!-- Sorting -->
                            <div class="product-sorting d-flex">
                                <div class="sort-by-date d-flex align-items-center mr-15">
                                    <p>Sort by</p>
                                    <form action="<%=request.getContextPath()%>/review/myReview.jsp" method="get">
                                        <select name="selectCategory" id="sortBydate">
                                        	<option value="All">&nbsp;ALL</option>
                                        <%
                                        	for(String s : category){
                                                if(s.equals("관리자")) continue; // 관리자 카테고리 건너뛰기
                                        %>
                                            <option value="<%=s %>">&nbsp;<%=s %></option>
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

<!-- 상품 이미지 출력 -->
		<%
		    for (HashMap<String, Object> m : reviewList) {
		    	//상품 이미지 출력을 위한 orderProduct 소환
		    	OrderProduct orderProduct = orderProductDao.orderProductOne( (int)m.get("orderProductNo") );
		    	int productNo = (int)orderProduct.getProductNo();
		    	//상품 이미지 소환을 위한 호출
		    	HashMap<String, Object> map = productDao.selectProductAndImg(productNo);
			    Product product = (Product) map.get("product");
			    ProductImg productImg = (ProductImg) map.get("productImg");
			    
		%>	
                    <!-- Single Product Area -->
                    <div class="col-12 col-sm-6 col-md-12 col-xl-6">
                        <div class="single-product-wrapper">
<!-- 리뷰 이미지 -->
                            <div class="product-img">
					    		<img class="thumbnail" src="<%= request.getContextPath() %>/<%= (String) m.get("reviewPath") %>/<%= (String)m.get("reviewSaveFilename") %>" alt="Review Image">
<!--호버(마우스 위에 올렸을 경우)시 상품 이미지-->
                                <img class="hover-img" src="<%= request.getContextPath() %>/<%= productImg.getProductPath() %>/<%= productImg.getProductSaveFilename() %>" alt="Product Image">
                            </div>

<!-- 리뷰 타이틀 -->
                            <div class="product-description d-flex align-items-center justify-content-between">
                                <!-- Product Meta Data -->
                                <div class="product-meta-data">
                                    <div class="line"></div>
                                    <p class="product-price"><%= m.get("reviewTitle") %></p>
                                    <a href=" <%=request.getContextPath()%>/review/reivewOne.jsp?orderProductNo=<%=(int)m.get("orderProductNo")%>">
                                        <h6><%= m.get("reviewContent") %></h6>
                                    </a>
                                </div>
<!-- 장바구니에 담기-->
	                                <div class="ratings-cart text-right">
	                                    <div class="ratings">
	                                    	작성일 : <%= m.get("createdate") %>
	                                    </div>
	                                    <div class="cart">
                                        	<a href=" <%=request.getContextPath()%>cart/cartList.html" data-toggle="tooltip" data-placement="left" title="Add to Cart"><img src="<%=request.getContextPath()%>/imgcore-img/cart.png"></a>
                                    	</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
              <%
              }
              %>
 <!-- 리뷰리스트 출력 종료 -->
 
                <div class="row">
                
                
<!-- 페이징 -->
                    <div class="col-12">
                        <nav aria-label="navigation">
                            <ul class="pagination justify-content-end mt-50">
							<%
								//1번 페이지보다 작은데 나오면 음수로 가버린다
								if (minPage > 1) {
							%>
									<li class="page-item"><a href=" <%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=minPage-pageRange%>">이전</a></li>
							
							<%	
								}
								for(int i=minPage; i <= maxPage; i=i+1){
									if ( i == currentPage){		
							%>
										<li class="page-item active"><span><%=i %></span></li>
							<%
									}else{
							%>
										<li class="page-item"><a href=" <%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=i%>"><%=i %></a></li>
							<%
									}
								}
							
								//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
								if(maxPage != lastPage ){
							%>
									<!-- maxPage+1해도 동일하다 -->
									<li class="page-item"><a href=" <%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=minPage+pageRange%>">다음</a></li>
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
<script>
// 이미지 클릭 시 확대/축소
	document.querySelector('.thumbnail').addEventListener('click', function() {
		var img = document.createElement('img');
		img.src = this.src;
		img.classList.add('fullscreen');
		img.addEventListener('click', function() {
			document.body.removeChild(this);
	});
	document.body.appendChild(img);
});
</script>
</html>