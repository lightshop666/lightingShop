<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
/*세션검사
if (!session.getAttribute("loginIdListEmpLevel").equals("3")) { // 직원레벨 3가 아니면
	response.sendRedirect(request.getContextPath() + "/admin/home.jsp");
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
    
    // 포인트 인포 정보 가져오기
    String pointInfo = request.getParameter("pointInfo");
    if (pointInfo == null) {
    	pointInfo = "";
    }

    // 변환값 디버깅하기
    System.out.println("col: " + col);
    System.out.println("ascDesc: " + ascDesc);
    System.out.println("searchCol: " + searchCol);
    System.out.println("searchWord: " + searchWord);
    System.out.println("pointInfo: " + pointInfo);

    // 페이지당 행 수
    int rowPerPage = 10;

    // 시작 행 계산
    int beginRow = (currentPage - 1) * rowPerPage;

    // 포인트 리스트 조회
    ArrayList<HashMap<String, Object>> pointList = empDao.selectPointListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord, pointInfo);

    // 전체 행 수
    int totalRow = empDao.selectPointCnt(searchCol, searchWord, pointInfo);
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
    <title>Point List</title>
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
</head>
<body>
<!--관리자 메인메뉴 -->
<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
<br>
<!-- 본문 -->
<h1>Point List</h1>
<!-- 검색 영역 -->
<form action="<%= request.getContextPath() %>/admin/adminPointList.jsp?col=<%= col %>&ascDesc=<%= ascDesc %>"
      method="get">
<!--      
<script>
    function validateForm() {
        var checkboxes = document.querySelectorAll('input[type="checkbox"][name^="selectedPoint_"]');
        var checkedCount = 0;
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                checkedCount++;
            }
            if (checkedCount > 1) {
                alert("하나의 체크박스만 선택할 수 있습니다.");
                return false;
            }
        }
        return true;
    }
</script>
*/   -->    
    <div class="search-area" >
        <label class="search-label">검색</label>
        <select name="searchCol" class="search-input">
            <option value="point_no" <% if (searchCol.equals("point_no")) out.print("selected"); %>>Point No</option>
            <option value="order_no" <% if (searchCol.equals("order_no")) out.print("selected"); %>>Order No</option>
            <option value="id" <% if (searchCol.equals("id")) out.print("selected"); %>>ID</option>
        </select>
        <input type="text" name="searchWord" value="<%= searchWord %>" class="search-input">
        <button type="submit" class="search-button">검색</button>
    </div>

    <div class="sort-area">
        <label class="sort-label">정렬</label>
        <select name="col" class="sort-select">
            <option value="point_no" <% if (col.equals("point_no")) out.print("selected"); %>>Point No</option>
            <option value="createdate" <% if (col.equals("createdate")) out.print("selected"); %>>Create Date</option>
        </select>
        <select name="ascDesc" class="sort-select">
            <option value="ASC" <% if (ascDesc.equals("ASC")) out.print("selected"); %>>오름차순</option>
            <option value="DESC" <% if (ascDesc.equals("DESC")) out.print("selected"); %>>내림차순</option>
        </select>
        <button type="submit" class="sort-button">정렬</button>
    </div>
</form>
<!-- 리스트 영역 -->
<form method="post" action="<%= request.getContextPath() %>/admin/adminModifyPoint.jsp">
     <table class="table">
        <thead class="table-active">
        <tr>
            <th>Point No</th>
            <th>Order No</th>
            <th>ID</th>
            <th>PointInfo</th>
            <th>PointPm</th>
            <th>Point</th>
            <th>Created Date</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (HashMap<String, Object> p : pointList) {
        %>
        <tr>
            <td><%=(Integer) p.get("pointNo")%></td>
            <td><%=(Integer) p.get("orderNo")%></td>
            <td><%=(String) p.get("id")%></td>
            <td><%=(String) p.get("pointInfo")%></td>
            <td><%=(String) p.get("pointPm")%></td>
            <td><%=(Integer) p.get("point")%></td>
            <td><%=(String) p.get("createdate")%></td>
            <td>
                <a href="<%= request.getContextPath() %>/admin/adminModifyPoint.jsp?action=P&pointNo=<%=(Integer) p.get("pointNo")%>" class="btn btn-success">지급</a>
                <a href="<%= request.getContextPath() %>/admin/adminModifyPoint.jsp?action=M&pointNo=<%=(Integer) p.get("pointNo")%>" class="btn btn-danger">차감</a>
            </td>
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
		        	<a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminPointList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&pointInfo=<%=pointInfo%>" class="page-link">이전</a>
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
		        		<a href="<%=request.getContextPath()%>/admin/adminPointList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&pointInfo=<%=pointInfo%>" class="page-link"><%=i%></a>
       				</li>
        <%
                }
            }

            if (maxPage < lastPage) {
        %>
        		<li class="page-item">
        			<a class="page-link" href="<%=request.getContextPath()%>/admin/adminPointList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&pointInfo=<%=pointInfo%>" class="page-link">다음</a>
      			</li> 
        <%
            }
        %>
   	  	</ul>
    </nav>	
</form>
</body>
</html>