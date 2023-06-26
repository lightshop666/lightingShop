<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 회원정보수정 폼 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	Customer customer = new Customer();
	customer.setId(sessionId);
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
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

				 <!-- [시작] 회원정보수정폼 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-8">
			                	<div class="login-content">
			                  
								<h3>회원정보 수정</h3>
	 
								 <!-- 회원정보 수정 -->
								 <form action="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp" method="post">
								 	<input type="hidden" id="updatedate" name="updatedate">
									<table class="table">
										<tr>
											<td>
												<input type="password" id="lastPw" name="lastPw" placeholder="기존 비밀번호">
												<%-- <input type="hidden" id="oldPw" value=<%=sessionPw%>"> --%>
											</td>
										</tr>
										<tr>
											<td>
												<input type="password" id="customerNewPw" name="customerNewPw" placeholder="새 비밀번호">
											</td>
										</tr>
										<tr>
											<td>
												<input type="password" id="customerNewPwCk" name="customerNewPwCk" placeholder="새 비밀번호 확인">
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" id="cstmName" name="cstmName" value="<%=customerOne.get("c.cstm_name") %>" placeholder="이름">
											</td>
										</tr>
										<tr>
											<td>
												<input type="email" id="cstmEmail" name="cstmEmail" value="<%=customerOne.get("c.cstm_email") %>" placeholder="이메일">
											</td>
										</tr>
										<tr>
											<td>
												<input type="date" id="cstmBirth" name="cstmBirth" value="<%=customerOne.get("c.cstm_birth") %>" placeholder="생년월일">
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" id="cstmPhone" name="cstmPhone" value="<%=customerOne.get("c.cstm_phone") %>" placeholder="전화번호">
											</td>
										</tr>
										<tr>
											<td>
												성별을 선택하세요
												<select name="cstmGender">
												<option value="<%=customerOne.get("c.cstm_gender")%>"><%=customerOne.get("c.cstm_gender") %></option>
												<option value="남성">남성</option>
												<option value="여성">여성</option>
												</select>
											</td>
										</tr>
									</table>
									<div>
										<button type="submit" id="modifyBtn" class="btn btn-sm btn-outline-danger" onclick="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp">수정</button>
										<a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/customer/customerOne.jsp">취소</a>
									</div>
								</form>
								
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 회원정보수정폼 출력 -->	
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

	<!-- js 유효성 검사 - DOM API 사용 -->
	<script>
	
	<!-- 오류 메세지 출력 -->
	<%
		String noPwMsg =  request.getParameter("noPwMsg");
		if(noPwMsg != null) {
	%>
		alert('비밀번호가 서로 일치하지 않습니다.');
	<%
		}
	%>
	
	<%
		String overlapPw =  request.getParameter("overlapPw");
		if(overlapPw != null) {
	%>
		alert('최근 변경했던 비밀번호들과 중복됩니다.');
	<%
		}
	%>
	 
    document.querySelector('form').addEventListener('submit', function(event) {
      
       let cstmNameInput = document.querySelector('input[name="cstmName"]');
       // 이메일 형식을 검사할 정규식을 저장
       // '^': 시작 지점
       // '[a-zA-Z0-9._%+-]+': 이메일 아이디 부분으로 영문 대/소문자, 숫자 및 일부특수문자 사용가능
       // '@' : 중간에 들어가야 함
       // '[a-zA-Z0-9.-]+': 도메인 이름부분
       //  `\.`: '.' 문자 자체를 찾기 위해 사용(이메일의 경우 .을 도메인 이름과 구분하기 위해 사용하므로 \.으로 찾는다.)
       // '[a-zA-Z]{2,}': 최상위 도메인 부분으로 알파벳 글자 2이상
       // '$': 입력값의 끝으로, 작성하지 않으면 정규식의 일부 패턴만 맞아도 유효성 검사를 통과시킨다.
       const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
       let cstmEmailInput = document.querySelector('input[name="cstmEmail"]');
       const birthRegex = /^\d{4}-\d{2}-\d{2}$/;
	   let cstmBirthInput = document.querySelector('select[name="cstmBirth"]');
	   const phoneRegex = /^\d{3}-\d{3,4}-\d{4}$/;
	   let cstmPhoneInput = document.querySelector('select[name="cstmPhone"]');
	   let cstmGenderInput = document.querySelector('select[name="cstmGender"]');
       
       if (cstmNameInput.value.trim() === '') {
           event.preventDefault();
           alert('이름을 입력해주세요.');
           return;
       } 
	
       if (!emailRegex.test(cstmEmailInput.value.trim())) {
           event.preventDefault();
           alert('올바른 이메일 주소를 입력해주세요.');
           return;
       } 
       
       if (!birthRegex.test(cstmBirthInput.value.trim())) {
           event.preventDefault();
           alert('올바른 생년월일을 YYYY-MM-DD 형식으로 입력해주세요.');
           return;
       } 
       
       if (!phoneRegex.test(cstmPhoneInput.value.trim())) {
           event.preventDefault();
           alert('올바른 휴대전화번호를 입력해주세요. ex)010-1234-5678');
           return;
       } 
       
       if (cstmGenderInput.value.trim() === '') {
           event.preventDefault();
           alert('성별을 선택해주세요.');
           return;
       } 
       
    });  
    
    </script>
</body>
</html>								
