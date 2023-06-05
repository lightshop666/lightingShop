<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 유효성 검사 // qNo, qId
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")
			|| request.getParameter("qId") == null
			|| request.getParameter("qId").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String qId = request.getParameter("qId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>removeQuestion</title>
</head>
<body>
	<h1>문의글 삭제</h1>
	<form action="<%=request.getContextPath()%>/board/removeQuestionAction.jsp" method="post">
		<input type="hidden" name="qNo" value="<%=qNo%>">
		<input type="hidden" name="qId" value="<%=qId%>">
		<table>
			<%
				if(session.getAttribute("loginIdListId") == null
						|| !session.getAttribute("loginIdListId").equals(qId)) {
			%>
					<tr>
						<h5>글 작성시 입력한 비밀번호를 입력해주세요</h5>
					</tr>
					<tr>
						<th>PASSWORD</th>
						<td>	
							<input type="text" name="inputPw">
							<!-- msg 발생시 출력 -->
							<%
								if(request.getParameter("msg") != null) {
							%>
									<%=request.getParameter("msg")%>
							<%
								}
							%>
						</td>
					</tr>
			<%
				} else { // 작성자 아이디와 현재 로그인 아이디가 일치하는 경우 비밀번호 입력란 출력X
			%>
					<tr>
						<h5>정말 삭제하시겠습니까?</h5>
					</tr>
			<%
				}
			%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=qNo%>">
						취소
					</a>
				</td>
				<td><button type="submit">삭제</button></td>
			</tr>
		</table>
	</form>
</body>
</html>