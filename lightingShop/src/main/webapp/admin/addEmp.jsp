<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원 추가</title>
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
    <h1>직원 추가</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminAddEmpAction.jsp" method="post">  		
	    <table>
	        <tr>
	            <th>ID</th>
	            <td><input type="text" name="id"></td>
	        </tr>
	        <tr>
	            <th>Pw</th>
	            <td><input type="text" name="lastPw"></td>
	        </tr>
	        <tr>
	            <th>ID Active</th>
	         	<td>   
		            <select name="active">
		                    <option value="Y">Y</option>
		                    <option value="N">N</option>
		            </select>
	 			</td>	       
	        </tr>
	    </table>    
	     <div style="text-align:left;">
	        <button type="submit">추가하기</button>
	    </div>
    </form>
</body>
</html>