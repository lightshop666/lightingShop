<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 유효성 검사
	// id, productNo, aChk
	if(request.getParameter("id") == null
			|| request.getParameter("id").equals("")
			|| request.getParameter("productNo") == null
			|| request.getParameter("productNo").equals("")
			|| request.getParameter("aChk") == null
			|| request.getParameter("aChk").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	String id = request.getParameter("id");
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String aChk = request.getParameter("aChk");
	
	// qName, qCategory, qTitle, qContent, privateChk, qPw
	String msg = null;
	if(request.getParameter("qName") == null
			|| request.getParameter("qName").equals("")) {
		msg = URLEncoder.encode("작성자를 입력해주세요", "utf-8");
	} else if(request.getParameter("qCategory") == null
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
		msg = URLEncoder.encode("공개/비공개를 선택해주세요", "utf-8");
	} else if(request.getParameter("qPw") == null
			|| request.getParameter("qPw").equals("")) {
		msg = URLEncoder.encode("비밀번호를 입력해주세요", "utf-8");
	}
	if(msg != null) {
		response.sendRedirect(request.getContextPath() + "/board/addQuestion.jsp?productNo=" + productNo + "&msg=" + msg);
		return;
	}
	String qName = request.getParameter("qName");
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	String privateChk = request.getParameter("privateChk");
	String qPw = request.getParameter("qPw");
	
	// 객체에 값 저장
	Question question = new Question();
	question.setId(id);
	question.setProductNo(productNo);
	question.setaChk(aChk);
	question.setqName(qName);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	question.setPrivateChk(privateChk);
	question.setqPw(qPw);
	
	// INSERT 메서드 호출
	BoardDao dao = new BoardDao();
	int[] rowAndKey = dao.insertQuestion(question);
	// row값과 qNo값 불러오기
	int row = rowAndKey[0];
	int qNo = rowAndKey[1];
	
	// 리다이렉션
	if(row == 1) { // insert 성공시
		msg = URLEncoder.encode("작성되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/questionOne.jsp?qNo=" + qNo + "&msg=" + msg);
		return;
	} else { // insert 실패시
		msg = URLEncoder.encode("작성되지 않았습니다 다시 시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/addQuestion.jsp?productNo=" + productNo + "&msg=" + msg);
		return;
	}
%>