<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.Customer" %>
<%
    EmpDao empDao = new EmpDao();
    
    // 요청값 분석
    if(request.getParameter("empCk")!=null&request.getParameter("id")==null){ 
    	response.sendRedirect(request.getContextPath() + "/admin/adminEmpList.jsp");	
    	return;
    }else if(request.getParameter("id")==null){ 
    	response.sendRedirect(request.getContextPath() + "/admin/adminCustomerList.jsp");	
    	return;
    }
    
    //가져온 값들 확인하기
     System.out.println(request.getParameter("action"));
    //action 유효성검사(활성or비활성) 
    if(request.getParameter("action")==null){
    	response.sendRedirect(request.getContextPath()+"/admin/adminCustomerList.jsp");
    	return;
     }
    
    String action = request.getParameter("action");
    String active = null;
    if(action.equals("deactivate")){
    	active = "N";
    }else{
    	active = "Y";
    }
    
    //체크한 행의 id값들 다 가져오기
    //체크박스의 값을 배열로 받아오기 때문에 getParameterValues()를 사용
    String[] selectedProducts = request.getParameterValues("selectedProducts"); 

    System.out.println(selectedProducts);
    // 선택된 회원들을 비활성화 처리
    for (String id : selectedProducts) {
        
        empDao.activeCustomer(active,id);
    }
    
    //직원아이디인지 회원아이디에 대한 처리인지에 따라 성공시 sendRedirect 다르게 
    
    // 비활성화 처리 후 이동할 페이지로 redirect
    if(request.getParameter("empCk")!=null){ 
    	response.sendRedirect(request.getContextPath() + "/admin/adminEmpList.jsp");	
    	return;
    }
    response.sendRedirect(request.getContextPath() + "/admin/adminCustomerList.jsp");
%>
