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
	/*
		int totalRow = dao.selectMyQuestionCnt(); 구현예정
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		if(endPage > lastPage) {
			endPage = lastPage;
		}
	*/
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myQuestionList</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/board/myQuestionList.jsp" method="post">
		<input type="date" name="selectDate">	
		<button type="submit">테스트</button>
	</form>
</body>
</html>