<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1. 유효성 검사
	// productNo
	/*
	if(request.getParameter("productNo") == null
			|| request.getParameter("productNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	*/
	int productNo = 10; // 테스트용
	// currentPage, rowPerPage
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 2. 모델값
	ProductDao dao = new ProductDao();
	// 2-1. 상품 상세 (이미지 + 상품 정보)
	
	// 2-2. 해당 상품의 리뷰
	
	// 2-3. 해당 상품의 문의
	// 페이징
	int beginRow = (currentPage - 1) * rowPerPage;
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	int totalRow = dao.selectProductQuestionCnt(productNo);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
	// 문의 리스트
	ArrayList<Question> questionList = dao.selectProductQuestionListByPage(beginRow, rowPerPage, productNo);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ProductOne</title>
</head>
<body>
	<h1><%=productNo%>번 상품의 상세 정보 출력 예정</h1>
	<h1><%=productNo%>번 상품의 리뷰 출력 예정</h1>
	<h1>문의 목록</h1>
	총 <%=totalRow %>건
	<!-- 해당 제품의 문의글 작성, productNo 값 넘기기 -->
	<a href="<%=request.getContextPath()%>/board/addQuestion.jsp?productNo=<%=productNo%>">
		문의하기
	</a>
	<table>
		<tr>
			<th>문의유형</th>
			<th>작성자</th>
			<th>제목</th>
			<th>문의날짜</th>
			<th>문의상태</th>
		</tr>
		<%
			for(Question q : questionList) {
		%>
				<tr>
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
	</table>
	<!-- 페이지 출력부 출력예정 -->
</body>
</html>