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
   <title>조명 가게 | 문의 수정</title>
   
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
            	<!-- 문의 수정폼 시작 -->
            	<form action="<%=request.getContextPath()%>/board/modifyQuestionAction.jsp" method="post">
				<input type="hidden" name="qNo" value="<%=qNo%>"> <!-- pNo는 수정불가 -->	
				<input type="hidden" name="qId" value="<%=question.getId()%>"> <!-- pId는 수정불가 -->	
                <div class="row">
                    <div class="col-12">
                    	<div class="cart-title">
                        	<h2>Question</h2>
                        </div>
                       	<table class="table">
                       		<%
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
									<th>작성자</th>
									<td><%=question.getqName()%></td>
								</tr>
								<tr>
									<th>문의 유형</th>
									<td>
										<select name="qCategory" class="w-100">
											<option value="상품" <%if(question.getqCategory().equals("상품")) {%> selected <%}%>>상품</option>
											<option value="교환/환불" <%if(question.getqCategory().equals("교환/환불")) {%> selected <%}%>>교환/환불</option>
											<option value="결제" <%if(question.getqCategory().equals("결제")) {%> selected <%}%>>결제</option>
											<option value="배송" <%if(question.getqCategory().equals("배송")) {%> selected <%}%>>배송</option>
											<option value="기타" <%if(question.getqCategory().equals("기타")) {%> selected <%}%>>기타</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td><input type="text" name="qTitle" class="form-control" value="<%=question.getqTitle()%>"></td>
								</tr>
								<tr>
									<th>내용</th>
									<td><textarea rows="15" cols="30" name="qContent" class="form-control"><%=question.getqContent()%></textarea></td>
								</tr>
								<tr>
									<th>공개/비공개</th>
									<td>
										<input type="radio" name="privateChk" value="N" <%if(question.getPrivateChk().equals("N")) { %> checked <% } %>>공개
										<input type="radio" name="privateChk" value="Y" <%if(question.getPrivateChk().equals("Y")) { %> checked <% } %>>비공개
										<span style="float:right;" id="privateChkMsg"></span>
									</td>
								</tr>
								<!-- 작성자 아이디와 현재 로그인 아이디가 일치하는 경우 비밀번호 입력란 출력X -->
								<%
									if(session.getAttribute("loginIdListId") == null
											|| !session.getAttribute("loginIdListId").equals(question.getId())) {
								%>
										<tr>
											<th>비밀번호</th>
											<td><input type="password" name="inputPw" class="form-control"></td>
										</tr>
								<%
									}
								%>
						</table>
						<div style="float:left;">
							<button type="submit" onclick="goBack()" class="btn btn-warning">
								취소
							</button>
						</div>
						<div style="float:right;">
							<button type="submit" class="btn btn-warning">
								수정
							</button>
						</div>
					</form>
				</div>
			</div>
				<!-- 문의 수정폼 끝 -->
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
					<!-- 답변 출력 끝 -->
				</div>
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