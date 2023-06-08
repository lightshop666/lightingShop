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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>Product List</title>
</head>
<body>
    <h1>Product List</h1>
    <!-- 검색 조건 영역 -->
    <form method="get" action="<%= request.getContextPath() %>/admin/adminProductList.jsp">
        <div style="text-align: left; margin-top: 20px;">
        
        <h5>검색</h5>
            <select name="searchCol">
                <option value="product_name" <% if (searchCol.equals("product_name")) { %>selected <% } %>>Product Name</option>
                <option value="category_name" <% if (searchCol.equals("category_name")) { %>selected <% } %>>Category</option>
                <option value="product_status" <% if (searchCol.equals("product_status")) { %>selected <% } %>>Status</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>

        <div style="text-align: left; margin-top: 10px;">
        
        <h5>정렬</h5>
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
            <button type="submit" class="btn btn-primary">정렬</button>
        </div>
    </form>

    <div style="text-align: left; margin-top: 10px;">
        <% String[] categories = {"All", "관리자", "무드등", "스탠드","실내조명","실외조명","파격세일","포인트조명"}; %>
        <% 
            for (String categoriCk : categories) { 
        %>
            <a class="btn btn-secondary" href="<%= request.getContextPath() %>/admin/adminProductList.jsp?currentPage=1&col=<%= col %>&ascDesc=<%= ascDesc %>&searchCol=<%= searchCol %>&searchWord=<%= searchWord %>&category=<%= categoriCk %>"
                <% if (category.equals(categoriCk)) { %>style="background-color:yellow"<% } %>>
                <%= categoriCk %>
            </a>
        <% 
            }
        %>
    </div>

    <div style="text-align: right; margin-top: 10px;">
        <a class="btn btn-dark" href="<%= request.getContextPath() %>/adminAddProduct.jsp" role="button">상품추가</a>&nbsp;&nbsp;
    </div>

    <form method="post" action="<%= request.getContextPath() %>/removeProductAction.jsp">
        <table class="table table-hover">
            <tr class="table-info">
                <th>선택</th>
                <th>Product No</th>
                <th>Category</th>
                <th>Product Name</th>
                <th>Status</th>
                <th>Created Date</th>
                <th>Updated Date</th>
                <th>관리</th>
            </tr>
            <% 
                for (Product product : productList) { 
            %>
                <tr class="table-active">
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
       <div style="text-align:center;">
		    <%
		    if (minPage > 1) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>">이전</a>&nbsp;
		    <%
		    }
		
		    for (int i = minPage; i <= maxPage; i++) {
		        if (i == currentPage) {
		    %>
		            <span style="background-color:yellow"><%=i%></span>
		    <%
		        } else {
		    %>
		            <a href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>"><%=i%></a>&nbsp;
		    <%
		        }
		    }
		
		    if (maxPage < lastPage) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&category=<%=category%>">다음</a>&nbsp;
		    <%
		    }
		    %>
		</div>
	</form>

</body>
</html>