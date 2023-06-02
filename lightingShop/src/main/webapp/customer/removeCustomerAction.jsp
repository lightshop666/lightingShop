<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면
		response.sendRedirect(request.getContextPath() + "/customer/removeCustomer.jsp");
		return;
	}
	

	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	String loginId = session.getAttribute("loginIdListId").toString(); // 현재 로그인된 계정
	String inputPassword = request.getParameter("password");	// 입력받은 패스워드
	
	IdList idList = new IdList();	// IdList 데이터 타입을 생성
	idList.setId(loginId);
	idList.setLastPw(inputPassword);
	
	CustomerDao passwordDao = new CustomerDao();
	IdList checkidList = passwordDao.passwordCheck(member);	// 패스워드 일치여부 확인 메소드
	
	System.out.println("나의 비밀번호: "+ checkMember.getMemberPw());
	System.out.println("확인해야될 비밀번호: "+ inputPassword);
	
	if (checkMember.getMemberPw().equals(inputPassword)) {	// 비밀번호가 일치할 때
		MemberDao memberDao = new MemberDao();
		memberDao.updateMemberSubscription(member);
		
		session.invalidate();	// 세션 지우기
%>