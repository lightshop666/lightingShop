<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");

	// session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사 후 입력값이 맞지 않으면 회원가입 페이지로 리디렉션
	if(request.getParameter("id") == null
		|| request.getParameter("lastPw") == null
		|| request.getParameter("cstmName") == null
		|| request.getParameter("cstmAddress") == null
		|| request.getParameter("cstmEmail") == null
		|| request.getParameter("cstmBirth") == null
		|| request.getParameter("cstmPhone") == null
		|| request.getParameter("cstmGender") == null
		|| request.getParameter("cstmAgree") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("lastPw").equals("")
		|| request.getParameter("cstmName").equals("")
		|| request.getParameter("cstmAddress").equals("")
		|| request.getParameter("cstmEmail").equals("")
		|| request.getParameter("cstmBirth").equals("")
		|| request.getParameter("cstmPhone").equals("")
		|| request.getParameter("cstmGender").equals("")
		|| request.getParameter("cstmAgree").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/addCustomerAction.jsp");
		return;
	}
	
	// 변수값 받아오기
	String id = request.getParameter("id");
	String lastPw = request.getParameter("lastPw");
	String cstmName = request.getParameter("cstmName");
	String cstmAddress = request.getParameter("cstmAddress");
	String cstmEmail = request.getParameter("cstmEmail");
	String cstmBirth = request.getParameter("cstmBirth");
	String cstmPhone = request.getParameter("cstmPhone");
	String cstmGender = request.getParameter("cstmGender");
	String cstmAgree = request.getParameter("cstmAgree");
	
	// 사용가능한 이메일 검증
	CustomerDao customerDao = new CustomerDao();
	IdList idList = customerDao.selectCustomerIdCk(id);
	
	if(idList != null) { // 중복된 id가 있는 경우 로그인 페이지로 리다이렉션
		response.sendRedirect(request.getContextPath()+"/customer/login.jsp");
		return;
	}
	
	// idList에 set
	IdList paramIdList = new IdList();
	paramIdList.setId(id);
	paramIdList.setLastPw(lastPw);
	
	// id_list에 id, pw 추가
	int result = customerDao.addIdList(paramIdList);
	
	// id리스트에 입력된 값이 있을시
	if(result > 0) {
	// customer에 set
	Customer paramCustomer = new Customer();
	paramCustomer.setId(id);
	paramCustomer.setCstmName(cstmName);
	paramCustomer.setCstmAddress(cstmAddress);
	paramCustomer.setCstmEmail(cstmEmail);
	paramCustomer.setCstmBirth(cstmBirth);
	paramCustomer.setCstmPhone(cstmPhone);
	paramCustomer.setCstmGender(cstmGender);
	paramCustomer.setCstmAgree(cstmAgree);
	
	// customer에 회원입력정보 추가
	int result2 = customerDao.addCustomer(paramCustomer);
	
	// pw_history에 set
	PwHistory paramPwHistory = new PwHistory();
	paramPwHistory.setId(id);
	paramPwHistory.setPw(lastPw);
	
	// pw_history에 id, pw 추가
	int result3 = customerDao.addPwHistory(paramPwHistory);
	
	System.out.println("회원가입 성공");
	response.sendRedirect(request.getContextPath()+"/customer/myPage.jsp");
	} else { // DB에 값이 입력되지 않은 경우
	System.out.println("회원가입 실패");
	response.sendRedirect(request.getContextPath()+"/customer/addCustomer.jsp");
	}
%>   