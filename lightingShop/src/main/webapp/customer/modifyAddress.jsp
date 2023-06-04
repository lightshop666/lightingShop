<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>
<%@page import="vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 회원정보수정 폼 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	CustomerDao cDao = new CustomerDao();
	Address myAddress = cDao.myAddress(addressNo);
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>배송지 수정</h3>
	
	 <!-- 오류 메세지 출력 -->
	 <%
	 	if(request.getParameter("msg") != null) {
	 %>
	 	<%=request.getParameter("msg")%>
	 <%
	 	}
	 %>
	 
	 <!-- 배송지 정보 수정 -->
	 <form action="<%=request.getContextPath()%>/customer/modifyAddressAction.jsp" method="post">
		<table class="table">
			<tr>
				<td>
					<input type="text" id="addressName" name="addressName" value="<%=myAddress.getAddressName() %>" placeholder="배송지명">
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="address" name="address" value="<%=myAddress.getAddress() %>" placeholder="배송지">
				</td>
			</tr>
			<tr>
				<td>
					<input type="hidden" id="addressNo" name="addressNo" value="<%=myAddress.getAddressNo() %>">
				</td>
			</tr>
		</table>
		<div><button type="submit" id="modifyBtn" class="btn btn-sm btn-outline-dark" >수정</button>
		<a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/customer/addressList.jsp">취소</a></div>
	</form>
</body>
</html>