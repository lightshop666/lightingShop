<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>   
<%@ page import="vo.*" %>

<%
	System.out.println(request.getParameter("selectedQuestion"));
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
	if(request.getParameter("selectedQuestion") == null
		|| request.getParameter("selectedQuestion").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/adminQuestionList.jsp");
		return;
	}
	
	// 체크한 행의 qNo값들 다 받아오기
	// 문자열 배열을 하나씩 정수형 배열로 변환
	String[] strSelectedQuestion = request.getParameterValues("selectedQuestion");
	int[] intSelectedQuestion = new int[strSelectedQuestion.length];
	for (int i = 0; i < strSelectedQuestion.length; i++) {
		intSelectedQuestion[i] = Integer.parseInt(strSelectedQuestion[i]);
	}
	
	System.out.println(intSelectedQuestion);
	
	// Dao 호출
	EmpDao eDao = new EmpDao();
	
	 // 선택된 게시글을 삭제 처리
    for (int qNo : intSelectedQuestion) {
    	
    	int removeQuestion = eDao.removeQuestion(qNo);
    
		if(removeQuestion == 1) {
			System.out.println("문의 삭제 성공");
		} else {
			System.out.println("문의 삭제 실패");
		}
    }
	response.sendRedirect(request.getContextPath()+"/admin/adminQuestionList.jsp");
%>   