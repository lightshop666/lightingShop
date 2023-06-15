<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//변수저장
	String id = (String)session.getAttribute("loginIdListId");	
	
	// 현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지당 행 개수
	int rowPerPage = 5;
	
	// 시작행(0, 5, 10 ..)
	int beginRow = (currentPage-1) * rowPerPage;
	
	
	// 포인트 내역확인 메서드 호출
	PointHistoryDao pDao = new PointHistoryDao();
	ArrayList<HashMap<String, Object>> list = pDao.CustomerPointList(beginRow, rowPerPage);
	
	// 고객 전체행 출력 메서드 호출
	CustomerDao cDao = new CustomerDao();
	// totalRow
	int totalRow = cDao.selectCustomerCnt();
	
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
</head>
<body>
	<!-- 포인트 내역 확인 -->
	<div class="container">
		<h2>포인트 확인</h2>
		<table>
				<tr>
					<th>주문번호</th>
					<th>포인트 내역</th>
					<th>포인트</th>
					<th>적립일</th>
				</tr>
			<%
				for(HashMap<String, Object> m : list) {
			%>
				
				<tr>
					<td><%=m.get("orderNo") %></td>
					<td><%=m.get("pointInfo") %></td>
					<td><%=m.get("point") %></td>
					<td><%=m.get("createdate") %></td>
				</tr>
			<%
				}
			%>
		</table>	
	</div>
	
	<div class = "center">
		<%
			if (minPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/emp/adminQuestionList.jsp?currentPage=<%=minPage-1%>">이전</a>
		
		<%	
			}
			for(int i=minPage; i <= maxPage; i=i+1){
				if ( i == currentPage){		
		%>
					<strong><%=i %></strong>
		<%
				}else{
		%>
					<a href="<%=request.getContextPath()%>/emp/adminQuestionList.jsp?currentPage=<%=i%>"><%=i %></a>
		<%
				}
			}
		
			if(maxPage != lastPage ){
		%>
				<!-- maxPage+1해도 동일하다 -->
				<a href="<%=request.getContextPath()%>/emp/adminQuestionList.jsp?currentPage=<%=minPage+1%>">다음</a>
		<%
			}
		%>
	</div>
</body>
</html>