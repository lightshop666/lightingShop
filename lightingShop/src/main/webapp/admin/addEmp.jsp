<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%

   
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>직원 추가</title>
</head>
<body>
    <h1>직원 추가</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminAddEmpAction.jsp?" method="post">  		
	    <table class="table table-hover">
	        <tr>
	            <th class="table-info">ID</th>
	            <td><input type="text" name="id"></td>
	        </tr>
	        <tr>
	            <th class="table-info">Pw</th>
	            <td><input type="text" name="lastPw"></td>
	        </tr>
	        <tr>
	            <th class="table-info">ID Active</th>
	         	<td>   
		            <select name="active">
		                    <option value="Y">Y</option>
		                    <option value="N">N</option>
		            </select>
	 			</td>	       
	        </tr>
	    </table>    
	     <div style="text-align:left;">
	        <button type="submit" class="btn btn-dark">추가하기</button>
	    </div>
    </form>
</body>
</html>