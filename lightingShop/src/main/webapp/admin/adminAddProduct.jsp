<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 카테고리 배열 만들어주기
	String[] categoryNames = {"관리자", "무드등", "스탠드", "실내조명", "실외조명", "파격세일", "포인트조명"};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>상품 등록</title>
</head>
<body>
  <form action="<%=request.getContextPath()%>/admin/addProductAction.jsp?" method="post">
    <h1>상품 등록</h1>     	
	    <table class="table table-hover">			      
            <tr>
                <th class="table-info">카테고리</th>
                <td>
                    <select name="categoryName">
                    
                        <% 
                        	for (String category : categoryNames) { 
            
                        %>
                            <option value="<%=category%>"> <%=category%></option>
                        <% 
   
                        	} 
                       	
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="table-info">상품명</th>
                <td><input type="text" name="productName"></td>
            </tr>
            <tr>
                <th class="table-info">가격</th>
                <td><input type="text" name="productPrice"></td>
            </tr>
            <tr>
                <th class="table-info">상태</th>
                <td>
                    <select name="productStatus">
                        <option value="판매중">판매중</option>
                        <option value="예약판매">예약판매</option>
                        <option value="품절">품절</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="table-info">재고</th>
                <td><input type="text" name="productStock"></td>
            </tr>
            <tr>
                <th class="table-info">상세정보</th>
                <td><textarea name="productInfo"></textarea></td>
            </tr>
        </table>
        
         <button type="submit" class="btn btn-dark">수정하기</button>
    </form>
</body>
</html>