<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListActive").equals("N")) { // 비회원 || 탈퇴회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	System.out.println("[customerOne컨트롤러 진입]");
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	
	// 회원정보 불러오기
	Customer customer = new Customer();
	customer.setId(sessionId);
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 브라우저 방문기록 기준으로 이전 페이지로 돌아감 -->
	<script>
		function goBack() {
		  window.history.back();
		}
	</script>
	<button onclick="goBack()">뒤로 가기</button>
	
		<div style="margin-top: 35px;"></div>
		
		<!-- [시작] 고객상세정보 출력 -->
		<div class="container">
			<h3>개인정보 관리</h3>
			
			<br>
			
			<table class="table table-hover" style="text-align: center">
				<tr>
					<td>아이디</td>
					<td><%=customerOne.get("c.id")%></td>
				</tr>
				<tr>
					<td>고객명</td>
					<td><%=customerOne.get("c.cstm_name")%></td>
				</tr>
				<tr>
					<td>배송지명</td>
					<td>
						<%=customerOne.get("a.address_name")%>
					</td>
				</tr>
			 	<tr>
					<td>주소</td>
					<td><%=customerOne.get("c.cstm_address")%></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td><%=customerOne.get("c.cstm_email")%></td>
				</tr>
				<tr>
					<td>생년월일</td>
					<td><%=customerOne.get("c.cstm_birth")%></td>
				</tr>
				<tr>
					<td>전화번호</td>
					<td><%=customerOne.get("c.cstm_phone")%></td>
				</tr>
				<tr>
					<td>성별</td>
					<td><%=customerOne.get("c.cstm_gender")%></td>
				</tr>
				<tr>
					<td>고객등급</td>
					<td><%=customerOne.get("c.cstm_rank")%></td>
				</tr>
				<tr>
					<td>포인트점수</td>
					<td><%=customerOne.get("c.cstm_point")%></td>
				</tr>
				<tr>
					<td>마지막 로그인 시간</td>
					<td><%=customerOne.get("c.cstm_last_login")%></td>
				</tr>
				<tr>
					<td>약관 동의 여부</td>
					<td><%=customerOne.get("c.cstm_agree")%></td>
				</tr>
				<tr>
					<td>가입일</td>
					<td><%=customerOne.get("c.createdate").toString().substring(0, 10)%></td>
				</tr> 
				<tr>
					<td>정보수정</td>
					<td>
						<button type="button" class="btn btn-warning btn-sm" onclick="location.href='<%=request.getContextPath()%>/customer/modifyCustomer.jsp'">정보수정</button>
					</td>
				</tr>
				<tr>
					<td>회원탈퇴</td>
					<td>
						<button type="button" class="btn btn-danger btn-sm" onclick="location.href='<%=request.getContextPath() %>/customer/removeCustomer.jsp'">회원탈퇴</button>
					</td>
				</tr>
			</table>
		</div>
		<!-- [끝] 고객상세정보 출력 -->	
		
		<form id="addressAddForm" action="${pageContext.request.contextPath}/AddressAdd" method="post">
							<div class="font-bold pb-3">
								주소추가
							</div>
		<div>
							<!-- 카카오 다음 우편번호 서비스 JS API -->
								<div class="ml-4 text-left">
								<input class="mr-3 mb-1" type="text" id="sample3_postcode" placeholder="우편번호" readonly="readonly">
								<input class="ml-2 mb-1" type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기"><br>
								<input class="mb-1" style="width:260px;" type="text" id="sample3_address" placeholder="주소"><br>
								<input class="mb-1" style="width:260px;" type="text" id="sample3_detailAddress" placeholder="상세주소">
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
		
		
		<div style="margin-top: 60px;"></div>
</body>
</html>