<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 유효성 검사
	// qNo, qId
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
			response.sendRedirect(request.getContextPath() + "/board/modifyQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
			return;
		}
		String inputPw = request.getParameter("inputPw");
		boolean pwChk = dao.questionOnePwChk(qNo, inputPw); // 비밀번호 일치불일치 메서드 호출
		if(pwChk == false) {
			msg = URLEncoder.encode("비밀번호가 일치하지 않습니다", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/modifyQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
			return;
		}
	}
	
	// qCategory, qTitle, qContent, privateChk
	if(request.getParameter("qCategory") == null
			|| request.getParameter("qCategory").equals("")) {
		msg = URLEncoder.encode("문의 유형을 선택해주세요", "utf-8");
	} else if(request.getParameter("qTitle") == null
			|| request.getParameter("qTitle").equals("")) {
		msg = URLEncoder.encode("제목을 입력해주세요", "utf-8");
	} else if(request.getParameter("qContent") == null
			|| request.getParameter("qContent").equals("")) {
		msg = URLEncoder.encode("내용을 입력해주세요", "utf-8");
	} else if(request.getParameter("privateChk") == null
			|| request.getParameter("privateChk").equals("")) {
		msg = URLEncoder.encode("공개 유무를 선택해주세요", "utf-8");
	}
	if(msg != null) {
		response.sendRedirect(request.getContextPath() + "/board/modifyQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	}
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	String privateChk = request.getParameter("privateChk");
	
	// 모델값
	// 파라미터 값 객체에 저장
	Question question = new Question();
	question.setqNo(qNo);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	question.setPrivateChk(privateChk);
	// UPDATE 메서드 호출
	int row = dao.updateQuestion(question);
	
	// 리다이렉션
	if(row == 1) {
		msg = URLEncoder.encode("수정되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/questionOne.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	} else {
		msg = URLEncoder.encode("수정되지 않았습니다 다시 시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/modifyQuestion.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	}
%>