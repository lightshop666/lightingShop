<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empDao = new EmpDao();
    // 요청값 분석
    // 페이지 정보 가져오기
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

    // 변환값 디버깅하기
    System.out.println("col: " + col);
    System.out.println("ascDesc: " + ascDesc);
    System.out.println("searchCol: " + searchCol);
    System.out.println("searchWord: " + searchWord);

    // 페이지당 행 수
    int rowPerPage = 10;

    // 시작 행 계산
    int beginRow = (currentPage - 1) * rowPerPage;

    // 상품 리스트 조회
    ArrayList<HashMap<String, Object>> empList = empDao.selectEmpListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord);

    // 전체 행 수
    int totalRow = empDao.selectEmpCnt(searchCol, searchWord);
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
    
    <h1>Emp List</h1>
    <!-- 검색조건영역 -->
    <form action="<%= request.getContextPath() %>/admin/adminEmpList.jsp">     
        
        <div style="text-align: left; margin-top: 20px;">
            <h5>검색</h5>
            <select name="searchCol">
                <option value="emp_name" <%= searchCol.equals("emp_name") ? "selected" : "" %>>Emp Name</option>
                <option value="id" <%= searchCol.equals("id") ? "selected" : "" %>>ID</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>

        <div style="text-align: left; margin-top: 10px;">
            <h5>정렬</h5>
            <select name="col">
                <option value="id" <%= col.equals("id") ? "selected" : "" %>>id</option>
                <option value="emp_level" <%= col.equals("emp_level") ? "selected" : "" %>>level</option>
                <option value="createdate" <%= col.equals("createdate") ? "selected" : "" %>>Createdate</option>      
            </select>
            <select name="ascDesc">
                <option value="ASC" <%= ascDesc.equals("ASC") ? "selected" : "" %>>오름차순</option>
                <option value="DESC" <%= ascDesc.equals("DESC") ? "selected" : "" %>>내림차순</option>
            </select>
            <button type="submit" class="btn btn-primary">정렬</button>
        </div>
    </form>
    
     <!-- 리스트 목록 영역 -->
    <form method="post" action="<%= request.getContextPath() %>/admin/activeAction.jsp">
          <input type="hidden" name="empCk" value="empCk"> <!-- 어느 페이지에서의 activeAction인지 구분하기 위해 임의로 저장 -->
          <button type="submit" name="action" value="activate" class="btn btn-success">활성화</button>
          <button type="submit" name="action" value="deactivate" class="btn btn-danger">비활성화</button>
        <table class="table table-hover">
            <tr class="table-info">
                <th>선택</th>
                <th>id</th>
                <th>Name</th>
                <th>Pw</th>
                <th>active</th>
                <td>level</td>
                <th>Createdate</th>
                <th>Updatedate</th>
                <th>관리</th>
            </tr>
            <% 
            	for (HashMap<String, Object> e : empList) { 
            %>
                <tr class="table-active">
                    <td><input type="checkbox" name="selectedProducts" value="<%=(String)e.get("id")%>"></td>
                   	<td><%=(String)e.get("id")%></td>
					<td><%=(String)e.get("empName")%></td>
					<td><%=(String)e.get("lastPw")%></td>
					<td><%=(String)e.get("active")%></td>
					<td><%=(String)e.get("empLevel")%></td>
					<td><%=(String)e.get("createdate")%></td>
					<td><%=(String)e.get("updatedate")%></td>
					<td><a href="<%= request.getContextPath() %>/admin/adminEmpOne.jsp?id=<%=(String)e.get("id")%>">관리</a></td>
                </tr>
            <% 
            	} 
            %>
        </table>
        
         <div style="text-align: right; margin-top: 10px;">
    	  	<a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/addEmp.jsp" role="button">직원추가</a>&nbsp;&nbsp;    
    	 </div>
		
       <div style="text-align:center;">
		    <%
		    if (minPage > 1) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminEmpList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>">이전</a>&nbsp;
		    <%
		    }
		
		    for (int i = minPage; i <= maxPage; i++) {
		        if (i == currentPage) {
		    %>
		            <span style="background-color:yellow"><%=i%></span>
		    <%
		        } else {
		    %>
		            <a href="<%=request.getContextPath()%>/admin/adminEmpList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>"><%=i%></a>&nbsp;
		    <%
		        }
		    }
		
		    if (maxPage < lastPage) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminEmpList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>">다음</a>&nbsp;
		    <%
		    }
		    %>
		</div>
</form>	
</body>
</html>