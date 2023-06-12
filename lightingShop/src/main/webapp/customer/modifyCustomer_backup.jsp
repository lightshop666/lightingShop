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
<title>Insert title here</title>
</head>
<body>
	 <h3>회원정보 수정</h3>
	 
	 <!-- 오류 메세지 출력 -->
	 <%
	 	if(request.getParameter("msg") != null) {
	 %>
	 	<%=request.getParameter("msg")%>
	 <%
	 	}
	 %>
	 
	 <!-- 회원정보 수정 -->
	 <form action="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp" method="post">
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
					<input type="text" id="cstmBirth" name="cstmBirth" value="<%=customerOne.get("c.cstm_birth") %>" placeholder="생년월일">
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="cstmPhone" name="cstmPhone" value="<%=customerOne.get("c.cstm_phone") %>" placeholder="전화번호">
				</td>
			</tr>
			<tr>
				<td>성별</td>
				<td>
					<select name="cstmGender">
					<option value="<%=customerOne.get("c.cstm_gender")%>"><%=customerOne.get("c.cstm_gender") %></option>
					<option value="남성">남성</option>
					<option value="여성">여성</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					<input type="hidden" id="updatedate" name="updatedate">
				</td>
			</tr>
		</table>
		<div><button type="submit" id="modifyBtn" class="btn btn-sm btn-outline-dark" onclick="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp">수정</button>
		<a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/customer/customerOne.jsp">취소</a></div>
	</form>
</body>
</html>