<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.DecimalFormat" %>
<%
	// 전체 카테고리의 특가할인 상품 상위 n개 조회 메서드 호출
	ProductDao dao = new ProductDao();
	int n = 9; // 9개 조회
	String categoryName = ""; // 공백이면 전체 카테고리 조회
	ArrayList<HashMap<String, Object>> discountProductTop = dao.selectDiscountProductTop(categoryName, n);
	// 숫자 쉼표를 위한 선언
	DecimalFormat decimalFormat = new DecimalFormat("###,###,###");
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
	<title>조명 가게 | Home</title>
	
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
		
<!----------------------------------------------------- 공통적용 부분 끝 -->		
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

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

				<%
					for(HashMap<String, Object> m : discountProductTop) {
						// 할인율이 적용된 최종 가격과 비교해야 할인 날짜까지 고려가능
						if((int)m.get("productPrice") != (int)m.get("discountedPrice")) {
				%>
							<!-- Single Catagory -->
			                <div class="single-products-catagory clearfix">
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
			                        <!-- Hover Content -->
			                        <div class="hover-content">
			                            <div class="line"></div>
			                            <p>₩<%=decimalFormat.format(m.get("discountedPrice"))%></p>
			                        </div>
			                    </a>
			                </div>
				<%
						}
					}
				%>
            </div>
        </div>
        <!-- Product Catagories Area End -->
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