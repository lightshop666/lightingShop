<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.EmpDao" %> 
<%@ page import = "java.util.*" %> 
<%@ page import = "vo.*" %> 
<%@ page import="java.net.URLEncoder" %>
        
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

	String msg = null;	
	int row = empDao.insertId(idList);
	if(row == 1){
		System.out.println("추가성공");
	}else if(row==2){ //2일경우 addEmp페이지로 다시 보냄 /이미 해당 아이디가 emp테이블에 있음
		System.out.println("emp중복");
		 msg = URLEncoder.encode("해당 아이디로 등록된 직원이 있습니다", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp?msg="+msg);	
		return;
	}else if(row==3){//3일경우(id리스트에는 있는데 emp테이블에는 없는경우 empInfo 페이지로 보냄
		System.out.println("emp정보 추가필요");
		msg = URLEncoder.encode("직원정보를 추가해 주세요", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/admin/addEmpInfo.jsp?id="+id+"&msg="+msg);
		
		return;
	}else{
		System.out.println("추가실패");
		 msg = URLEncoder.encode("입력사항을 확인하세요", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp?msg="+msg);
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/addEmpInfo.jsp?id="+id);
	

%>