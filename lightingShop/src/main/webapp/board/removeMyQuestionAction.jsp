<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "dao.*" %>
<%
	// 유효성 검사
	// 요청값 // 선택한 qNo값이 없으면 다시 리스트로
	String msg = null;
	if(request.getParameterValues("qNo") == null) {
		msg = URLEncoder.encode("문의글이 선택되지 않았습니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/myQuestionList.jsp?msg=" + msg);
		return;
	}
	// 세션정보 // 세션정보가 없거나 일치하지 않으면 home으로
	if(request.getParameter("loginId") == null
			|| request.getParameter("loginId").equals("")
			|| !session.getAttribute("loginIdListId").equals(request.getParameter("loginId"))) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// 삭제할 qNo의 값을 받아올 배열 생성
	String[] ckQno = request.getParameterValues("qNo");
	// ckQno 배열의 값들을 int타입으로 바꿔서 담을 배열 생성
	int[] intCkQno = null;
	if(ckQno != null){
		intCkQno = new int[ckQno.length];
		for(int i=0; i<intCkQno.length; i++) {
			intCkQno[i] = Integer.parseInt(ckQno[i]);
			System.out.println(intCkQno[i]); // 디버깅
		}
	}
	// DELETE 메서드 호출
	BoardDao dao = new BoardDao();
	int row = dao.deleteQuestion(intCkQno);
	
	// 리다이렉션
	if(row != 0) {
		msg = URLEncoder.encode("삭제되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/myQuestionList.jsp?msg=" + msg);
		return;
	} else {
		msg = URLEncoder.encode("삭제되지 않았습니다 다시 시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/myQuestionList.jsp?msg=" + msg);
		return;
	}
%>