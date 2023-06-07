<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 문의글 리스트 페이지
	// 문의 유형 카테고리 선택조회 (select 태그) + 검색 조회(작성자 or 제목+내용 검색) + 페이징
	
	// 1. 유효성 검사
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String qCategory = "";
	if(request.getParameter("qCategory") != null) {
		qCategory = request.getParameter("qCategory");
	}
	String searchCategory = "";
	if(request.getParameter("searchCategory") != null) {
		searchCategory = request.getParameter("searchCategory");
	}
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	
	// 2. 모델값
	// 2-1. 데이터 출력부
	int beginRow = (currentPage - 1) * rowPerPage;
	// 문의글 리스트 조회 메서드 호출
	BoardDao dao = new BoardDao();
	ArrayList<Question> list = dao.selectQuestionListByPage(beginRow, rowPerPage, qCategory, searchCategory, searchWord);
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 검색단어, 카테고리 선택에 따른 문의글 전체 수 조회 메서드 호출
	int totalRow = dao.selectQuestionCnt(qCategory, searchCategory, searchWord);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>questionBoardList</title>
</head>
<body>
	<h1>문의글 목록</h1>
	총 <%=totalRow%>건
	<!-- 문의 유형 카테고리 선택 + 검색(작성자 or 제목+내용) 조회 form -->
	<form action="<%=request.getContextPath()%>/board/questionBoardList.jsp" method="post">
		<table>
			<tr>
				<td> <!-- 문의 유형 카테고리 선택 -->
					<select name="qCategory" onchange="this.form.submit()"> <!-- 옵션 선택시 바로 submit -->
						<option value="" <%if(qCategory.equals("")) {%> selected <%}%>>전체보기</option>
						<option value="상품" <%if(qCategory.equals("상품")) {%> selected <%}%>>상품</option>
						<option value="교환/환불" <%if(qCategory.equals("교환/환불")) {%> selected <%}%>>교환/환불</option>
						<option value="결제" <%if(qCategory.equals("결제")) {%> selected <%}%>>결제</option>
						<option value="배송" <%if(qCategory.equals("배송")) {%> selected <%}%>>배송</option>
						<option value="기타" <%if(qCategory.equals("기타")) {%> selected <%}%>>기타</option>
					</select>
				</td>
				<td> <!-- 검색 카테고리 선택 (작성자 or 제목+내용) -->
					<select name="searchCategory">
						<option value="qName" <%if(searchCategory.equals("qName")) {%> selected <%}%>>작성자</option>
						<option value="qtitleAndContent" <%if(searchCategory.equals("qtitleAndContent")) {%> selected <%}%>>제목+내용</option>
					</select>
					<!-- 검색 단어 input 태그 -->
					<input type="text" name="searchWord">
				</td>
				<td>
					<button type="submit">검색</button>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/board/addQuestion.jsp">
						문의하기
					</a>
				</td>
			</tr>
		</table>
	</form>
	<!-- 문의글 리스트 출력 -->
	<table>
		<tr>
			<th>문의유형</th>
			<th>작성자</th>
			<th>제목</th>
			<th>문의날짜</th>
			<th>문의상태</th>
		</tr>
		<%
			for(Question q : list) {
		%>
			<tr>
				<td>[<%=q.getqCategory()%>]</td>
				<td><%=q.getqName()%></td>
				<td>
					<%
						if(q.getPrivateChk().equals("Y")) { // 비공개인 경우
							if(session.getAttribute("loginIdListId") == null
									|| !session.getAttribute("loginIdListId").equals(q.getId())) {
								// 로그인 상태가 아니거나, 현재 로그인 아이디와 작성자 아이디가 일치하지 않으면
								// 비밀번호 입력 페이지로 이동
					%>
								<a href="<%=request.getContextPath()%>/board/inputPassword.jsp?qNo=<%=q.getqNo()%>">
									<%=q.getqTitle()%>
								</a>
								(잠긴 자물쇠 아이콘)
					<%
							} else {
								// 작성자 아이디와 현재 로그인 아이디가 일치하면 바로 문의글 상세페이지로 이동
					%>
								<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
									<%=q.getqTitle()%>
								</a>
								(잠긴 자물쇠 아이콘)
					<%
							}
						} else { // 비공개가 아닐경우 바로 문의글 상세 페이지로 이동
					%>
							<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
								<%=q.getqTitle()%>
							</a>
							(열린 자물쇠 아이콘)
					<%
						}
					%>
				</td>
				<td><%=q.getCreatedate().substring(0,10)%></td>
				<td>
					<%
						if(q.getaChk().equals("Y")) {
					%>	
							답변완료
					<%
						} else {
					%>		
							답변대기	
					<%
						}
					%>
				</td>
			</tr>
		<%
			}
		%>
	</table>
	<%
		if(totalRow == 0) {
	%>
			문의글이 없습니다
	<%
		}
	%>
	<!------------------ 페이지 출력부 ------------------>
	<%
		// 이전은 1페이지에서는 출력되면 안 된다
		if(beginPage != 1) {
	%>
			<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>">
				&laquo;
			</a>
	<%
		}
	
		for(int i = beginPage; i <= endPage; i++) {
			if(i == currentPage) { // 현재페이지에서는 a태그 없이 출력
	%>
				<span><%=i%></span>&nbsp;
	<%
			} else {
	%>
				<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>">
					<%=i%>
				</a>&nbsp;
	<%
			}
		}
		// 다음은 마지막 페이지에서는 출력되면 안 된다
		if(endPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>">
				&raquo;
			</a>
	<%
		}
	%>
</body>
</html>