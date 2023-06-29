<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 유효성 검사
	// 1-1) 세션정보
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath() + "home.jsp");
		return;
	}
	String loginId = (String)session.getAttribute("loginIdListId");
	
	// 1-2) 요청값
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String beginDate = "";
	if(request.getParameter("beginDate") != null) {
		beginDate = request.getParameter("beginDate");
	}
	String endDate = "";
	if(request.getParameter("endDate") != null) {
		endDate = request.getParameter("endDate");
	}
	String searchCategory = "";
	if(request.getParameter("searchCategory") != null) {
		searchCategory = request.getParameter("searchCategory");
	}
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	
	// msg 값이 있으면 받아오기
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	System.out.println(msg);
	
	// 2. 모델값
	// 2-1. 데이터 출력부
	int beginRow = (currentPage - 1) * rowPerPage;
	// 특정 아이디의 문의글 리스트 조회 메서드 호출
	BoardDao dao = new BoardDao();
	ArrayList<Question> list = dao.selectMyQuestionList(beginRow, rowPerPage, loginId, beginDate, endDate, searchCategory, searchWord);
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 검색단어, 카테고리 선택에 따른 문의글 전체 수 조회 메서드 호출
	int totalRow = dao.selectMyQuestionCnt(beginRow, rowPerPage, loginId, beginDate, endDate, searchCategory, searchWord);
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
   <title>조명 가게 | 문의 목록</title>
   
   <!-- BootStrap5 -->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
   
   <!-- Favicon  -->
   <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
   
   <!-- Core Style CSS -->
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
   <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
<script>
	//msg 띄우기
	function showMessage() {
		let msg = '<%=msg%>';
		if(msg !== "") {
			alert(msg);
		}
	}
	// 페이지 로드시 showMessage 함수를 호출
	window.addEventListener('DOMContentLoaded', showMessage);

	// 자바스크립트) 체크박스 전체 선택 / 전체 선택해제 
	function selectAll(selectAll)  {
		  const checkboxes 
		       = document.getElementsByName('qNo');
		  
		  checkboxes.forEach((checkbox) => {
		    checkbox.checked = selectAll.checked;
		  })
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
		<div class="amado_product_area section-padding-100">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                    	<div class="checkout_details_area mt-50 clearfix">
                    	
                    		<div class="cart-title">
                                <h2>나의 문의</h2>
                            </div>
                            
                            <form action="<%=request.getContextPath()%>/board/questionBoardList.jsp" method="post">
                            	<div class="row">
                            		<div class="col-md-4 mb-3"> 
                            			<select name="searchCategory" class="w-100">
                            				<option value="" <%if(searchCategory.equals("")) {%> selected <%}%>>검색 유형 선택</option>
											<option value="qTitle" <%if(searchCategory.equals("qTitle")) {%> selected <%}%>>제목</option>
											<option value="qContent" <%if(searchCategory.equals("qContent")) {%> selected <%}%>>내용</option>
										</select>
                            		</div>
                            		<div class="col-md-8 mb-3"> 
                            			<input type="text" class="form-control" name="searchWord" value="<%=searchWord%>" placeholder="키워드를 입력하세요">
                            		</div>
                            		<div class="col-md-6 mb-3">
       									<input type="date" name="beginDate" value="<%=beginDate%>" class="form-control">
                            		</div>
                            		<div class="col-md-6 mb-3">
       									<input type="date" name="endDate" value="<%=endDate%>" class="form-control">
                            		</div>
                            		<div class="col-md-6 mb-3">
	                            		<button type="submit" class="btn amado-btn w-100">Search</button>
	                            	</div>
	                                <div class="col-md-6 mb-3">
	                            		<a href="<%=request.getContextPath()%>/board/addQuestion.jsp">
	                            			<button type="button" class="btn amado-btn w-100">문의하기</button>
										</a>
	                            	</div>
								</div>
                    		</div>
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                            <!-- Total Products -->
                            <div class="total-products">
                                <p>총 <%=totalRow%>건</p>
                            </div>
                            <!-- Sorting -->
                            <div class="product-sorting d-flex">
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
				<!-- 문의글 리스트 출력 -->
				<table class="table">
					<thead class="table-dark">
						<tr>
							<th>
								<input type='checkbox' name='qNo' onclick='selectAll(this)'/>
								전체선택
							</th>
							<th>문의유형</th>
							<th>작성자</th>
							<th>제목</th>
							<th>문의날짜</th>
							<th>문의상태</th>
						</tr>
					</thead>
					<tbody>
						<form action="<%=request.getContextPath()%>/board/removeMyQuestionAction.jsp" method="post">
						<input type="hidden" name="id" value="<%=loginId%>">
						<%
							for(Question q : list) {
						%>
								<tr>
									<td>
										<input type='checkbox' name='qNo' value='<%=q.getqNo()%>'/>
									</td>
									<td>[<%=q.getqCategory()%>]</td>
									<td><h6><%=q.getqName()%></h6></td>
									<td>
										<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
											<%=q.getqTitle()%>
											<%
												if(q.getPrivateChk().equals("Y")) {
											%>
													&#x1F512;
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
					if(totalRow == 0) {
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
									if(beginPage != 1) {
								%>
										<li class="page-item">
											<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>" class="page-link">
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
												<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>" class="page-link">
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
											<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>" class="page-link">
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