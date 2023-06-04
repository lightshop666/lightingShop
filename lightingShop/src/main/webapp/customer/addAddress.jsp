<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginCustomerEmail") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>배송지 추가</h1>
	
	<form action="<%=request.getContextPath()%>/customer/addAddressAction.jsp" method="post">
		<table class="table">
			<tr>
				<td>배송지명을 입력하세요</td>
				<td>
					<input type="text" name="addressName">
				</td>
			</tr>
			<tr>
				<td>배송지를 입력하세요</td>
				<td><textarea rows="3" cols="50" name="address"></textarea></td>
			</tr>
			
		</table>
		<button type="submit">추가</button>
	</form>
</body>
</html>