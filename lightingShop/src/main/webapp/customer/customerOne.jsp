<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	String IdListId = session.getAttribute("loginIdListId").toString();	// 현재 세션에 저장되어있는 회원 정보
	
	Customer customer = new Customer();
	customer.setId(IdListId);
	
	CustomerDao cDao = new CustomerDao();
	Customer customerOne = cDao.selectCustomerOne(customer);
	
	customerOne.getId();
	
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- 상단 메뉴 -->
		<div>
			<!-- headMenu 항목을 include한다 -->
			<jsp:include page="/inc/headMenu.jsp"></jsp:include>
		</div>
		
		<div style="margin-top: 35px;"></div>
		
		<div class="container">
			<h3>개인정보 관리</h3>
			
			<br>
			
			<table class="table table-hover" style="text-align: center">
				<tr>
					<td>아이디</td>
					<td><%=customerOne.getId()%></td>
				</tr>
				<tr>
					<td>고객명</td>
					<td><%=customerOne.getCstmName()%></td>
				</tr>
				<tr>
					<td>주소</td>
					<td><%=customerOne.getCstmAddress()%></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td><%=customerOne.getCstmEmail()%></td>
				</tr>
				<tr>
					<td>생년월일</td>
					<td><%=customerOne.getCstmBirth()%></td>
				</tr>
				<tr>
					<td>전화번호</td>
					<td><%=customerOne.getCstmPhone()%></td>
				</tr>
				<tr>
					<td>성별</td>
					<td><%=customerOne.getCstmGender()%></td>
				</tr>
				<tr>
					<td>고객등급</td>
					<td><%=customerOne.getCstmRank()%></td>
				</tr>
				<tr>
					<td>포인트점수</td>
					<td><%=customerOne.getCstmPoint()%></td>
				</tr>
				<tr>
					<td>약관 동의 여부</td>
					<td><%=customerOne.getCstmAgree()%></td>
				</tr>
				<tr>
					<td>회원수정</td>
					<td>
					<%		// 로그인했을 경우
							if (session.getAttribute("loginIdListId") == null) {
					%>
							<button type="button" class="btn btn-danger btn-sm" onclick="location.href='<%=request.getContextPath() %>/Customer/removeCustomer.jsp'">회원탈퇴</button>
					<%
							} else {	// 탈퇴한 회원일 때
					%>			탈퇴완료
					<%
							}
					%>
					</td>
					<td>정보수정</td>
					<td>
					<%		
							if (session.getAttribute("loginIdListId") == null) {
					%>
								<button type="button" class="btn btn-danger btn-sm" onclick="location.href='<%=request.getContextPath()%>/Customer/modifyCustomer.jsp'">정보수정</button>
					<%
							} else {	// 탈퇴한 회원일 때
					%>			수정완료
					<%
							}
					%>
					</td>
				</tr>
			</table>
		</div>
			
		<div style="margin-top: 60px;"></div>
		
		<!-- 하단 메뉴 -->
		<div>
			<!-- tailMenu 항목을 include한다 -->
			<jsp:include page="/inc/tailMenu.jsp"></jsp:include>
		</div>
</body>
</html>