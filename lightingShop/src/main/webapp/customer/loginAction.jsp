<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//	세션검사
	if (session.getAttribute("loginIdListId") != null) { // 회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	// 변수전달
	String id = request.getParameter("id");
	String lastPw = request.getParameter("lastPw");
	
	if (id.equals(null) || lastPw.equals(null)) {	// 로그인 ID, PW를 입력하지 않은 경우
		// 로그인 폼으로 리다이렉션
		response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
	}
	// 객체 파라미터로 넘겨줌
	IdList paramidList = new IdList();
	paramidList.setId(id);
	paramidList.setLastPw(lastPw);
	
	// 회원가입 메서드 실행
	CustomerDao cDao = new CustomerDao();
	IdList loginIdList = cDao.loginMethod(paramidList);
	
	//System.out.println(memberEmail + " " + memberPw); // 디버깅
	
	if (loginIdList != null && loginIdList.getActive().equals("Y")) { // 활성화가 되어있고 id와 pw 일치할경우
		// 로그인 정보를 Session에 저장
		session.setAttribute("loginIdListId", loginIdList.getId());	// 세션에 로그인 성공한 id_list id를 저장
		session.setAttribute("loginIdListLastPw", loginIdList.getLastPw());	// 세션에 로그인 성공한 id_list last_pw를 저장
		
		// 로그인 성공시 home.jsp로 이동
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListLastPw"));
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
	else {	// 로그인에 실패했을 경우
		if (loginIdList.getActive().equals("N")) {	// Y면 가입된 사용자, N이면 탈퇴한 사용자
			System.out.println("탈퇴된 사용자입니다.");
			response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
			
		} else {
			System.out.println("아이디 혹은 비밀번호가 틀렸습니다.\n다시 한 번 확인해주세요.");
			response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
		}
	}
	
%>  
