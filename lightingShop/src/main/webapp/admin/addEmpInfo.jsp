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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>직원정보 등록</title>
</head>
<body>
    <h1>직원정보 등록</h1>
    
    <form action="<%=request.getContextPath()%>/admin/addEmpInfoAction.jsp?" method="post">
       	
	    <table class="table table-hover">
	        <tr>
	            <th class="table-info">ID</th>
	            <td><input type="text" name="id" value="<%=id%>" readonly="readonly"></td>
	        </tr>
	        <tr>
	            <th class="table-info">이름</th>
	            <td><input type="text" name="empName"></td>
	        </tr>
	        <tr>
	            <th class="table-info">등급</th>
	            <td>
	                <select name="empLevel">
	                    <option value="1" >1</option>
	                    <option value="3" >3</option>
	                    <option value="5" >5</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th class="table-info">번호</th>
	            <td><input type="text" name="empPhone"></td>
	        </tr> 
	    </table>
	     <div style="text-align:left;">
	        <button type="submit" class="btn btn-dark">저장하기</button>
	    </div>
    </form>
</body>
</html>