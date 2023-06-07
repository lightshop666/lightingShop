<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>    
<%
	request.setCharacterEncoding("UTF-8");
	EmpDao empDao = new EmpDao();

	//가져온 customer 정보값 디버깅하기
	System.out.println(request.getParameter("id")+"<--adminCustomer id");
	System.out.println(request.getParameter("rank")+"<--adminCustomer rank");
	
	int cstmPoint = 0;
	String cstmPointStr = request.getParameter("cstmPoint");
	if (cstmPointStr != null && !cstmPointStr.isEmpty()) {
	    cstmPoint = Integer.parseInt(cstmPointStr);
	} else {
	    // 예외 처리: cstmPoint 값이 없는 경우 기본값 설정
	    cstmPoint = 0; // 기본값으로 설정할 값
	}
	

    
	//가져온값들 Customer 에 맞는 객체 타입으로 변환
    String id = request.getParameter("id");
	String rank = request.getParameter("rank");

	
	//디버깅
	System.out.println(id);
	System.out.println(rank);
	System.out.println(cstmPointStr);
	
    
	
	//변환값들로 Customer 타입인 customer 객체에 정보 저장
	Customer customer = new Customer();
	customer.setId(id);
	customer.setCstmRank(rank);
	customer.setCstmPoint(cstmPoint);
	
	
	//updateCustomer 매소드를 통해 row값 반환받기
	int row =  empDao.updateCustomer(customer);
	//row값에 따라 분기하여 redirect
	if(row == 1){
		System.out.println("수정성공");
	}else{
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/admin/adminCustomerOne.jsp?id="+id);
		
		return;
	}
	response.sendRedirect(request.getContextPath()+"/admin/adminCustomerOne.jsp?id="+id);
%>