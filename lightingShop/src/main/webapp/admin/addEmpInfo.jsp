<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//id 유효성 검사 및 디버깅
	System.out.println(request.getParameter("id")+"<--addEmp id");
	if (request.getParameter("id") == null) {
	   	response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp");
	   	
	   	return;
	}	
	String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원정보 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        
        h1 {
            text-align: center;
            margin-top: 30px;
        }
        
        form {
            margin: 20px auto;
            max-width: 500px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }
        
        table {
            width: 100%;
        }
        
        th {
            background-color: #eee;
            padding: 10px;
            text-align: left;
        }
        
        td {
            padding: 10px;
        }
        
        select {
            width: 100%;
            padding: 5px;
            border-radius: 3px;
            border: 1px solid #ccc;
        }
        
        button {
            background-color: #343a40;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #23272b;
        }
    </style>
</head>
<body>
    <h1>직원정보 등록</h1>
    
    <form action="<%=request.getContextPath()%>/admin/addEmpInfoAction.jsp" method="post">
       	
	    <table>
	        <tr>
	            <th>ID</th>
	            <td><input type="text" name="id" value="<%=id%>" readonly="readonly"></td>
	        </tr>
	        <tr>
	            <th>이름</th>
	            <td><input type="text" name="empName"></td>
	        </tr>
	        <tr>
	            <th>등급</th>
	            <td>
	                <select name="empLevel">
	                    <option value="1">1</option>
	                    <option value="3">3</option>
	                    <option value="5">5</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th>번호</th>
	            <td><input type="text" name="empPhone"></td>
	        </tr> 
	    </table>
	     <div style="text-align:center">
	        <button type="submit">저장하기</button>
	    </div>
    </form>
</body>
</html>