<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>
<%@page import="vo.*"%>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 회원정보수정 폼 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//유효성 검사 후 입력값이 맞지 않으면 회원가입 페이지로 리디렉션
	if(request.getParameter("addressName") == null
		|| request.getParameter("address") == null
		|| request.getParameter("addressNo") == null
		|| request.getParameter("addressName").equals("")
		|| request.getParameter("address").equals("")
		|| request.getParameter("addressNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/modifyAddress.jsp");
		return;
	}
		
	// 변수값 받아오기
	String addressName = request.getParameter("addressName");
	String addressStr = request.getParameter("address");
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	
	// address에 set
	Address address = new Address();
	address.setAddressNo(addressNo);
	address.setAddressName(addressName);
	address.setAddress(addressStr);
	
	// 주소변경 메서드 실행
	CustomerDao cDao = new CustomerDao();
	int modifyAddress = cDao.modifyAddress(address);
	
	if(modifyAddress == 1) {
		System.out.println("배송지 수정 성공");
		// 수정성공시 배송지리스트로 이동
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
		return;
	} else { // 실패시 수정폼으로
		System.out.println("배송지 수정 실패");
		response.sendRedirect(request.getContextPath()+"/customer/modifyAddress.jsp");
	}
%>