<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*"%>
<%@ page import = "java.net.*" %>
<%
	// 유효성 검사
	// qNo 
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	// inputPw
	String msg = null;
	if(request.getParameter("inputPw") == null
			|| request.getParameter("inputPw").equals("")) {
		msg = URLEncoder.encode("비밀번호를 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/inputPassword.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	}
	String inputPw = request.getParameter("inputPw");
	
	// 메서드 호출
	BoardDao dao = new BoardDao();
	boolean pwChk = dao.questionOnePwChk(qNo, inputPw);
	
	// 리다이렉션
	if(pwChk == true) {
		response.sendRedirect(request.getContextPath() + "/board/questionOne.jsp?qNo=" + qNo);
		return;
	} else {
		msg = URLEncoder.encode("비밀번호가 일치하지 않습니다!", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/inputPassword.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	}
%>