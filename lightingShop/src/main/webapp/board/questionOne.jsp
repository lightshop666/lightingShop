<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 유효성 검사
	// qNo
	/*
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	*/
	int qNo = 5; // 테스트용
	// 메서드 호출
	BoardDao dao = new BoardDao();
	// HashMap, Question, Answer 에 값 넣기
	HashMap<String, Object> map = dao.selectQuestionOne(qNo);
	Question question = (Question)map.get("question");
	Answer answer = (Answer)map.get("answer");
	/*
	// 비공개일 경우, 세션 아이디가 null이거나 일치하지 않으면 비밀번호 입력 페이지로 이동
	if(question.getPrivateChk().equals("Y")) {
		if(session.getAttribute("loginIdListId") == null
				|| !session.getAttribute("loginIdListId").equals(question.getId())) {
			response.sendRedirect(request.getContextPath() + "/board/inputPassword.jsp?qNo=" + qNo);
			return;
		}
	}
	*/
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>questionOne</title>
</head>
<body>
	<h1>
		문의
		<%
			if(question.getPrivateChk().equals("Y")) {
		%>
				[비공개]
		<%
			} else {
		%>
				[공개]
		<%
			}
		%>
	</h1>
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<table>
		<tr>
			<th>글번호</th>
			<td><%=question.getqNo()%></td>
		</tr>
		<tr>
			<th>아이디</th>
			<td><%=question.getId()%></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><%=question.getqName()%></td>
		</tr>
		<tr>
			<th>상품</th>
			<%
				if(question.getProductNo() != 1) {
			%>
					<td>
						(구현중)상품 선택 O, 상품 이미지와 이름 출력 + 클릭시 해당 상품 상세페이지로 이동
					</td>
			<%
				} else {
			%>
					<td>
						(구현중) 상품 선택 X
					</td>
			<%
				}
			%>
		</tr>
		<tr>
			<th>문의 유형</th>
			<td><%=question.getqCategory()%></td>
		</tr>
		<tr>
			<th>제목</th>
			<td><%=question.getqTitle()%></td>
		</tr>
		<tr>
			<th>내용</th>
			<td><%=question.getqContent()%></td>
		</tr>
		<tr>
			<th>작성일자</th>
			<td><%=question.getCreatedate()%></td>
		</tr>
		<tr>
			<th>수정일자</th>
			<td><%=question.getUpdatedate()%></td>
		</tr>
		<tr>
			<td>
				<a href="<%=request.getContextPath()%>/board/questiBoardList.jsp">
				 	목록으로
				</a>
				<a href="<%=request.getContextPath()%>/board/modifyQuestion.jsp?pNo=<%=qNo%>">
				 	수정
				</a>
				<a href="<%=request.getContextPath()%>/board/removeQuestion.jsp?pNo=<%=qNo%>&qId=<%=question.getId()%>">
					삭제
				</a>
			</td>
		<tr>
	</table>
	<h1>답변</h1>
	<%
		if(answer.getaContent() != null) {
	%>
		<table>
			<tr>
				<th>작성자</th>
				<td>관리자</td>
			</tr>
			<tr>
				<th>답변내용</th>
				<td><%=answer.getaContent()%></td>
			</tr>
			<tr>
				<th>작성일자</th>
				<td><%=answer.getCreatedate()%></td>
			</tr>
			<tr>
				<th>수정일자</th>
				<td><%=answer.getUpdatedate()%></td>
			</tr>
		</table>
	<%
		} else {
	%>
			<h4>관리자가 확인 후 답변을 남겨드리겠습니다</h4>
	<%
		}
	%>
</body>
</html>