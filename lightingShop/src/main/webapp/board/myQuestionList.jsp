<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");
	/*
		// 1. 유효성 검사
		// 1-1) 세션정보
		if(session.getAttribute("loginIdListId") == null) {
			response.sendRedirect(request.getContextPath() + "home.jsp");
			return;
		}
		String loginId = (String)session.getAttribute("loginIdListId");
	*/
	String loginId = "guest"; // 테스트용
	
	// 1-2) 요청값
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String beginDate = "";
	if(request.getParameter("beginDate") != null) {
		beginDate = request.getParameter("beginDate");
	}
	String endDate = "";
	if(request.getParameter("endDate") != null) {
		endDate = request.getParameter("endDate");
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
	// 특정 아이디의 문의글 리스트 조회 메서드 호출
	BoardDao dao = new BoardDao();
	ArrayList<Question> list = dao.selectMyQuestionList(beginRow, rowPerPage, loginId, beginDate, endDate, searchCategory, searchWord);
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 검색단어, 카테고리 선택에 따른 문의글 전체 수 조회 메서드 호출
	int totalRow = dao.selectMyQuestionCnt(beginRow, rowPerPage, loginId, beginDate, endDate, searchCategory, searchWord);
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
<title>myQuestionList</title>
<script>
	// 자바스크립트) 체크박스 전체 선택 / 전체 선택해제 
	function selectAll(selectAll)  {
		  const checkboxes 
		       = document.getElementsByName('qNo');
		  
		  checkboxes.forEach((checkbox) => {
		    checkbox.checked = selectAll.checked;
		  })
		}
</script>
</head>
<body>
	<h1>나의 문의글</h1>
	총 <%=totalRow%>건
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/myQuestionList.jsp" method="post">
		<table>
			<tr>
				<td> <!-- 조회 기간 선택 -->
				  <input type="date" name="beginDate" value="<%=beginDate%>">
				  ~
				  <input type="date" name="endDate" value="<%=endDate%>">
				</td>
				<td> <!-- 검색 카테고리 선택 (제목 or 내용) -->
					<select name="searchCategory">
						<option value="qTitle" <%if(searchCategory.equals("qTitle")) {%> selected <%}%>>제목</option>
						<option value="qContent" <%if(searchCategory.equals("qContent")) {%> selected <%}%>>내용</option>
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
			<th>
				<input type='checkbox' name='qNo' onclick='selectAll(this)'/>
				전체선택
			</th>
			<th>문의유형</th>
			<th>작성자</th>
			<th>제목</th>
			<th>문의날짜</th>
			<th>문의상태</th>
		</tr>
		<form action="<%=request.getContextPath()%>/board/removeMyQuestionAction.jsp" method="post">
		<input type="hidden" name="id" value="<%=loginId%>">
		<%
			for(Question q : list) {
		%>
				<tr>
					<td>
						<input type='checkbox' name='qNo' value='<%=q.getqNo()%>'/>
					</td>
					<td>[<%=q.getqCategory()%>]</td>
					<td><%=q.getqName()%></td>
					<td>
						<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=q.getqNo()%>">
							<%=q.getqTitle()%>
							<%
								if(q.getPrivateChk().equals("Y")) {
							%>
									(잠긴 자물쇠 아이콘)
							<%
								} else {
							%>
									(열린 자물쇠 아이콘)
							<%
								}
							%>
						</a>
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
			<tr>
				<td>
					<button type="submit">삭제</button>
				</td>
			</tr>
		</form>
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
			<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>">
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
				<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>">
					<%=i%>
				</a>&nbsp;
	<%
			}
		}
		// 다음은 마지막 페이지에서는 출력되면 안 된다
		if(endPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/board/myQuestionList.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>">
				&raquo;
			</a>
	<%
		}
	%>
</body>
</html>