<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empDao = new EmpDao();
	
    // 요청값 분석
    // 페이지 정보 가져오기 유효성 검사 후 리디렉트
    if (request.getParameter("orderProductNo") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminOrderList.jsp");
        return;
    }
    
    int orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
    
    // 주문 상세 정보 가져오기
    HashMap<String, Object> order = empDao.selectOrderOne(orderProductNo);
    
    // orderNo를 제외한 모든 항목 가져오기
    String createdate = (String) order.get("createdate");
    String id = (String) order.get("id");
    String orderAddress = (String) order.get("orderAddress");
    int productNo = (Integer) order.get("productNo");
    int productCnt = (Integer) order.get("productCnt");
    String deliveryStatus = (String) order.get("deliveryStatus");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 상세보기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f2f2f2;
        }

        h1 {
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 50%;
            margin-bottom: 20px;
            background-color: #ffffff;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #f2f2f2;
            color: #333;
            font-weight: bold;
        }

        select, input[type="text"] {
            padding: 5px;
            width: 100px;
        }

        button[type="submit"] {
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        .table-info {
            background-color: #f2f2f2;
            color: #333;
            font-weight: bold;
        }
    </style>
</head>
<body>
	<!--관리자 메인메뉴 -->
	<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
	<br>
	<!-- 본문 -->
    <h1>주문 상세보기</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminModifyOrderAction.jsp" method="post">
        <!-- 수정하지 않는 컬럼에 대한 기존값 전달을 위해 hidden으로 설정 -->
        <input type="hidden" name="orderProductNo" value="<%=orderProductNo%>">
        <input type="hidden" name="createdate" value="<%=createdate%>">
        <input type="hidden" name="id" value="<%=id%>">
        <input type="hidden" name="orderAddress" value="<%=orderAddress%>">
        <input type="hidden" name="productNo" value="<%=productNo%>">
        <input type="hidden" name="productCnt" value="<%=productCnt%>">
        
        <table>
            <tr>
                <th class="table-info">주문 날짜</th>
                <td><%=createdate%></td>
            </tr>
            <tr>
                <th class="table-info">주문자 ID</th>
                <td><%=id%></td>
            </tr>
            <tr>
                <th class="table-info">주문 주소</th>
                <td><%=orderAddress%></td>
            </tr>
            <tr>
                <th class="table-info">주문 상품 번호</th>
                <td><%=orderProductNo%></td>
            </tr>
            <tr>
                <th class="table-info">상품 번호</th>
                <td><%=productNo%></td>
            </tr>
            <tr>
                <th class="table-info">상품 수량</th>
                <td><%=productCnt%></td>
            </tr>
            <tr>
                <th class="table-info">배송 상태</th>
                <td>
                    <select name="deliveryStatus">
                        <option value="주문확인중" <%=deliveryStatus.equals("주문확인중") ? "selected" : ""%>>주문확인중</option>
                        <option value="배송중" <%=deliveryStatus.equals("배송중") ? "selected" : ""%>>배송중</option>
                        <option value="배송시작" <%=deliveryStatus.equals("배송시작") ? "selected" : ""%>>배송시작</option>
                        <option value="배송완료" <%=deliveryStatus.equals("배송완료") ? "selected" : ""%>>배송완료</option>
                        <option value="취소중" <%=deliveryStatus.equals("취소중") ? "selected" : ""%>>취소중</option>
                        <option value="취소완료" <%=deliveryStatus.equals("취소완료") ? "selected" : ""%>>취소완료</option>
                        <option value="교환중" <%=deliveryStatus.equals("교환중") ? "selected" : ""%>>교환중</option>
                        <option value="구매확정" <%=deliveryStatus.equals("구매확정") ? "selected" : ""%>>구매확정</option>
                    </select>
                </td>
            </tr>
        </table>
        
        <div style="text-align: left;">
            <button type="submit" class="btn btn-dark">수정하기</button>
        </div>
    </form>
</body>
</html>