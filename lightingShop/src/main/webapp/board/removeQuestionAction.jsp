<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.net.*" %>
<%
	// 유효성 검사 // qNo, qId
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")
			|| request.getParameter("qId") == null
			|| request.getParameter("qId").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String qId = request.getParameter("qId");
	
	// inputPw
	BoardDao dao = new BoardDao();
	String msg = null;
	if(session.getAttribute("loginIdListId") == null
			|| !session.getAttribute("loginIdListId").equals(qId)) { // 비밀번호 입력란 생성 조건
		if(request.getParameter("inputPw") == null
				|| request.getParameter("inputPw").equals("")) {
			msg = URLEncoder.encode("비밀번호를 입력해주세요", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/removeQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
			return;
		}
		String inputPw = request.getParameter("inputPw");
		boolean pwChk = dao.questionOnePwChk(qNo, inputPw); // 비밀번호 일치불일치 메서드 호출
		if(pwChk == false) {
			msg = URLEncoder.encode("비밀번호가 일치하지 않습니다", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/removeQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
			return;
		}
	}
	
	// DELETE 메서드 호출
	// 문의글 삭제 메서드는 문의글 다중 선택후 일괄 삭제도 가능하게 하기 위해 배열로 값 저장
	int[] intCkQno = new int[1];
	intCkQno[0] = qNo;
	int row = dao.deleteQuestion(intCkQno);
	
	// 리다이렉션
	if(row == 1) {
		msg = URLEncoder.encode("삭제되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp?msg=" + msg);
		return;
	} else {
		msg = URLEncoder.encode("삭제되지 않았습니다 다시 시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/removeQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	}
%>