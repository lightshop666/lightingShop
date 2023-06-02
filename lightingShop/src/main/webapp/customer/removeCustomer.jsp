<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면
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
			<h3>회원탈퇴</h3>
			
			<br>
			
			<form method="post" action="<%=request.getContextPath() %>/member/memberDeleteAction.jsp">
				<table class="table table-hover" style="text-align: center">
					<tr>
						<td colspan="2">정말로 회원탈퇴를 진행하시겠습니까?<br>비밀번호를 다시 한 번 입력해주세요.</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" class="form-control" name="password"></td>
					</tr>
					<tr>
						<td colspan="2"><button type="submit" class="btn btn-danger btn-sm">회원탈퇴</button></td>
					</tr>
				</table>
			</form>
		</div>
			
		<div style="margin-top: 60px;"></div>
		
		<!-- 하단 메뉴 -->
		<div>
			<!-- tailMenu 항목을 include한다 -->
			<jsp:include page="/inc/tailMenu.jsp"></jsp:include>
		</div>
</body>
</html>