<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 reviewList.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- reviewList.jsp");
		return;
	}

	//order_product_no 유효성 검사
	System.out.println(request.getParameter("orderProductNo")+"<--orderProductNo--reviewOne.jsp parm ");
	String orderProductNoStr = request.getParameter("orderProductNo");
	if (orderProductNoStr == null || orderProductNoStr.trim().isEmpty()) {
	    response.sendRedirect(request.getContextPath() + "/review/reviewList.jsp");
	    System.out.println("orderProductNo 유효성 검사에서 튕긴다<--reviewOne.jsp");
	    return;
	}
	int orderProductNo = Integer.parseInt(orderProductNoStr.trim());

	

	//리뷰사진 출력, 글 클릭시 상품 페이지로 이동
	//모델 호출	
	ReviewDao reviewDao = new ReviewDao();
	//담을 변수 선언
	Review review =	reviewDao.reviewOne(orderProductNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>조명 가게 | 리뷰 상세</title>
   
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
                	<form action="<%=request.getContextPath()%>/review/modifyReviewAction.jsp" method="post"  enctype="multipart/form-data">
                    <div class="col-12 col-lg-7"> 
                        <div class="single_product_desc">
                            <!-- Product Meta Data -->
                            <div class="product-meta-data">
                                <div class="line"></div>
<!-- 리뷰 타이틀 -->
									<span class="product-price">
										<input type="text" name="reviewTitle" value="<%=review.getReviewTitle()%>">
									</span>
									<p>
										<span>작성일 : </span>
										<span><%=review.getCreatedate()%></span>
									</p>
									<!-- 리뷰 날짜 -->
									<p>
										<span>수정일 : </span>
										<span><%=review.getUpdatedate()%></span>
									</p>
	                            <div class="short_overview my-5">
	                            	<textarea rows="3" cols="70" name="reviewContent"><%=review.getReviewContent()%></textarea>
	                            </div>     
                                <div class="line"></div>                      
                            </div>
                            <!-- 리뷰 이미지 -->
	                        <div class="single_product_thumb">
	                        	<div class="carousel-inner">
									<div class="carousel-item active">
										<img src="<%= request.getContextPath()%>/<%=(String)review.getReviewPath()%>/<%=(String)review.getReviewSaveFilename()%>" alt="Review Image">
	                               		<input type="file" name="reviewFile">                               
	                                 </div>
	                        	</div>
	                        </div>
				              <div>
									<input type="hidden" name="orderProductNo" value="<%=orderProductNo %> ">
									<input type="hidden" name="saveFilename" value="<%=(String)review.getReviewSaveFilename()%> ">
									<button type="submit" class="btn amado-btn w-100">수정</button>
							</div>
							
                        </div>
                    </div>	
                    </form>
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