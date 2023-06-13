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
    <title>상품 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }
        
        .container {
            width: 500px;
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th {
            background-color: #f8f8f8;
            color: #333;
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }
        
        td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        
        select,
        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            border-radius: 3px;
            border: 1px solid #ccc;
            outline: none;
        }
        
        textarea {
            height: 120px;
        }
        
        button {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>상품 등록</h1>
        
        <form action="<%=request.getContextPath()%>/admin/adminAddProductAction.jsp" method="post">
            <table>
                <tr>
                    <th>카테고리</th>
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
                    <th>상품명</th>
                    <td><input type="text" name="productName"></td>
                </tr>
                <tr>
                    <th>가격</th>
                    <td><input type="text" name="productPrice"></td>
                </tr>
                <tr>
                    <th>상태</th>
                    <td>
                        <select name="productStatus">
                            <option value="판매중">판매중</option>
                            <option value="예약판매">예약판매</option>
                            <option value="품절">품절</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>재고</th>
                    <td><input type="text" name="productStock"></td>
                </tr>
                <tr>
                    <th>상세정보</th>
                    <td><textarea name="productInfo"></textarea></td>
                </tr>
            </table>
            
            <button type="submit">상품 등록</button>
        </form>
    </div>
</body>
</html>