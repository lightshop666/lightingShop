<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	//session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginIdListId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
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

	<!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Title  -->
    <title>Amado - MyPage</title>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
 
 <style>
	
	.addCus-content {
		width: 440px;
		padding: 20px;
		background-color: #f5f9fa;
		border-radius: 5px;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	}
	.addCus-content h2 {
		text-align: left;
		margin-top: 0;
	}
	.addCus-content form {
		display: flex;
		flex-direction: column;
	}
	.addCus-content table {
		
	}
	
	.addCus-content input[type="text"],
	.addCus-content input[type="password"],
	.addCus-content input[type="email"],
	.addCus-content input[type="date"]
	{
		margin-bottom: 10px;
		padding: 8px;
		border-radius: 3px;
		border: 1px solid #ccc;
		width:400px;
	}
	
	.addCus-content select {
		margin-bottom: 10px;
		padding: 8px;
		border-radius: 3px;
		border: 1px solid #ccc;
	}
	
	.addCus-content input[type="submit"] {
		padding: 8px 12px;
		border: none;
		border-radius: 3px;
		background-color: #3f51b5;
		color: #fff;
		cursor: pointer;
	}
	.addCus-content input[type="submit"]:hover {
		background-color: #303f9f;
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
    <div class="main-content-wrapper d-flex clearfix" style='margin-bottom: 350px;'>
    
    	<!-- menu 좌측 bar -->
	    <div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>


        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

				 <!-- [시작] 회원가입폼 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-10">
			                	<div class="addCustomer">
			                  		<div class="addCus-content">
					                  <h2>회원 가입</h2>
										<br>
										<form id="addressAddForm" action="<%=request.getContextPath()%>/customer/addCustomerAction.jsp" method="post">
											<input type="hidden" name="cstmRank" value="동">
											<table >
												<tr>
													<td>
														<input type="text" name="id" placeholder="아이디 입력(4-20자)">
													</td>
												</tr>
												<tr>
													<td><input type="password" name="lastPw" placeholder="비밀번호 입력(문자, 숫자, 특수문자 포함 4-20자)"></td>
												</tr>
												<tr>
													<td><input type="text" name="cstmName" placeholder="이름을 입력해 주세요"></td>
												</tr>
											
												<tr>
													<td><input type="email" name="cstmEmail" placeholder="abcb@gmail.com"></td>
												</tr>
												<tr>
													<td><input type="date" name="cstmBirth" placeholder="생년월일 입력"></td>
												</tr>
												<tr>
													<td><input type="text" name="cstmPhone" placeholder="휴대폰 번호 입력(ex)010-1234-5678)"></td>
												</tr>
												<tr>
													<td><input type="text" name="addressName" placeholder="배송지를 입력하세요."></td>
												</tr>
											</table>
												<select name="cstmGender">
														<option value="">성별을 선택하세요</option>
														<option value="남성">남성</option>
														<option value="여성">여성</option>
												</select>
												<br>
												<div class="agree">
													약관에 동의해 주세요&nbsp;&nbsp;
													<input type="checkbox" name="cstmAgree" value="Y" checked="checked">
												</div>
													
												<hr>
												<div class="font-bold pb-3">
													주소추가
												</div>
												
											    <div>
													<!-- 카카오 다음 우편번호 서비스 JS API -->
														<div class=" text-left">
														<input class="mr-3 mb-1" type="text" name="sample3Postcode" id="sample3_postcode" placeholder="우편번호" readonly="readonly">
														<input class="ml-2 mb-1" type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기"><br>
														<input class="mb-1"  type="text" name="sample3Address" id="sample3_address" placeholder="주소"><br>
														<input class="mb-1"  type="text" name="sample3DetailAddress" id="sample3_detailAddress" placeholder="상세주소">
														<input class="mb-1" style="width:140px;" type="text" id="sample3_extraAddress" placeholder="참고항목">
														</div>
														<div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
														<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
														</div>
														
														<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
														<script>
														    // 우편번호 찾기 찾기 화면을 넣을 element
														    var element_wrap = document.getElementById('wrap');
														
														    function foldDaumPostcode() {
														        // iframe을 넣은 element를 안보이게 한다.
														        element_wrap.style.display = 'none';
														    }
														
														    function sample3_execDaumPostcode() {
														        // 현재 scroll 위치를 저장해놓는다.
														        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
														        new daum.Postcode({
														            oncomplete: function(data) {
														                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
														
														                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
														                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
														                var addr = ''; // 주소 변수
														                var extraAddr = ''; // 참고항목 변수
														
														                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
														                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
														                    addr = data.roadAddress;
														                } else { // 사용자가 지번 주소를 선택했을 경우(J)
														                    addr = data.jibunAddress;
														                }
														
														                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
														                if(data.userSelectedType === 'R'){
														                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
														                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
														                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
														                        extraAddr += data.bname;
														                    }
														                    // 건물명이 있고, 공동주택일 경우 추가한다.
														                    if(data.buildingName !== '' && data.apartment === 'Y'){
														                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
														                    }
														                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
														                    if(extraAddr !== ''){
														                        extraAddr = ' (' + extraAddr + ')';
														                    }
														                    // 조합된 참고항목을 해당 필드에 넣는다.
														                    document.getElementById("sample3_extraAddress").value = extraAddr;
														                
														                } else {
														                    document.getElementById("sample3_extraAddress").value = '';
														                }
														
														                // 우편번호와 주소 정보를 해당 필드에 넣는다.
														                document.getElementById('sample3_postcode').value = data.zonecode;
														                document.getElementById("sample3_address").value = addr;
														                
														                // 커서를 상세주소 필드로 이동한다.
														                document.getElementById("sample3_detailAddress").focus();
														
														                // iframe을 넣은 element를 안보이게 한다.
														                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
														                element_wrap.style.display = 'none';
														
														                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
														                document.body.scrollTop = currentScroll;
														            },
														            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
														            onresize : function(size) {
														                element_wrap.style.height = size.height+'px';
														            },
														            width : '100%',
														            height : '100%'
														        }).embed(element_wrap);
														
														        // iframe을 넣은 element를 보이게 한다.
														        element_wrap.style.display = 'block';
														    }
														</script>
														<input type="hidden" name="cstmAddress" id="addressInput">
													</div>
											
											<button id="addressAddBtn" type="submit" class="btn btn-sm btn-outline-danger mt-3" >회원가입</button>
											<a class="btn btn-sm btn-outline-dark mt-3" href="<%=request.getContextPath()%>/customer/myPage.jsp">취소</a>
										</form>
								  </div>
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 회원가입폼 출력 -->	
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
	
	// 주소 추가 버튼 클릭 이벤트 핸들러
    document.getElementById("addressAddBtn").addEventListener("click", function() {
        // 주소 값 가져오기
        var postcode = document.getElementById("sample3_postcode").value;
        var address = document.getElementById("sample3_address").value;
        var detailAddress = document.getElementById("sample3_detailAddress").value;

        if (postcode.value.trim() === '') {
            event.preventDefault();
            alert('우편번호를 입력해주세요.');
            return;
        } 
        
        if (address.value.trim() === '') {
            event.preventDefault();
            alert('주소를 입력해주세요.');
            return;
        } 
        
        if (detailAddress.value.trim() === '') {
            event.preventDefault();
            alert('상세주소를 입력해주세요.');
            return;
        } 
        
        // 주소 값 조합하여 addressInput의 값을 설정
        var fullAddress = postcode +" "+ address + " " + detailAddress;
        document.getElementById("addressInput").value = fullAddress;
    });
	
	<!-- 오류 메세지 출력 -->
	<%
		String msg =  request.getParameter("msg");
		if(msg != null) {
	%>
		alert('중복된 아이디가 존재합니다.');
	<%
		}
	%>
	
	document.querySelector('form').addEventListener('submit', function(event) {
	      
		let idInput = document.querySelector('input[name="id"]');	
		let lastPwInput = document.querySelector('input[name="lastPw"]');	
		
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
		let addressNameInput = document.querySelector('select[name="addressName"]');
		let cstmGenderInput = document.querySelector('select[name="cstmGender"]');
		let cstmAgreeInput = document.querySelector('select[name="cstmAgree"]');
		
		if (idInput.value.length < 4 || idInput.value.length > 20) {
		    event.preventDefault();
		    alert('ID는 4~20자여야 합니다.');
		    return;
		} 
		
		if (lastPwInput.value.length < 4 || lastPwInput.value.length > 20) {
		    event.preventDefault();
		    alert('PW는 4~20자여야 합니다.');
		    return;
		} 
	   
		if (cstmNameInput.value.length < 2) {
		    event.preventDefault();
		    alert('이름은 2자이상이어야 합니다.');
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
		
		if (addressNameInput.value.trim() === '') {
		    event.preventDefault();
		    alert('배송지를 입력해주세요.');
		    return;
		} 
		
		if (cstmGenderInput.value.trim() === '') {
		    event.preventDefault();
		    alert('성별을 선택해주세요.');
		    return;
		} 
		
		if (!cstmAgreeInput.checked) {
	        event.preventDefault();
	        alert('이용약관에 동의해주세요.');
	        return;
	    } 
	       
	});  
    
    </script>
</body>
</html>				
