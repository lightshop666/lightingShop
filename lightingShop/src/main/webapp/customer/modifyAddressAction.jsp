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
	
	System.out.println(request.getParameter("addressName"));
	System.out.println(request.getParameter("address"));
	System.out.println(request.getParameter("addressNo"));
	System.out.println(request.getParameter("defaultAddress"));
	
	//유효성 검사 후 입력값이 맞지 않으면 배송지 목록으로 리디렉션
	if(request.getParameter("addressName") == null
		|| request.getParameter("address") == null
		|| request.getParameter("addressNo") == null
		|| request.getParameter("defaultAddress") == null
		|| request.getParameter("addressName").equals("")
		|| request.getParameter("address").equals("")
		|| request.getParameter("addressNo").equals("")
		|| request.getParameter("defaultAddress").equals("")) {
		System.out.println("[modifyAddressAction.jsp] : 유효성검사 실패");
		String noAddress = "noAddress";
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp?noAddress="+noAddress);
		return;
	}
		
	// 변수값 받아오기
	String id = (String)session.getAttribute("loginIdListId");
	String addressName = request.getParameter("addressName");
	String addressStr = request.getParameter("address");
	String defaultAddress = request.getParameter("defaultAddress");
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	
	// address에 set
	Address address = new Address();
	address.setId(id);
	address.setAddressNo(addressNo);
	address.setAddressName(addressName);
	address.setAddress(addressStr); 
	address.setDefaultAddress(defaultAddress);
	
	// Dao 호출
	CustomerDao cDao = new CustomerDao();
	
	// 주소지 중복체크
	boolean checkAddress = cDao.selectDefalutAddress(address);
	System.out.println("기본배송지 중복체크 true - 중복 --> :"+checkAddress);
	
	// 기본 배송지를 Y로 선택한 경우
	if(defaultAddress.equals("Y")) {
		if(checkAddress) { // 기본 배송지가 Y이며 중복일 경우 주소변경 페이지로 리다이렉션
			System.out.println("기본 배송지가 중복됩니다.");
			String overLapAddress = "overLapAddress";
			response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp?overLapAddress="+overLapAddress);
			return;
		}
		
	} else { // 기본 배송지가 N인경우
		// 배송지 수정
		int modifyAddress = cDao.modifyAddress(address);
		
		if(modifyAddress == 1) {
			System.out.println("배송지 수정 성공");
		} else { 
			System.out.println("배송지 수정 실패");
		} 
		response.sendRedirect(request.getContextPath()+"/customer/addressList.jsp");
	}
%>