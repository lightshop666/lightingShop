<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.EmpDao" %> 
<%@ page import = "java.util.*" %> 
<%@ page import = "vo.*" %> 
        
<%
	request.setCharacterEncoding("UTF-8");
	
	EmpDao empDao = new EmpDao();
	
	String id = request.getParameter("id");
	String empName = request.getParameter("empName");
	String empPhone = request.getParameter("empPhone");
	String empLevel = request.getParameter("empLevel");
	
	Employees employee = new Employees();
	employee.setId(id);
	employee.setEmpName(empName);
	employee.setEmpPhone(empPhone);
	employee.setEmpLevel(empLevel);

	
	int row = empDao.insertEmp(employee);
	if(row == 1){
		System.out.println("추가성공");
	}else{
		System.out.println("추가실패");
		response.sendRedirect(request.getContextPath()+"/admin/addEmpInfo.jsp?id"+id);
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/adminEmpList.jsp");
	

%>