<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empDao = new EmpDao();
	//요청값 분석
    // 페이지 정보 가져오기 유효성 검사후 redirect
    System.out.println(request.getParameter("id"));
    
    if (request.getParameter("id") == null) {
       	response.sendRedirect(request.getContextPath()+"/admin/adminEmpList.jsp");
       	
       	return;
    }
    
	
    String id = request.getParameter("id");
    
    System.out.println(id);
    
    Employees employee = empDao.selectEmpOne(id);
   
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>직원 상세보기</title>
</head>
<body>
    <h1>직원 상세보기</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminModifyEmpAction.jsp?" method="post">
    	
    	<!--  수정하지 않는 컬럼에 경우 기존값으로 전달하기 위해 hidden으로  -->
	    <input type="hidden" name="id" value="<%=employee.getId()%>">
	    <input type="hidden" name="createdate" value="<%=employee.getCreatedate()%>">
	    <input type="hidden" name="updatedate" value="<%=employee.getUpdatedate()%>">
	    
	    <table class="table table-hover">
	        <tr>
	            <th class="table-info">ID</th>
	            <td><%=employee.getId()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">이름</th>
	            <td><input type="text" name="empName" value=<%=employee.getEmpName()%>></td>
	        </tr>
	        <tr>
	            <th class="table-info">등급</th>
	            <td>
	                <select name="empLevel">
	                    <option value="1" <%=employee.getEmpLevel().equals("1") ? "selected" : ""%>>1</option>
	                    <option value="3" <%=employee.getEmpLevel().equals("3") ? "selected" : ""%>>3</option>
	                    <option value="5" <%=employee.getEmpLevel().equals("5") ? "selected" : ""%>>5</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th class="table-info">번호</th>
	            <td><input type="text" name="empPhone" value=<%=employee.getEmpPhone()%>></td>
	        </tr>
	      	<tr>
	            <th class="table-info">생성날짜</th>
	            <td><%=employee.getCreatedate()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">업데이트날짜</th>
	            <td><%=employee.getUpdatedate()%></td>
	        </tr>  
	    </table>
	     <div style="text-align:left;">
	        <button type="submit" class="btn btn-dark">수정하기</button>
	    </div>
    </form>
</body>
</html>