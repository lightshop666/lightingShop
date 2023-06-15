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
    if (deliveryStatus == null
    		|| deliveryStatus.equals("전체")) {
  
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
    <title>Order List</title>
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
	<!--관리자 메인메뉴 -->
	<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
	<br>
	<!-- 본문 -->
    <h1>Order List</h1>

    <!-- 검색 조건 영역 -->

    <form action="<%= request.getContextPath() %>/admin/adminOrderList.jsp">
       <div class="search-area">
        
        <label class="search-label">검색</label>
            <select name="searchCol">
                <option value="order_product_no" <% if (searchCol.equals("order_product_no")) out.print("selected"); %>>주문번호(상품별)</option>
                <option value="order_no" <% if (searchCol.equals("order_no")) out.print("selected"); %>>주문번호(주문서별)</option>
                <option value="id" <% if (searchCol.equals("id")) out.print("selected"); %>>ID</option>
            </select>
            <input type="text" name="searchWord" value="<%= searchWord %>">
            <button type="submit" >검색</button>
        </div>

        <div class="sort-area">
        <label class="sort-label">정렬</label>
            <select name="col">   
		        <option value="order_product_no" <% if (col.equals("order_product_no")) out.print("selected"); %>>주문번호</option>
		        <option value="id" <% if (col.equals("id")) out.print("selected"); %>>주문자</option>
		        <option value="createdate" <% if (col.equals("createdate")) out.print("selected"); %>>주문일자</option>
            </select>
            <select name="ascDesc">
                <option value="ASC" <% if (ascDesc.equals("ASC")) out.print("selected"); %>>오름차순</option>
                <option value="DESC" <% if (ascDesc.equals("DESC")) out.print("selected"); %>>내림차순</option>
            </select>
            <button type="submit">정렬</button>
         </div>
      
	    <div align="center">
	        <% String[] deliveryArr = {"전체", "주문확인중", "배송중", "배송시작","배송완료","취소중","취소완료","교환중","구매확정"}; %>
	        <% 
	            for (String deliveryStatusCk : deliveryArr) { 
	        %>
	        	 <button type="submit" name="deliveryStatus" value="<%= deliveryStatusCk %>" class="btn btn-secondary" <% if (deliveryStatus.equals(deliveryStatusCk)) { %>style="background-color:yellow"<% } %>><%= deliveryStatusCk %></button>
	            
	        <% 
	            }
	        %>
	    </div>
	    <div>
	    	<input type="hidden" name="deliveryStatus" value="<%= deliveryStatus %>">
	    </div>
     </form>  

        <table class="table">
        	<thead class="table-active">
	            <tr >
	                <th>orderProductNo</th>
	                <th>orderNo</th>
	                <th>id</th>
	                <th>deliveryStatus</th>
	                <th>orderDate</th>
	                <th>관리</th>
	            </tr>
	        </thead>    
            <% 
                for (HashMap<String, Object> order : orderList) { 
            %>
                <tr>
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
           <nav class="pagination justify-content-center">
       		 <ul class="pagination">
			    <%
			    	if (minPage > 1) {
			    %>
				    <li class="page-item">
				        <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/admin/adminOrderList.jsp?currentPage=<%=minPage-pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>">이전</a>&nbsp;
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
			           		   <a class="page-link" href="<%=request.getContextPath()%>/admin/adminOrderList.jsp?currentPage=<%=i%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>"><%=i%></a>&nbsp;
			    			</li>
			    <%
			        	}
			    	}
			
			    	if (maxPage < lastPage) {
			    %>
				    	<li class="page-item">
				        	<a class="page-link" href="<%=request.getContextPath()%>/admin/adminProductList.jsp?currentPage=<%=minPage+pagePerPage%>&col=<%=col%>&ascDesc=<%=ascDesc%>&searchCol=<%=searchCol%>&searchWord=<%=searchWord%>&deliveryStatus=<%=deliveryStatus%>">다음</a>&nbsp;
			    		</li>
			    <%
			    	}
			    %>
	    </ul>
    </nav>	
</body>
</html>