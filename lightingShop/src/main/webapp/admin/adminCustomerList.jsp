<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.Product" %>
<%
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

    // 상품 리스트 조회
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
<h1>Customer List</h1>
<!-- 검색영역 -->
<form action="<%= request.getContextPath() %>/admin/adminCustomerList.jsp?col=<%= col %>&ascDesc=<%= ascDesc %>"
      method="get">
    <div style="text-align: left; margin-top: 20px;">
        <h5>검색</h5>
        <select name="searchCol">
            <option value="cstm_name" <% if (searchCol.equals("cstm_name")) out.print("selected"); %>>Customer Name</option>
            <option value="id" <% if (searchCol.equals("id")) out.print("selected"); %>>ID</option>
        </select>
        <input type="text" name="searchWord" value="<%= searchWord %>">
        <button type="submit" class="btn btn-primary">검색</button>
    </div>

    <div style="text-align: left; margin-top: 10px;">
        <h5>정렬</h5>
        <select name="col">
            <option value="id" <% if (col.equals("id")) out.print("selected"); %>>ID</option>
            <option value="cstm_last_login" <% if (col.equals("cstm_last_login")) out.print("selected"); %>>Last Login</option>
            <option value="createdate" <% if (col.equals("createdate")) out.print("selected"); %>>Create Date</option>
        </select>
        <select name="ascDesc">
            <option value="ASC" <% if (ascDesc.equals("ASC")) out.print("selected"); %>>오름차순</option>
            <option value="DESC" <% if (ascDesc.equals("DESC")) out.print("selected"); %>>내림차순</option>
        </select>
        <button type="submit" class="btn btn-primary">정렬</button>
    </div>

</form>
<!-- 리스트 영역-->
<form method="post" action="<%= request.getContextPath() %>/admin/activeAction.jsp">

    <button type="submit" name="action" value="activate" class="btn btn-success">활성화</button>
    <button type="submit" name="action" value="deactivate" class="btn btn-danger">비활성화</button>
    <table class="table table-hover">
        <tr class="table-info">
            <th>선택</th>
            <th>id</th>
            <th>Name</th>
            <th>Last Login</th>
            <th>Active</th>
            <th>Created Date</th>
            <th>관리</th>
        </tr>
        <%
            for (HashMap<String, Object> c : customerList) {
        %>
        <tr class="table-active">
            <td><input type="checkbox" name="selectedProducts" value="<%=(String) c.get("id")%>"></td>
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
    </table>

    <div style="text-align:center;">
        <%
            if (minPage > 1) {
        %>
        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>">이전</a>&nbsp;
        <%
            }

            for (int i = minPage; i <= maxPage; i++) {
                if (i == currentPage) {
        %>
        <span style="background-color:yellow"><%=i%></span>
        <%
                } else {
        %>
        <a href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>"><%=i%></a>&nbsp;
        <%
                }
            }

            if (maxPage < lastPage) {
        %>
        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>">다음</a>&nbsp;
        <%
            }
        %>
    </div>
</form>
</body>
</html>