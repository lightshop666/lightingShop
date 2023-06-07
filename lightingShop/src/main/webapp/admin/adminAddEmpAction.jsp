<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.EmpDao" %> 
<%@ page import = "java.util.*" %> 
<%@ page import = "vo.*" %> 
        
<%
	request.setCharacterEncoding("UTF-8");
	
	EmpDao empDao = new EmpDao();
	
	String id = request.getParameter("id");
	String lastPw = request.getParameter("lastPw");
	String active = request.getParameter("active");
	
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	idList.setActive(active);

	
	int row = empDao.insertId(idList);
	if(row == 1){
		System.out.println("추가성공");
	}else if(row==2){ //2일경우 addEmp페이지로 다시 보냄 /이미 해당 아이디가 emp테이블에 있음
		System.out.println("emp중복");
		response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp");	
		return;
	}else if(row==3){//3일경우(id리스트에는 있는데 emp테이블에는 없는경우 empInfo 페이지로 보냄
		System.out.println("emp정보 추가필요");
		response.sendRedirect(request.getContextPath()+"/admin/addEmpInfo.jsp?id="+id);
		
		return;
	}else{
		System.out.println("추가실패");
		response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp");
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/addEmpInfo.jsp?id="+id);
	

%>