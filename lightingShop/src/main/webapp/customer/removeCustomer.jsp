<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면 홈으로
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//인코딩은 UTF-8로
	request.setCharacterEncoding("UTF-8");
	
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

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
    <!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	
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

				 <!-- [시작] 회원탈퇴폼 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-8">
			                	<div class="login-content">
			                  
									<h3>회원탈퇴</h3>
			
									<br>
									
									<div class="text-left mb-5">
											<div>사용 아이디는 탈퇴할 경우 <span style="font-weight:bold; color:red;">재사용 및 복구가 불가능</span>합니다.</div>
											<br>
											<div>탈퇴 후 회원정보 및 서비스 이용기록은 모두 삭제됩니다.</div>
											<br>
											<div>내용을 확인하셨으면 동의에 체크 후 비밀번호를 입력해주세요.</div>
											<hr>
											<small>
												<input type="checkbox" class="removeCk" name="cstmAgree" checked="checked">&nbsp;&nbsp;안내사항을 모두 확인하였으며, 이에 동의합니다
											</small>
									</div>
									<form id="removeForm" method="post" action="<%=request.getContextPath()%>/customer/removeCustomerAction.jsp">
										<div class="row">
											<div class="col-6">
												<input style="width:200px" type="password" class="form-control" name="lastPw" placeholder="비밀번호를 입력해주세요.">
											</div>
											<br>
											<div class="col-2">
												<select name="dropOut" style="width:200px">
												<option value="">탈퇴사유를 선택하세요</option>
												<option value="">디자인이 마음에 들지 않아요.</option>
												<option value="">원하는 물건이 없어요</option>
												<option value="">기타</option>
												</select>
											</div>
										</div>
										<br>
										<div>
											<button type="submit" id="removeBtn" class="btn btn-sm btn-outline-danger" onclick="<%=request.getContextPath()%>/customer/removeCustomerAction.jsp">탈퇴</button>
											<a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/customer/customerOne.jsp">취소</a>
										</div>
									</form>
										
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 회원탈퇴폼 출력 -->	
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
    <script src="js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="js/plugins.js"></script>
    <!-- Active js -->
    <script src="js/active.js"></script>

	<!-- js 유효성 검사 - DOM API 사용 -->
	<script>
	
	<!-- 오류 메세지 출력 -->
	<%
		String msg =  request.getParameter("msg");
		if(msg != null) {
	%>
		alert('비밀번호가 일치하지 않습니다.');
		return;
	<%
		}
	%>
	
    document.querySelector('form').addEventListener('submit', function(event) {
      
       let cstmAgreeInput = document.querySelector('input[name="cstmAgree"]');
       
       if (!cstmAgreeInput.checked) {
           event.preventDefault();
           alert('이용약관에 동의해주세요.');
           return;
       } 
	
    });  
    
    </script>
</body>
</html>	
