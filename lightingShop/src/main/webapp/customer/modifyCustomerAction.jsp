<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩	
	request.setCharacterEncoding("utf-8"); 
	
	//로그인되지 않은경우, 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	System.out.println(request.getParameter("lastPw")); 
	System.out.println(request.getParameter("customerNewPw")); 
	System.out.println(request.getParameter("customerNewPwCk")); 
	System.out.println(request.getParameter("cstmName"));
	System.out.println(request.getParameter("cstmEmail"));
	System.out.println(request.getParameter("cstmBirth"));
	System.out.println(request.getParameter("cstmPhone"));
	System.out.println(request.getParameter("cstmGender")); 
	
	//유효성 검사 후 입력값이 맞지 않으면 회원수정 페이지로 리디렉션
	if(request.getParameter("lastPw") == null
		|| request.getParameter("customerNewPw") == null
		|| request.getParameter("customerNewPwCk") == null
		|| request.getParameter("cstmName") == null
		|| request.getParameter("cstmEmail") == null
		|| request.getParameter("cstmBirth") == null
		|| request.getParameter("cstmPhone") == null
		|| request.getParameter("cstmGender") == null
		|| request.getParameter("lastPw").equals("")
		|| request.getParameter("customerNewPw").equals("")
		|| request.getParameter("customerNewPwCk").equals("")
		|| request.getParameter("cstmName").equals("")
		|| request.getParameter("cstmEmail").equals("")
		|| request.getParameter("cstmBirth").equals("")
		|| request.getParameter("cstmPhone").equals("")
		|| request.getParameter("cstmGender").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/modifyCustomer.jsp");
		return;
	}
	
	// 파라미터값 받기
	String lastPw = request.getParameter("lastPw");
	String customerNewPw = request.getParameter("customerNewPw");
	String customerNewPwCk = request.getParameter("customerNewPwCk");
	String id = (String)session.getAttribute("loginIdListId");
	String pw = (String)session.getAttribute("loginIdListLastPw");
	String cstmName = request.getParameter("cstmName");
	String cstmEmail = request.getParameter("cstmEmail");
	String cstmBirth = request.getParameter("cstmBirth");
	String cstmPhone = request.getParameter("cstmPhone");
	String cstmGender = request.getParameter("cstmGender");
	String updatedate = request.getParameter("updatedate");
	System.out.println("[modifyCustomerAction controller acess]");
	// System.out.println("(1)받아온 pw값 : "+lastPw+"/newPw : "+customerNewPw);
	
	// 비밀번호가 서로 일치하지 않는다면 수정폼으로 리다이렉션
	if(!customerNewPw.equals(customerNewPwCk) || !lastPw.equals(pw)) {
		System.out.println("비밀번호가 서로 일치하지 않습니다.");
		response.sendRedirect(request.getContextPath()+"/customer/modifyCustomer.jsp");
		return;
	}
	
	// id_list 기존정보 set
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	System.out.println("기존 id/pw : "+idList.getId() +"/"+idList.getLastPw());
	
	// id_list 변경정보 set
	IdList modifyIdList = new IdList();
	modifyIdList.setLastPw(customerNewPw);
	
	// 기존내용 customer에 set
	Customer customer = new Customer();
	customer.setId(id);
	
	// 변경된 내용 customer에 set
	Customer modifyCustomer = new Customer();
	modifyCustomer.setCstmName(cstmName);
	modifyCustomer.setCstmEmail(cstmEmail);
	modifyCustomer.setCstmBirth(cstmBirth);
	modifyCustomer.setCstmPhone(cstmPhone);
	modifyCustomer.setCstmPhone(cstmPhone);
	modifyCustomer.setCstmGender(cstmGender);
	modifyCustomer.setUpdatedate(updatedate);
	System.out.println("바뀔 이름/pw : "+modifyCustomer.getCstmName() +"/"+modifyIdList.getLastPw());
	
	// 변경된 내용 pwHistory에 set
	PwHistory pwHistory = new PwHistory();
	pwHistory.setId(id);
	pwHistory.setPw(customerNewPw);
	
	CustomerDao cDao = new CustomerDao();
	
	// 이전에 사용한 비밀번호들과의 중복체크 (최근 3개의 비밀번호)
	boolean pwHistoryCk = cDao.selectPwHistoryCk(modifyCustomer, modifyIdList);
	System.out.println("비밀번호이력 중복체크 true값이 뜨면 중복 --> :"+pwHistoryCk);
	
	if(pwHistoryCk) {
		System.out.println("최근 변경했던 비밀번호들과 중복됩니다");
		String msg = "overlapPw";
		response.sendRedirect(request.getContextPath()+"/customer/modifyCustomer.jsp?msg="+msg);
		return;
	}
	
	// id_list 수정 및 customer 수정
	int modifyIdListOne = cDao.modifyIdListOne(idList, modifyIdList);
	int modifyCustomerOne = cDao.modifyCustomerOne(customer, modifyCustomer);
	
	// 고객정보가 수정된 경우
	if(modifyCustomerOne == 1) {
		System.out.println("회원정보 수정 성공");
		// 수정된 비밀번호는 pwHistory(비밀번호내역)에 추가하기 
		int operatePwHistory = cDao.operatePwHistory(pwHistory);
		if(operatePwHistory == 1) {
			System.out.println("비밀번호 pwHistory에 추가완료");
		} else {
			System.out.println("비밀번호 pwHistory에 추가실패");
		}
		// 수정성공시 고객정보상세페이지로 이동
		response.sendRedirect(request.getContextPath()+"/customer/customerOne.jsp");
		return;
	} else { // 정보수정 실패
			System.out.println("회원정보 수정 실패");
			response.sendRedirect(request.getContextPath()+"/customer/modifyCustomer.jsp");
		}
%>