<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.*" %>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면 홈으로
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	//유효성검사
	if(request.getParameter("lastPw") == null
		|| request.getParameter("lastPw").equals("")) {
		response.sendRedirect(request.getContextPath() + "/customer/removeCustomer.jsp");
		return;
	}
	
	String loginId = session.getAttribute("loginIdListId").toString(); // 현재 로그인된 계정
	String inputPassword = request.getParameter("lastPw");	// 입력받은 패스워드
	
	IdList idList = new IdList();	// IdList 데이터 타입을 생성
	idList.setId(loginId);
	idList.setLastPw(inputPassword);
	
	System.out.println("[customerRemove Controller acess]");
	
	CustomerDao cDao = new CustomerDao();
	boolean pwCk = cDao.passwordCheck(idList);	// 패스워드 일치여부 확인 메소드
	
	if(pwCk) { // 비밀번호가 일치할 때
		System.out.println("회원탈퇴 성공 - 비밀번호 일치");
		cDao.updateIdListActive(idList); // active를 N으로 변경
		session.invalidate();	// 세션 지우기
		
		response.sendRedirect(request.getContextPath()+"/customer/myPage.jsp");
		return;
	} else { // 비밀번호 미일치
		System.out.println("회원탈퇴 실패 - 비밀번호 불일치");
		String msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/customer/removeCustomer.jsp?msg="+msg);
		return;
	}
%>