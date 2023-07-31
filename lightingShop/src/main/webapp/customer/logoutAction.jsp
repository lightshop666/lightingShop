<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	//session 유효성 검사 -> 로그인 되지 않은 경우 홈으로
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 세션종료
	session.invalidate();
	String msg = URLEncoder.encode("로그아웃 되었습니다","utf-8");
	response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
%>