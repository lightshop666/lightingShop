<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%

	String category = null;
	if(request.getParameter("category") !=null){
		category = request.getParameter("category");
	}
	//모델 호출
	ReviewDao reviewDao = new ReviewDao();
	CategoryDao cateDao = new CategoryDao();
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 5;
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = reviewDao.selectReviewCnt();
	
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
	 ArrayList<HashMap<String, Object>> AllReviewList  = reviewDao.allReviewListByPage(beginRow, rowPerPage, category );
	//카테고리 출력
	List<String> cateList = cateDao.getCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>
<head>
	<meta charset="UTF-8">
	<!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
	<!-- Title  -->
	<title>조명 가게 - 리뷰 게시판 | Review List</title>
	
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
            <div class="cart-table clearfix">            
             <!-- 정렬 상품 카테고리 별로 -->
                <div class="row">
                    <div class="col-12 col-lg-11 text-center""  >
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                            <!-- Sorting -->
                            <div class="product-sorting d-flex">
                                <div class="sort-by-date d-flex align-items-center mr-15">
                                    <p>Sort by</p>
                                    <form action="<%=request.getContextPath()%>/review/myReview.jsp" method="get">
                                        <select name="selectCategory" id="sortBydate">
                                        	<option value="All">&nbsp;ALL</option>
                                        <%
                                        	for(String s : cateList){
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

				<!-- 모든 리뷰 출력, 글 누르면 상품 페이지로 -->
			<%
				for (HashMap<String, Object> m : AllReviewList) {
			%>
                    <!-- Single Product Area -->
                    <div class="col-12 col-sm-6 col-md-12 col-xl-6">
                        <div class="single-product-wrapper">
<!-- 리뷰 이미지 -->
                            <div class="product-img">
								<img class="product-img" src="<%= request.getContextPath() %>/<%= (String) m.get("reviewPath") %>/<%= (String) m.get("reviewSaveFilename") %>" alt="Review Image">

<!-- 리뷰 타이틀 -->
                            <div class="product-description d-flex align-items-center justify-content-between">
                                <!-- Product Meta Data -->
                                <div class="product-meta-data">
                                    <div class="line"></div>
                                    <p class="product-price"><%= m.get("reviewTitle") %></p>
                                    <a href=" <%=request.getContextPath()%>/review/reviewOne.jsp?orderProductNo=<%=(int)m.get("orderProductNo")%>">
                                        <h6><%= m.get("reviewContent") %></h6>
                                    </a>
                                </div>
<!-- 장바구니에 담기-->
	                                <div class="ratings-cart text-right">
	                                    <div class="ratings">
	                                    	<%= m.get("createdate") %>
	                                    </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
              <%
              }
              %>
              </div>
 <!-- 리뷰리스트 출력 종료 -->
 
				<div class="pagination justify-content-center mt-50">
	                <!-- 페이징 -->
	                    <div class="col-12">
	                        <nav aria-label="navigation">
	                            <ul class="pagination justify-content-end mt-50">
								<%
									//1번 페이지보다 작은데 나오면 음수로 가버린다
									if (minPage > 1) {
								%>
										<li class="page-item"><a href=" <%=request.getContextPath()%>/review/reviewList.jsp?currentPage=<%=minPage-pageRange%>">이전</a></li>
								
								<%	
									}
									for(int i=minPage; i <= maxPage; i=i+1){
										if ( i == currentPage){		
								%>
											<li class="page-item active"><span><%=i %></span></li>
								<%
										}else{
								%>
											<li class="page-item"><a href=" <%=request.getContextPath()%>/review/reviewList.jsp?currentPage=<%=i%>"><%=i %></a></li>
								<%
										}
									}
								
									//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
									if(maxPage != lastPage ){
								%>
										<!-- maxPage+1해도 동일하다 -->
										<li class="page-item"><a href=" <%=request.getContextPath()%>/review/reviewList.jsp?currentPage=<%=minPage+pageRange%>">다음</a></li>
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