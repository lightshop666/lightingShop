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
		
		<div style="margin-top: 60px;"></div>
</body>
</html>