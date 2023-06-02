<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	// 세션종료
	session.invalidate();
	String msg = URLEncoder.encode("로그아웃 되었습니다","utf-8");
	response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	
%>