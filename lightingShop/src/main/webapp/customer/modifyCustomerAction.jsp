<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩	
	request.setCharacterEncoding("utf-8"); 
		
	// 파라미터값 받기
	String customerPw = request.getParameter("customerPw");
	String customerNewPw = request.getParameter("customerNewPw");
	String customerName = request.getParameter("customerName");
	String customerPhone = request.getParameter("customerPhone");
	System.out.println("[회원정보수정액션컨트롤러 진입]");
	// System.out.println("(1)받아온 pw값 : "+customerPw+"/newPw : "+customerNewPw);
	
	// 두개의 customer에 set
	// 기존정보
	Customer customerOne = new Customer();
	customerOne.setCustomerId(loginCustomer.getCustomerId());
	customerOne.setCustomerPw(customerPw);
	System.out.println("(2)기존 로그인아이디값 : "+customerOne.getCustomerId());
	
	// 바뀔정보
	Customer modifyCustomer = new Customer();
	modifyCustomer.setCustomerId(loginCustomer.getCustomerId());
	modifyCustomer.setCustomerPw(customerNewPw);
	modifyCustomer.setCustomerName(customerName);
	modifyCustomer.setCustomerPhone(customerPhone);
	System.out.println("(3)바뀔 이름/번호 : "+modifyCustomer.getCustomerName()+"/"+modifyCustomer.getCustomerPhone());
	
	// pwHistory에 set
	PwHistory pwHistory = new PwHistory();
	pwHistory.setCustomerId(loginCustomer.getCustomerId());
	pwHistory.setPw(customerNewPw);
	
	// 이전에 사용한 비밀번호들과의 중복체크 (최근 3개의 비밀번호)
	boolean pwHistoryCk = customerService.pwHistoryCk(modifyCustomer);
	System.out.println("비밀번호이력 중복체크 true값이 뜨면 중복 --> :"+pwHistoryCk);
	
	if(pwHistoryCk) {
		System.out.println("최근 변경했던 비밀번호들과 중복됩니다");
		String overlapPw = "overlapPw";
		response.sendRedirect(request.getContextPath()+"/CustomerModify?overlapPw="+overlapPw);
		return;
	}
	
	// 고객상세정보 수정
	int modifyCustomerOne = modifyCustomerOne(customerOne, modifyCustomer);
	
	if(modifyCustomerOne == 1) {
		System.out.println("(4)회원정보 수정 성공");
		// 수정된 비밀번호는 pwHistory(비밀번호내역)에 추가하기 
		int operatePwHistory = pwHistoryService.operatePwHistory(pwHistory);
		if(operatePwHistory == 1) {
			System.out.println("(5)비밀번호 pwHistory에 추가완료");
		} else {
			System.out.println("(5)비밀번호 pwHistory에 추가실패");
		}
		loginCustomer.setCustomerName(customerName);
		loginCustomer.setCustomerPhone(customerPhone);
		response.sendRedirect(request.getContextPath()+"/CustomerOne");
		return;
	} else {
		System.out.println("(4)회원정보 수정 실패 - 비밀번호가 다릅니다");
		String noPwMsg = "noPw";
		response.sendRedirect(request.getContextPath()+"/CustomerModify?noPwMsg="+noPwMsg);
	}
%>