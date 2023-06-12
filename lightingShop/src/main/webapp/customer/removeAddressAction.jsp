<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 회원정보수정 폼 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//유효성 검사
	if(request.getParameter("addressNo") == null
		|| request.getParameter("addressNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
		return;
	}
	
	// 변수값 받아오기 & 배송지 삭제 메서드 호출
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	CustomerDao cDao = new CustomerDao();
	int removeAddress = cDao.removeAddress(addressNo);
	
	if(removeAddress == 1) {
		System.out.println("배송지 정보 삭제 성공");
	} else {
		System.out.println("배송지 정보 삭제 실패");
	}
	response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
%>