<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .menu {
        background-color: #333;
        color: #fff;
        padding: 10px;
    }

    .menu ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
    }

    .menu li {
        display: inline-block;
        margin-right: 10px;
    }

    .menu a {
        color: #fff;
        text-decoration: none;
    }
</style>

<div class="menu">
    <ul>
        <li><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminProductList.jsp">상품관리</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminEmpList.jsp">직원관리</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminCustomerList.jsp">회원관리</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminOrderList.jsp">주문관리</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminPointList.jsp">포인트관리</a></li>
        <li><a href="<%=request.getContextPath()%>/admin/adminDiscountList.jsp">할인율관리</a></li>
    </ul>
</div>