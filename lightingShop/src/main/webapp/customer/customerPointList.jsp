<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//변수저장
	String id = (String)session.getAttribute("loginIdListId");	
	
	// 현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지당 행 개수
	int rowPerPage = 5;
	
	// 시작행(0, 5, 10 ..)
	int beginRow = (currentPage-1) * rowPerPage;
	
	
	// 포인트 내역확인 메서드 호출
	PointHistoryDao pDao = new PointHistoryDao();
	ArrayList<PointHistory> pointHistory = pDao.customerPointList(id ,beginRow, rowPerPage);
	
	// 고객 전체행 출력 메서드 호출
	CustomerDao cDao = new CustomerDao();
	// totalRow
	int totalRow = cDao.selectCustomerCnt();
	
	// 마지막 페이지
	int lastPage = totalRow / rowPerPage;
	
	// 딱 나누어 떨어지지 않을경우 남은 게시글 출력을 위해 +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	
	// 페이지네비게이션 표시 개수
	int pageRange = 5;
	int minPage = ((currentPage - 1) / pageRange) * pageRange + 1;
	int maxPage = minPage + (pageRange - 1 );
	// 마지막 페이지를 넘어가지 안도록 MaxPage를 제한
	if(maxPage > lastPage) {	
		maxPage = lastPage;
	}
	
%>
   
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Amado - MyPage</title>
    
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

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

				 <!-- [시작] 주소목록 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-10">
			                	<div class="login-content">
			                  
							   	<!-- 포인트 내역 확인 -->
								<h2>포인트 확인</h2>
								<table class = "table" style="table-layout: auto; width: 100%; table-layout: fixed;">
										<tr>
											<th>주문번호</th>
											<th>포인트 내역</th>
											<th>포인트</th>
											<th>적립일</th>
										</tr>
									<%
										for(PointHistory p : pointHistory) {
									%>
										
										<tr>
											<td><%=p.getOrderNo() %></td>
											<td><%=p.getPointInfo() %></td>
											<td><%=p.getPoint() %></td>
											<td><%=p.getCreatedate() %></td>
										</tr>
									<%
										}
									%>
								</table>
									<div class="pagination mt-50" style="display: flex; justify-content: center;">
									    <!-- 페이징 -->
									    <div class="col-12">
									        <nav aria-label="navigation">
												<ul class="pagination justify-content-center">
												<%
													if (minPage > 1) {
												%>
														<li class="page-item">
														<a class="page-link" href="<%=request.getContextPath()%>/customer/customerPointList.jsp?currentPage=<%=minPage-1%>">이전</a>
														</li>
												<%	
													}
													for(int i=minPage; i <= maxPage; i=i+1){
														if ( i == currentPage){		
												%>
														<li class="page-item">
															<strong class="page-link"><%=i %></strong>
														</li>
												<%
														}else{
												%>
														<li class="page-item">
															<a class="page-link" href="<%=request.getContextPath()%>/customer/customerPointList.jsp?currentPage=<%=i%>"><%=i %></a>
														</li>
												<%
														}
													}
												
													if(maxPage != lastPage ){
												%>
													<li class="page-item">
														<a class="page-link" href="<%=request.getContextPath()%>/customer/customerPointList.jsp?currentPage=<%=minPage+1%>">다음</a>
													</li>
												<%
													}
												%>
										      	
												</ul>
											</nav>
										</div>
									</div>
									<div class="row">
								      	<div class="col-auto mr-auto">	
									        <a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/customer/myPage.jsp">뒤로</a>
										</div>
									</div>
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 주소목록 출력 -->	
            </div>
        </div>
        <!-- Product Catagories Area End -->
    </div>
    <!-- ##### Main Content Wrapper End ##### -->
    
    <!-- footer 하단 bar -->
    <div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>

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
