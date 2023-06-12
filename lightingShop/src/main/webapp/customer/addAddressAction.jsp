<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<%
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");

	// session 유효성 검사 -> 로그인되지 않은경우 홈으로
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//유효성 검사 
	if(request.getParameter("address") == null
		|| request.getParameter("addressName") == null
		|| request.getParameter("address").equals("")
		|| request.getParameter("addressName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/addAddress.jsp");
		return;
	}
	
	// 변수값 받아오기
	String id = (String)session.getAttribute("loginIdListId");
	String addressStr = request.getParameter("address");
	String addressName = request.getParameter("addressName");
	
	// address에 set
	Address address = new Address();
	address.setId(id);
	address.setAddressName(addressName);
	address.setAddress(addressStr); 
	
	// 주소추가 메서드 
	CustomerDao cDao = new CustomerDao();
	int addMyAddress = cDao.addMyAddress(address);
	
	if(addMyAddress == 1) {
		System.out.println("배송지 추가 성공");
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
		return;
	} else {
		System.out.println("배송지 추가 실패");
		response.sendRedirect(request.getContextPath()+"/customer/addCustomer.jsp");
	}
%>   
