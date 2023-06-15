<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="vo.*" %>
<%
    /* 세션 검사
    if (!session.getAttribute("loginIdListEmpLevel").equals("3")) { // 직원 레벨 3이 아니면
        String msg = "접근 권한이 없습니다.";
        response.sendRedirect(request.getContextPath() + "/admin/home.jsp?msg=" + msg);
        return;
    }
    */
    EmpDao empDao = new EmpDao();

    // 요청값 분석
    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }

    // 정렬 정보 가져오기
    String col = request.getParameter("col");
    if (col == null) {
        col = "";
    }

    String ascDesc = request.getParameter("ascDesc");
    if (ascDesc == null) {
        ascDesc = "";
    }

    // 검색 정보 가져오기
    String searchCol = request.getParameter("searchCol");
    if (searchCol == null) {
        searchCol = "";
    }

    String searchWord = request.getParameter("searchWord");
    if (searchWord == null) {
        searchWord = "";
    }

    // 기간 정보 가져오기
    String startDate = request.getParameter("startDate");
    if (startDate == null) {
        startDate = "";
    }

    String endDate = request.getParameter("endDate");
    if (endDate == null) {
        endDate = "";
    }

    // 페이지당 행 수
    int rowPerPage = 10;

    // 시작 행 계산
    int beginRow = (currentPage - 1) * rowPerPage;

    // 할인 목록 조회
    ArrayList<Discount> discountList = empDao.selectDiscountListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord, startDate, endDate);

    // 전체 행 수
    int totalRow = empDao.selectDiscountCnt(searchCol, searchWord);
    int lastPage = totalRow / rowPerPage;
    if (totalRow % rowPerPage != 0) {
        lastPage++;
    }

    int pagePerPage = 10; // 한 페이지 당 쪽 수
    int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
    int maxPage = minPage + (pagePerPage - 1);
    if (maxPage > lastPage) {
        maxPage = lastPage;
    }
    
	String msg = null;
	if (request.getParameter("msg") != null) {
	 	msg = request.getParameter("msg");
	}

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
       <style>
        body {
        margin: 20px;
        background-color: #f9f9f9; /* Set the background color to gray */
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
    <script>

		<% 
			if (msg != null) { 
		%>
		    	alert('<%= msg %>');
		<% 
			}         
		%>
    </script>
</head>
<body>
<!--관리자 메인메뉴 -->
<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
<br>
<!-- 본문 -->
<h1>Discount List</h1>
<!-- 검색 조건 영역 -->
<form method="get" action="<%= request.getContextPath() %>/admin/adminDiscountList.jsp">
<!-- 기간 선택 폼 -->
        <div class="search-area">
            <label for="startDate" class="form-label">기간</label>
            <input type="date" name="startDate" value="<%= startDate %>">
            <label for="endDate" class="form-label">~</label>
            <input type="date" name="endDate" value="<%=endDate%>">
            <button type="submit">조회</button>
        </div>
        <div class="search-area">
        <label class="search-label">검색</label>
            <select name="searchCol">
                <option value="product_no" <% if (searchCol.equals("product_no")) { %>selected <% } %>>Product No</option>
                <option value="discount_no" <% if (searchCol.equals("discount_no")) { %>selected <% } %>>discount No</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit">검색</button>
        </div>

        <div class="sort-area">
        
        <label class="sort-label">정렬</label>
            <select name="col">
                <option value="product_no" <% if (col.equals("product_no")) { %>selected <% } %>>Product No</option>
                <option value="discount_no" <% if (col.equals("discount_no")) { %>selected <% } %>>Discount No</option>
                <option value="discount_rate" <% if (col.equals("discount_rate")) { %>selected <% } %>>Discount Rate</option>
                <option value="discount_start" <% if (col.equals("discount_start")) { %>selected <% } %>>Discount Start</option>
                <option value="createdate" <% if (col.equals("createdate")) { %>selected <% } %>>Createdate</option>
                <option value="updatedate" <% if (col.equals("updatedate")) { %>selected <% } %>>Updatedate</option>
            </select>
            <select name="ascDesc">
                <option value="ASC" <% if (ascDesc.equals("ASC")) { %>selected <% } %>>오름차순</option>
                <option value="DESC" <% if (ascDesc.equals("DESC")) { %>selected <% } %>>내림차순</option>
            </select>
            <button type="submit">정렬</button>
        </div> 
	</form>
    <div style="text-align: right; margin-top: 10px;">
        <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/adminAddDiscount.jsp" role="button">할인추가</a>&nbsp;&nbsp;
    </div>

    <form method="post" action="<%= request.getContextPath() %>/admin/removediscountAction.jsp"> 
        <table class="table">
        	<thead class="table-active">
	            <tr>
	                <th>선택</th>
	                <th>Discount No</th>
	                <th>Product No</th>
	                <th>Discount Rate</th>
	                <th>Start</th>
	                <th>End</th>
	                <th>Createdate</th>
	                <th>Updatedate</th>
	                <th>관리</th>
	            </tr>
            </thead>
            <% 
                for (Discount discount : discountList) { 
            %>
                <tr>
                    <td><input type="checkbox" name="selectedDiscount" value="<%= discount.getDiscountNo() %>"></td>
                    <td><%= discount.getDiscountNo() %></td>
                    <td><%= discount.getProductNo() %></td>
                    <td><%= discount.getDiscountRate() %></td>
                    <td><%= discount.getDiscountStart() %></td>
                    <td><%= discount.getDiscountEnd() %></td>
                    <td><%= discount.getCreatedate() %></td>
                    <td><%= discount.getUpdatedate() %></td>
                	<td><a href="<%= request.getContextPath() %>/admin/adminDiscountOne.jsp?discountNo=<%= discount.getDiscountNo() %>">관리</a></td>
                </tr>
            <% 
                } 
            %>
        </table>
		<button type="submit" class="btn btn-danger" formaction="<%= request.getContextPath() %>/admin/adminRemoveDiscountAction.jsp">삭제</button>
       	
		<nav class="pagination justify-content-center">
		    <ul class="pagination">
		        <% 
		        if (minPage > 1) {
		        %>
			        <li class="page-item">
			            <a class="page-link" href="<%=request.getContextPath()%>/admin/adminDiscountList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&startDate=<%=startDate%>&endDate=<%=endDate%>">이전</a>&nbsp;
			        </li>
		        <% 
		        }
		
		        for (int i = minPage; i <= maxPage; i++) {
		            if (i == currentPage) {
		        %>
				        <li class="page-item active">
				            <a class="page-link"><%=i%></a>
				        </li>
		        <% 
		            } else {
		        %>
				        <li class="page-item">
				            <a class="page-link" href="<%=request.getContextPath()%>/admin/adminDiscountList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&startDate=<%=startDate%>&endDate=<%=endDate%>"><%=i%></a>&nbsp;
				        </li>
		        <% 
		            }
		        }
		
		        if (maxPage < lastPage) {
		        %>
				        <li class="page-item">
				            <a class="page-link" href="<%=request.getContextPath()%>/admin/adminDiscountList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&startDate=<%=startDate%>&endDate=<%=endDate%>">다음</a>&nbsp;
				        </li>
		        <% 
		        }
		        %>
		    </ul>
		</nav>
	</form>
</body>
</html>