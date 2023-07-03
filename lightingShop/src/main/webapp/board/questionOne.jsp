<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 유효성 검사 // qNo
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	
	// msg 값이 있으면 받아오기
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	System.out.println(msg);
	
	// 메서드 호출
	BoardDao dao = new BoardDao();
	// 객체에 값 넣기
	HashMap<String, Object> map = dao.selectQuestionOne(qNo);
	Question question = (Question)map.get("question");
	Answer answer = (Answer)map.get("answer");
	Product product = (Product)map.get("product");
	ProductImg productImg = (ProductImg)map.get("productImg");
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
   <title>조명 가게 | 문의 상세</title>
   
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
	
	// 뒤로가기 버튼
	function goBack() {
		window.history.back();
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
            	<!-- 문의 출력 시작 -->
                <div class="row">
                    <div class="col-12">
                    	<div class="cart-title">
                        	<h2>Question</h2>
                        </div>
                       	<table class="table">
							<tr>
								<td colspan="2">
									<h4>[<%=question.getqCategory()%>] <%=question.getqTitle()%><%if(question.getPrivateChk().equals("Y")) {%>&#x1F512;<%}%><h4>
									<p class="total-products text-right">
										<%=question.getqName()%> (<%=question.getId()%>) | <%=question.getUpdatedate()%>
									</p>
								</td>
							</tr>
							<%
								// 상품 선택시 (qNo가 1이 아니면) 해당 상품의 이미지와 이름 출력
								if(question.getProductNo() != 1) {
							%>
									<tr>
										<td colspan="2">
											<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=question.getProductNo()%>">
												<div class="card mb-3" style="max-width: 700px;">
												  <div class="row g-0">
												    <div class="col-md-4">
												    	<!-- 상품이미지 or 상품 이름 클릭 시 해당 상품 상세페이지로 이동 -->
															<%
																// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
																if(productImg.getProductSaveFilename() == null) {
															%>
																	<img src="<%=request.getContextPath()%>/productImg/no_image.jpg" class="img-fluid rounded-start">
															<%
																} else {
															%>
																	<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>" class="img-fluid rounded-start">
															<%	
																}
															%>
												    </div>
												    <div class="col-md-8">
												      <div class="card-body">
												        <h5 class="card-title"><%=product.getProductName()%></h5>
												        <p class="card-text"><small class="text-muted">클릭하면 해당 상품 페이지로 이동합니다</small></p>
												      </div>
												    </div>
												  </div>
												</div>
											</a>
										</td>
									</tr>
							<%
								}
							%>
							<tr>
								<td colspan="2">
									<%=question.getqContent()%>
								</td>
							</tr>
						</table>
						<button type="button" class="btn btn-warning">
							<a href="<%=request.getContextPath()%>/board/modifyQuestion.jsp?qNo=<%=qNo%>">
							 	수정
							</a>
						</button>
						<button type="button" class="btn btn-warning">
							<a href="<%=request.getContextPath()%>/board/removeQuestion.jsp?qNo=<%=qNo%>&qId=<%=question.getId()%>">
								삭제
							</a>
						</button>
	            	</div>
				</div>
				<!-- 문의 출력 끝 -->
				<br><br><br><br>
				<!-- 답변 출력 시작 -->
				<div class="row">
                    <div class="col-12">
                    	<div class="cart-title text-right">
                        	<h2>Answer</h2>
                        </div>
                        <table class="table">
	                        <%
								if(answer.getaContent() != null) {
							%>
									<tr>
										<td>
											<h4 class="text-right">고객님, 답변드립니다 :)<h4>
											<p class="total-products text-left">
												관리자 | <%=answer.getUpdatedate()%>
											</p>
										</td>
									</tr>
									<tr>
										<td>
											<div class="text-right">
											<%=answer.getaContent()%>
											</div>
										</td>
									</tr>
						<%
							} else {
						%>
								<tr>
									<td>
										<h5 class="text-right">관리자가 확인 후 답변을 남겨드리겠습니다</h5>
									</td>
								</tr>
						<%
							}
						%>
					</table>
					<div style="float:right;">
						<button type="submit" onclick="goBack()" class="btn btn-warning">목록으로</button>
					</div>
				</div>
				<!-- 답변 출력 끝 -->
			</div>
		</div>
	</div>
</div>
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