<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 유효성 검사 // qNo
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertPassword</title>
</head>
<body>
	<h1>비밀번호 입력</h1>
	<h5>글 작성시 입력한 비밀번호를 입력해주세요</h5>
	<form action="<%=request.getContextPath()%>/board/inputPasswordAction.jsp" method="post">
		<input type="hidden" name="qNo" value="<%=qNo%>">
		<table>
			<tr>
				<th>PASSWORD</th>
				<td><input type="text" name="inputPw"></td>
				<td><button type="submit">입력</button></td>
				<!-- msg 발생시 출력 -->
				<%
					if(request.getParameter("msg") != null) {
				%>
					<td><%=request.getParameter("msg")%></td>
				<%
					}
				%>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp">목록으로</a>
	</form>
</body>
</html>