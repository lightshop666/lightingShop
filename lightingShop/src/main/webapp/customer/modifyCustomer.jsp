<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	 <h3>Update</h3>
	 <!-- 비밀번호 최근이력 3개와 중복될 경우 -->
	 <%
	 	if(pw != null) {
	 %>
	 	<div>최근 변경한 비밀번호와 중복됩니다.</div>
	 <%
	 	}
	 %>
	 
	 <!-- 기존 비밀번호 불일치 시 -->
	 <%
	 	if(noPwMsg != null) {
	 %>
	 	<div>기존 비밀번호가 일치하지 않습니다.</div>
	 <%
	 	}
	 %>
	 
	 <form action="<%=request.getContextPath()%>/customer/addCustomerAction.jsp" method="post">
		<table class="table">
			<tr>
				<td>
					<input type="password" id="customerPw" name="lastPw" placeholder="기존 비밀번호">
					<input type="hidden" id="oldPw" value=<%=loginCustomer.customerPw%>">
					<small id="customerPwMsg" class="form-text text-danger"></small>
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" id="customerNewPw" name="customerNewPw" placeholder="새 비밀번호">
					<small id="customerNewPwMsg" class="form-text text-danger"></small>
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" id="customerNewPwCk" name="customerNewPwCk" placeholder="새 비밀번호 확인">
					<small id="customerNewPwCkMsg" class="form-text text-danger"></small>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="customerName" name="customerName" value="${loginCustomer.customerName}" placeholder="이름">
					<small id="customerNameMsg" class="form-text text-danger"></small>
				</td>
			</tr>
			<tr>
				<td>
					<input type="number" id="customerPhone" name="customerPhone" value="${loginCustomer.customerPhone}" placeholder="전화번호">
					<small id="customerPhoneMsg" class="form-text text-danger"></small>
				</td>
			</tr>
		</table>
		<div><button type="button" id="modifyBtn" class="btn btn-sm btn-outline-dark">수정</button>
		<a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/customer/customerOne.jsp">취소</a></div>
	</form>
</body>
</html>