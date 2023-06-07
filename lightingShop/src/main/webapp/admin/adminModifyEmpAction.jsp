<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>    
<%
	request.setCharacterEncoding("UTF-8");
	EmpDao empDao = new EmpDao();
	
	//유효성검사
	
	if(request.getParameter("empLevel")==null
			||request.getParameter("empName")==null
			||request.getParameter("empPhone")==null){
		response.sendRedirect(request.getContextPath()+"/admin/adminEmpOne.jsp?id="+request.getParameter("id"));
       	
       	return;
	}
	//가져온 customer 정보값 디버깅하기
	System.out.println(request.getParameter("id")+"<--adminEmp id");
	System.out.println(request.getParameter("empLevel")+"<--adminEmp level");
	System.out.println(request.getParameter("empName")+"<--adminEmp Name");
	System.out.println(request.getParameter("empPhone")+"<--adminEmp phone");
	
	
	  
	//가져온값들 Customer 에 맞는 객체 타입으로 변환
    String id = request.getParameter("id");
    String empName = request.getParameter("empName");
	String empLevel = request.getParameter("empLevel");
	String empPhone = request.getParameter("empPhone");

	
	//디버깅
	System.out.println(id);
	System.out.println(empLevel);
	System.out.println(empPhone);
	System.out.println(empName);
	
    
	
	//변환값들로 Customer 타입인 customer 객체에 정보 저장
	Employees employee = new Employees();
	employee.setId(id);
	employee.setEmpLevel(empLevel);
	employee.setEmpPhone(empPhone);
	employee.setEmpName(empName);
	
	
	
	//updateCustomer 매소드를 통해 row값 반환받기
	int row =  empDao.updateEmp(employee);
	//row값에 따라 분기하여 redirect
	if(row == 1){
		System.out.println("수정성공");
	}else{
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/admin/adminEmpOne.jsp?id="+id);
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/adminEmpOne.jsp?id="+id);
%>