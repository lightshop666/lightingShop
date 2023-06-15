<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.Product" %>
<%
	/*세션검사
	if (!session.getAttribute("loginIdListEmpLevel").equals("3")) { // 직원레벨 5가 아니면
		String msg = "접근권환이 없습니다.";
		response.sendRedirect(request.getContextPath() + "/admin/home.jsp?msg="+msg);
		return;
	}
	*/	
    EmpDao empDao = new EmpDao();
    // 요청값 분석
    // 페이지 정보 가져오기
    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }

    // null이거나 공백일 경우 all로 변경 및 null값 자체도 공백으로 보내줘야 매개값으로 보내주는 과정에서 null로 인한 오류 발생 x

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

    // 회원 리스트 조회
    ArrayList<HashMap<String, Object>> customerList = empDao.selectCustomerListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord);

    // 전체 행 수
    int totalRow = empDao.selectCustomerCnt(searchCol, searchWord);
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
    <title>Customer List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
<br>
<h1>Customer List</h1>
<!-- 검색 영역 -->
<form action="<%= request.getContextPath() %>/admin/adminCustomerList.jsp?col=<%= col %>&ascDesc=<%= ascDesc %>" method="get">
    <div class="search-area" >
        <label class="search-label">검색</label>
        <select name="searchCol" class="search-input">
            <option value="cstm_name" <% if (searchCol.equals("cstm_name")) out.print("selected"); %>>Customer Name</option>
            <option value="id" <% if (searchCol.equals("id")) out.print("selected"); %>>ID</option>
        </select>
        <input type="text" name="searchWord" value="<%= searchWord %>" class="search-input">
        <button type="submit" class="search-button">검색</button>
    </div>

    <div class="sort-area">
        <label class="sort-label">정렬</label>
        <select name="col" class="sort-select">
            <option value="id" <% if (col.equals("id")) out.print("selected"); %>>ID</option>
            <option value="cstm_last_login" <% if (col.equals("cstm_last_login")) out.print("selected"); %>>Last Login</option>
            <option value="createdate" <% if (col.equals("createdate")) out.print("selected"); %>>Create Date</option>
        </select>
        <select name="ascDesc" class="sort-select">
            <option value="ASC" <% if (ascDesc.equals("ASC")) out.print("selected"); %>>오름차순</option>
            <option value="DESC" <% if (ascDesc.equals("DESC")) out.print("selected"); %>>내림차순</option>
        </select>
        <button type="submit" class="sort-button">정렬</button>
    </div>
    <br>
</form>
<!-- 리스트 영역 -->
<form method="post" action="<%= request.getContextPath() %>/admin/activeAction.jsp">
    <div>
	    <button type="submit" name="action" value="activate" class="btn btn-success">활성화</button>
	    <button type="submit" name="action" value="deactivate" class="btn btn-danger">비활성화</button>
	    </div>
    <table class="table">
        <thead class="table-active">
        <tr>
            <th>선택</th>
            <th>id</th>
            <th>Name</th>
            <th>Last Login</th>
            <th>Active</th>
            <th>Created Date</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (HashMap<String, Object> c : customerList) {
        %>
        <tr>
            <td><input type="checkbox" name="selectedRow" value="<%=(String) c.get("id")%>"></td>
            <td><%=(String) c.get("id")%></td>
            <td><%=(String) c.get("cstmName")%></td>
            <td><%=(String) c.get("cstmLastLogin")%></td>
            <td><%=(String) c.get("active")%></td>
            <td><%=(String) c.get("createdate")%></td>
            <td><a href="<%= request.getContextPath() %>/admin/adminCustomerOne.jsp?id=<%=(String) c.get("id")%>">관리</a></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <nav class="pagination justify-content-center">
	        <ul class="pagination">
	        <%
	            if (minPage > 1) {
	        %>
		        <li class="page-item">
		        	<a class="page-link" href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>" class="page-link">이전</a>
		        </li>
	        <%
	            }
	
	            for (int i = minPage; i <= maxPage; i++) {
	                if (i == currentPage) {
	        %>
	        	<li class="page-item active">
	                <a class="page-link" href="#"><%=i%></a>
	            </li>
	        <%
	                } else {
	        %>
	        	<li class="page-item">
	        			<a class="page-link" href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>" class="page-link"><%=i%></a>
	       		</li>
	        <%
	                }
	            }
	
	            if (maxPage < lastPage) {
	        %>
	        	<li class="page-item">
	        		<a  class="page-link" href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>" class="page-link">다음</a>
	        	</li>
	        <%
	            }
	        %>	
	        </ul>
      </nav>
</form>
</body>
</html>