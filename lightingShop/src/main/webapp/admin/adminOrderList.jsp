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

    // null이거나 공백일 경우 all로 변경 및 null값 자체도 공백으로 보내줘야 매개값으로 보내주는 과정에서 null로 인한 오류 발생하지 않음

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
    
    // 배송 상태 정보 가져오기
    String deliveryStatus = request.getParameter("deliveryStatus");
    if (deliveryStatus == null) {
        deliveryStatus = "";
    }

    // 페이지당 행 수
    int rowPerPage = 10;

    // 시작 행 계산
    int beginRow = (currentPage - 1) * rowPerPage;

    // 주문 리스트 조회
    ArrayList<HashMap<String, Object>> orderList = empDao.selectOrdersListByPage(col, ascDesc, beginRow, rowPerPage, searchCol, searchWord, deliveryStatus);

    // 전체 행 수
    int totalRow = empDao.selectOrderCnt(searchCol, searchWord, deliveryStatus);
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
    <title>Order List</title>
</head>
<body>
    <h1>Order List</h1>

    <!-- 검색 조건 영역 -->
<!-- 검색 조건 영역 -->
    <form action="<%= request.getContextPath() %>/admin/adminOrderList.jsp">
        <div style="text-align: left; margin-top: 20px;">
            <h5>검색</h5>
            <select name="searchCol">
                <option value="order_product_no" <% if (searchCol.equals("order_product_no")) out.print("selected"); %>>주문번호(상품별)</option>
                <option value="order_no" <% if (searchCol.equals("order_no")) out.print("selected"); %>>주문번호(주문서별)</option>
                <option value="id" <% if (searchCol.equals("id")) out.print("selected"); %>>ID</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>

        <div style="text-align: left; margin-top: 10px;">
            <h5>정렬</h5>
            <select name="col">   
		        <option value="order_product_no" <% if (col.equals("order_product_no")) out.print("selected"); %>>주문번호</option>
		        <option value="id" <% if (col.equals("id")) out.print("selected"); %>>주문자</option>
		        <option value="createdate" <% if (col.equals("createdate")) out.print("selected"); %>>주문일자</option>
            </select>
            <select name="ascDesc">
                <option value="ASC" <% if (ascDesc.equals("ASC")) out.print("selected"); %>>오름차순</option>
                <option value="DESC" <% if (ascDesc.equals("DESC")) out.print("selected"); %>>내림차순</option>
            </select>
            <button type="submit" class="btn btn-primary">정렬</button>
         </div>
        <div>
		 <button type="submit" name="deliveryStatus" value="" class="btn btn-secondary">전체</button>
		 <button type="submit" name="deliveryStatus" value="주문확인중" class="btn btn-secondary">주문확인중</button>
		 <button type="submit" name="deliveryStatus" value="배송중" class="btn btn-secondary">배송중</button>
		 <button type="submit" name="deliveryStatus" value="배송시작" class="btn btn-secondary">배송시작</button>
		 <button type="submit" name="deliveryStatus" value="배송완료" class="btn btn-secondary">배송완료</button>
		 <button type="submit" name="deliveryStatus" value="취소중" class="btn btn-secondary">취소중</button>
		 <button type="submit" name="deliveryStatus" value="취소완료" class="btn btn-secondary">취소완료</button>
		 <button type="submit" name="deliveryStatus" value="교환중" class="btn btn-secondary">교환중</button>
		 <button type="submit" name="deliveryStatus" value="구매확정" class="btn btn-secondary">구매확정</button>       
 		</div>  
    </form>

        <table class="table table-hover">
            <tr class="table-info">
                <th>orderProductNo</th>
                <th>orderNo</th>
                <th>id</th>
                <th>deliveryStatus</th>
                <th>orderDate</th>
                <th>관리</th>
            </tr>
            <% 
                for (HashMap<String, Object> order : orderList) { 
            %>
                <tr class="table-active">
                    <td><%= order.get("orderProductNo") %></td>
                    <td><%= order.get("orderNo") %></td>
                    <td><%= order.get("id") %></td>
                    <td><%= order.get("deliveryStatus") %></td>
                    <td><%= order.get("createdate") %></td>
                    <td><a href="<%= request.getContextPath() %>/admin/adminOrderOne.jsp?orderProductNo=<%= order.get("orderProductNo") %>">관리</a></td>
                </tr>
            <% 
                } 
            %>
          </table> 
           <div style="text-align:center;">
		    <%
		    if (minPage > 1) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminOrderList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>">이전</a>&nbsp;
		    <%
		    }
		
		    for (int i = minPage; i <= maxPage; i++) {
		        if (i == currentPage) {
		    %>
		            <span style="background-color:yellow"><%=i%></span>
		    <%
		        } else {
		    %>
		            <a href="<%=request.getContextPath()%>/admin/adminOrderList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>"><%=i%></a>&nbsp;
		    <%
		        }
		    }
		
		    if (maxPage < lastPage) {
		    %>
		        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>">다음</a>&nbsp;
		    <%
		    }
		    %>
		</div>
</body>
</html>