<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="vo.Product" %>
<%
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

    // 카테고리 정보 가져오기
    String category = request.getParameter("category");
    if (category == null) {
        category = "All";
    }  

    // 페이지당 행 수
    int rowPerPage = 10;

    // 시작 행 계산
    int beginRow = (currentPage - 1) * rowPerPage;

    // 상품 리스트 조회
    ArrayList<Product> productList = empDao.selectProductListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord, category);

    // 전체 행 수
    int totalRow = empDao.selectProductCnt(searchCol, searchWord, category);
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
</head>
<body>
    <h1>Product List</h1>
    <!-- 검색 조건 영역 -->
    <form method="get" action="<%= request.getContextPath() %>/admin/adminProductList.jsp">
        <div class="search-area">
        
        <label class="search-label">검색</label>
            <select name="searchCol">
                <option value="product_name" <% if (searchCol.equals("product_name")) { %>selected <% } %>>Product Name</option>
                <option value="category_name" <% if (searchCol.equals("category_name")) { %>selected <% } %>>Category</option>
                <option value="product_status" <% if (searchCol.equals("product_status")) { %>selected <% } %>>Status</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit">검색</button>
        </div>

        <div class="sort-area">
        
        <label class="sort-label">정렬</label>
            <select name="col">
                <option value="product_no" <% if (col.equals("product_no")) { %>selected <% } %>>Product No</option>
                <option value="category_name" <% if (col.equals("category_name")) { %>selected <% } %>>Category</option>
                <option value="product_name" <% if (col.equals("product_name")) { %>selected <% } %>>Product Name</option>
                <option value="product_status" <% if (col.equals("product_status")) { %>selected <% } %>>Status</option>
                <option value="createdate" <% if (col.equals("createdate")) { %>selected <% } %>>Created Date</option>
                <option value="updatedate" <% if (col.equals("updatedate")) { %>selected <% } %>>Updated Date</option>
            </select>
            <select name="ascDesc">
                <option value="ASC" <% if (ascDesc.equals("ASC")) { %>selected <% } %>>오름차순</option>
                <option value="DESC" <% if (ascDesc.equals("DESC")) { %>selected <% } %>>내림차순</option>
            </select>
            <button type="submit">정렬</button>
        </div>
   

    <div align="center">
        <% String[] categories = {"All", "관리자", "무드등", "스탠드","실내조명","실외조명","파격세일","포인트조명"}; %>
        <% 
            for (String categoriCk : categories) { 
        %>
            <button type="submit" name="category" value="<%= categoriCk %>" class="btn btn-secondary" <% if (category.equals(categoriCk)) { %>style="background-color:yellow"<% } %>><%= categoriCk %></button>
        	
        <% 
            }
        %>
    </div>
    <input type="hidden" name="category" value="<%=category%>"> 
	</form>
    <div style="text-align: right; margin-top: 10px;">
        <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/adminAddProduct.jsp" role="button">상품추가</a>&nbsp;&nbsp;
    </div>

    <form method="post" action="<%= request.getContextPath() %>/removeProductAction.jsp"> <!-- remove구현안함 -->
        <table class="table">
        	<thead class="table-active">
	            <tr>
	                <th>선택</th>
	                <th>Product No</th>
	                <th>Category</th>
	                <th>Product Name</th>
	                <th>Status</th>
	                <th>Created Date</th>
	                <th>Updated Date</th>
	                <th>관리</th>
	            </tr>
            </thead>
            <% 
                for (Product product : productList) { 
            %>
                <tr>
                    <td><input type="checkbox" name="selectedProducts" value="<%= product.getProductNo() %>"></td>
                    <td><%= product.getProductNo() %></td>
                    <td><%= product.getCategoryName() %></td>
                    <td><%= product.getProductName() %></td>
                    <td><%= product.getProductStatus() %></td>
                    <td><%= product.getCreatedate() %></td>
                    <td><%= product.getUpdatedate() %></td>
                	<td><a href="<%= request.getContextPath() %>/admin/adminProductOne.jsp?productNo=<%= product.getProductNo() %>">관리</a></td>
                </tr>
            <% 
                } 
            %>
        </table>
		<button type="submit" class="btn btn-danger" formaction="<%= request.getContextPath() %>/removeProductAction.jsp">삭제</button>
       	
       	<nav class="pagination justify-content-center">
        <ul class="pagination">
		    <%
		    	if (minPage > 1) {
		    %>
		    	<li class="page-item">
		        	<a class="page-link" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>">이전</a>&nbsp;
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
		            <a class="page-link" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>"><%=i%></a>&nbsp;
		    	</li>
		    <%
		        }
		    }
		
		    if (maxPage < lastPage) {
		    %>
		    	<li class="page-item">
		        	<a class="page-link" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>">다음</a>&nbsp;
				</li>		    
		    <%
		    }
		    %>
		</ul>
    </nav>
	</form>

</body>
</html>