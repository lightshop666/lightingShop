<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>    
<%
	request.setCharacterEncoding("UTF-8");
	EmpDao empDao = new EmpDao();

	//가져온 customer 정보값 디버깅하기
	System.out.println(request.getParameter("orderProductNo")+"<--adminOrder orderProductNo");
	System.out.println(request.getParameter("deliveryStatus")+"<--adminOrder deliveryStatus");
	

	//가져온값들 Customer 에 맞는 객체 타입으로 변환
    int orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
	String deliveryStatus = request.getParameter("deliveryStatus");

	
	//디버깅
	System.out.println(orderProductNo);
	System.out.println(deliveryStatus);
    	
		
	
	//updateCustomer 매소드를 통해 row값 반환받기
	int row =  empDao.updateOrder(deliveryStatus,orderProductNo);
	//row값에 따라 분기하여 redirect
	if(row == 1){
		System.out.println("수정성공");
	}else{
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/admin/adminOrderrOne.jsp?orderProductNo="+orderProductNo);
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/adminCustomerOne.jsp?orderProductNo="+orderProductNo);
%>