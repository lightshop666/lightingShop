<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>   
<%@ page import="vo.*" %>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	/* 
	// 세션 확인 - 관리자면 전부 가능
	if(session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListEmpLevel") == null) {
		response.sendRedirect(request.getContextPath()+"/admin/home.jsp");
		return;
	}  
	*/
	
	// 현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 페이지당 행 개수
	int rowPerPage = 5;
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
	
	String aChk = "";
	if(request.getParameter("aChk") != null) {
		aChk = request.getParameter("aChk");
	}
	
	// 시작행(0, 5, 10 ..)
	int beginRow = (currentPage-1) * rowPerPage;
	// Dao 호출
	EmpDao eDao = new EmpDao();
	// 문의글 리스트 조회 메서드 호출
	ArrayList<Question> list = eDao.selectQuestionListByPage(beginRow, rowPerPage, qCategory, searchCategory, searchWord, aChk);
	
	// totalRow -> 검색단어, 카테고리 선택에 따른 문의글 전체 수 조회 메서드 호출
	int totalRow = eDao.selectQuestionCnt(qCategory, searchCategory, searchWord, aChk);
	
	// 마지막 페이지
	int lastPage = totalRow / rowPerPage;
	
	// 딱 나누어 떨어지지 않을경우 남은 게시글 출력을 위해 +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	
	// 페이지네비게이션 표시 개수
	int pageRange = 5;
	int minPage = ((currentPage - 1) / pageRange) * pageRange + 1;
	int maxPage = minPage + (pageRange - 1 );
	// 마지막 페이지를 넘어가지 안도록 MaxPage를 제한
	if(maxPage > lastPage) {
		maxPage = lastPage;
	}
	
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
 <style>
        body {
        margin: 20px;
        background-color: #f9f9f9; 
    	}
        /* 테이블 스타일 */
        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th, .table td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        /* 테이블 헤더 색상 */
        .table thead th {
            background-color: #f2f2f2;
        }

        /* 테이블 로우 색상 */
        .table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .table tbody tr:hover {
            background-color: #e9e9e9;
        }

        /* 버튼 스타일 */
        .btn {
            display: inline-block;
            padding: 8px 12px;
            margin: 5px;
            font-size: 14px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            color: #fff;
            background-color: #4caf50;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-danger {
            background-color: #f44336;
        }

        /* 페이지네이션 스타일 */
        .pagination {
            margin-top: 20px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 5px;
            font-size: 14px;
            text-decoration: none;
            color: #000;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .pagination .current-page {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 5px;
            font-size: 14px;
            font-weight: bold;
            color: #fff;
            background-color: #4caf50;
            border: 1px solid #4caf50;
            border-radius: 4px;
        }
    </style>
</head>
<body>
	<!--관리자 메인메뉴 -->
	<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
	<br>

	<!-- 본문 -->
	<h1>Question List</h1>
	총 <%=totalRow%>건
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<!-- 문의 유형 카테고리 선택 + 검색(작성자 or 제목+내용) + 답변유무 조회 form -->
	<form action="<%=request.getContextPath()%>/admin/adminQuestionList.jsp" method="post">
		<table class="table">
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
				<td> <!-- 답변 유무 선택 -->
					<select name="aChk" onchange="this.form.submit()"> <!-- 옵션 선택시 바로 submit -->
						<option value="" <%if(aChk.equals("")) {%> selected <%}%>>전체보기</option>
						<option value="Y" <%if(aChk.equals("Y")) {%> selected <%}%>>답변완료</option>
						<option value="N" <%if(aChk.equals("N")) {%> selected <%}%>>답변대기</option>
					</select>
				</td>
				<td> <!-- 검색 카테고리 선택 (작성자 or 제목+내용) -->
					<select name="searchCategory">
						<option value="qName" <%if(searchCategory.equals("qName")) {%> selected <%}%>>작성자</option>
						<option value="qtitleAndContent" <%if(searchCategory.equals("qtitleAndContent")) {%> selected <%}%>>제목+내용</option>
					</select>
					<!-- 검색 단어 input 태그 -->
					<input type="text" name="searchWord">
					<button type="submit">검색</button>
				</td>
			</tr>
		</table>
	</form>
		<!-- 문의글 리스트 출력 -->
	<form action="<%=request.getContextPath()%>/admin/removeAdminQuestionAction.jsp" method="post">
		<table class="table">
			<thead class="table-active">
				<tr>
					<th>선택</th>
					<th>문의유형</th>
					<th>작성자</th>
					<th>제목</th>
					<th>문의날짜</th>
					<th>문의상태</th>
				</tr>
			</thead>
			<tbody>
			<%
				for(Question q : list) {
			%>
					<tr>
						<td><input type="checkbox" name="selectedQuestion" value="<%=q.getqNo()%>"></td>
						<td>[<%=q.getqCategory()%>]</td>
						<td><%=q.getqName()%></td>
						<td>
							<a href="<%=request.getContextPath()%>/admin/addAnswer.jsp?qNo=<%=q.getqNo()%>">
								<%=q.getqTitle()%>
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
			</tbody>
		</table>
		<button type="submit">삭제</button>
	</form>
	<%
		if(totalRow == 0) {
	%>
			문의글이 없습니다
	<%
		}
	%>
	
	<!-- 페이지 네비게이션 -->
	<nav class="pagination justify-content-center">
        <ul class="pagination">
		<%
			if (minPage > 1) {
		%>
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/admin/adminQuestionList.jsp?currentPage=<%=minPage-1%>&rowPerPage=<%=rowPerPage%>&qCategory=<%=qCategory%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>&aChk=<%=aChk%>">이전</a>
			</li>
		<%	
			}
			for(int i=minPage; i <= maxPage; i=i+1){
				if ( i == currentPage){		
		%>
				<li class="page-item">
					<a class="page-link"><%=i %></a>
				</li>
		<%
				}else{
		%>
				<li class="page-item">
					<a class="page-link" href="<%=request.getContextPath()%>/admin/adminQuestionList.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&qCategory=<%=qCategory%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>&aChk=<%=aChk%>"><%=i%></a>
				</li>
		<%
				}
			}
		
			if(maxPage != lastPage ){
		%>
			<li class="page-item">	
				<a href="<%=request.getContextPath()%>/admin/adminQuestionList.jsp?currentPage=<%=maxPage+1%>&rowPerPage=<%=rowPerPage%>&qCategory=<%=qCategory%>&searchCategory=<%=searchCategory%>&searchWord=<%=searchWord%>&aChk=<%=aChk%>">다음</a>
			</li>
		<%
			}
		%>
		</ul>
	</nav>
</body>
</html>