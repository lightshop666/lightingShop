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
	
	System.out.println(request.getParameter("sample3Postcode"));
	System.out.println(request.getParameter("sample3Address"));
	System.out.println(request.getParameter("sample3DetailAddress"));
	// System.out.println(request.getParameter("address"));
	System.out.println(request.getParameter("addressName"));
	System.out.println(request.getParameter("defaultAddress"));
	
	//유효성 검사 
	if(// request.getParameter("address") == null
		  request.getParameter("sample3Postcode") == null
		|| request.getParameter("sample3Address") == null
		|| request.getParameter("sample3DetailAddress") == null
		|| request.getParameter("addressName") == null
		|| request.getParameter("defaultAddress") == null
		// || request.getParameter("address").equals("")
		|| request.getParameter("sample3Postcode").equals("")
		|| request.getParameter("sample3Address").equals("")
		|| request.getParameter("sample3DetailAddress").equals("")
		|| request.getParameter("addressName").equals("")
		|| request.getParameter("defaultAddress").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/addAddress.jsp");
		return;
	}
	
	// 변수값 받아오기
	String sample3Postcode = request.getParameter("sample3Postcode");
	String sample3Address = request.getParameter("sample3Address");
	String sample3DetailAddress = request.getParameter("sample3DetailAddress");

	
	String id = (String)session.getAttribute("loginIdListId");
	String addressStr = "("+sample3Postcode+")" + " " + sample3Address + " " + sample3DetailAddress;
	String addressName = request.getParameter("addressName");
	String defaultAddress = request.getParameter("defaultAddress");
	
	System.out.println(addressStr+"<-- 입력받은 주소값");
	
	// address에 set
	Address address = new Address();
	address.setId(id);
	address.setAddressName(addressName);
	address.setAddress(addressStr); 
	address.setDefaultAddress(defaultAddress) ; 
	
	// Dao 호출
	CustomerDao cDao = new CustomerDao();
	boolean checkAddress = cDao.selectDefalutAddress(address);
	System.out.println("기본배송지 중복체크 true - 중복 --> :"+checkAddress);
	
	if(checkAddress) { // 중복일 경우 주소추가로 리다이렉션
		System.out.println("기본 배송지가 중복됩니다.\n 기본 배송지를 해제하고 다시 추가해주세요.");
		String msg = "overLapAddress";
		response.sendRedirect(request.getContextPath()+"/customer/addAddress.jsp?msg="+msg);
		return;
	} else { // 중복이 아닐경우 배송지 추가 진행
		System.out.println("배송지추가 성공");
		// 배송지가 4개 이상일 경우 가장 오래된 내역 삭제후 배송지 추가 
		int operateAddress = cDao.operateAddress(address);
	
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
	}
%>   
