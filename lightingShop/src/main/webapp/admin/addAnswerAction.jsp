<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>   
<%@ page import="vo.*" %>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	
	/* // 관리자인 경우에만 접근 허용
	if(session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListEmpLevel").equals("1") 
		|| session.getAttribute("loginIdListEmpLevel").equals("3")
		|| session.getAttribute("loginIdListEmpLevel").equals("5")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}  */
	
	// 유효성
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("aContent") == null
		|| request.getParameter("aContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/adminAnswer.jsp");
		return;
	}
	
	// 변수값 받기
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String id = (String)session.getAttribute("loginIdListId");
	String aContent = request.getParameter("aContent");
	
	// Answer 객체 생성 
	Answer answer = new Answer();
	answer.setqNo(qNo);
	answer.setId(id);
	answer.setaContent(aContent);
	// 객체 생성 및 메서드 호출
	EmpDao eDao = new EmpDao();
	int insertAnswer = eDao.insertAnswer(answer);
	
	if(insertAnswer == 1) {
		System.out.println("답변 입력 성공");
	} else {
		System.out.println("답변 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/addAnswer.jsp");
%>