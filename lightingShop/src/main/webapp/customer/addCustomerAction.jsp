<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");

	// session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginIdListId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	System.out.println(request.getParameter("id"));
	System.out.println(request.getParameter("lastPw")); 
	System.out.println(request.getParameter("cstmName"));
	System.out.println(request.getParameter("addressName"));
	System.out.println(request.getParameter("sample3Postcode"));
	System.out.println(request.getParameter("sample3Address"));
	System.out.println(request.getParameter("sample3DetailAddress"));
	// System.out.println(request.getParameter("cstmAddress"));
	System.out.println(request.getParameter("cstmEmail"));
	System.out.println(request.getParameter("cstmBirth"));
	System.out.println(request.getParameter("cstmPhone"));
	System.out.println(request.getParameter("cstmGender")); 
	System.out.println(request.getParameter("cstmAgree"));
	System.out.println(request.getParameter("cstmRank"));

	//유효성 검사 후 입력값이 맞지 않으면 회원가입 페이지로 리디렉션
	if(request.getParameter("id") == null
		|| request.getParameter("lastPw") == null
		|| request.getParameter("cstmName") == null
		|| request.getParameter("addressName") == null
		// || request.getParameter("cstmAddress") == null
		|| request.getParameter("sample3Postcode") == null
		|| request.getParameter("sample3Address") == null
		|| request.getParameter("sample3DetailAddress") == null
		|| request.getParameter("cstmEmail") == null
		|| request.getParameter("cstmBirth") == null
		|| request.getParameter("cstmPhone") == null
		|| request.getParameter("cstmGender") == null
		|| request.getParameter("cstmAgree") == null
		|| request.getParameter("cstmRank") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("lastPw").equals("")
		|| request.getParameter("cstmName").equals("")
		|| request.getParameter("addressName").equals("")
		// || request.getParameter("cstmAddress").equals("")
		|| request.getParameter("sample3Postcode").equals("")
		|| request.getParameter("sample3Address").equals("")
		|| request.getParameter("sample3DetailAddress").equals("")
		|| request.getParameter("cstmEmail").equals("")
		|| request.getParameter("cstmBirth").equals("")
		|| request.getParameter("cstmPhone").equals("")
		|| request.getParameter("cstmGender").equals("")
		|| request.getParameter("cstmAgree").equals("")
		|| request.getParameter("cstmRank").equals("")) {
		response.sendRedirect(request.getContextPath()+"/customer/addCustomer.jsp");
		return;
	}
	
	// 변수값 받아오기
	String sample3Postcode = request.getParameter("sample3Postcode");
	String sample3Address = request.getParameter("sample3Address");
	String sample3DetailAddress = request.getParameter("sample3DetailAddress");
	
	String id = request.getParameter("id");
	String lastPw = request.getParameter("lastPw");
	String cstmName = request.getParameter("cstmName");
	String addressName = request.getParameter("addressName");
	String cstmAddress = "("+sample3Postcode+")" + " " + sample3Address + " " + sample3DetailAddress;
	String cstmEmail = request.getParameter("cstmEmail");
	String cstmBirth = request.getParameter("cstmBirth");
	String cstmPhone = request.getParameter("cstmPhone");
	String cstmGender = request.getParameter("cstmGender");
	String cstmAgree = request.getParameter("cstmAgree");
	String cstmRank = request.getParameter("cstmRank");
	System.out.println("[addCustomer컨트롤러 진입]");
	System.out.println("입력받은 ID : "+id);
	
	// idList에 set
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	idList.setActive(cstmAgree); // 약관동의 -> 활성화
	
	// customer에 set
	Customer customer = new Customer();
	customer.setId(id);
	customer.setCstmName(cstmName);
	customer.setCstmAddress(cstmAddress);
	customer.setCstmEmail(cstmEmail);
	customer.setCstmBirth(cstmBirth);
	customer.setCstmPhone(cstmPhone);
	customer.setCstmGender(cstmGender);
	customer.setCstmAgree(cstmAgree);
	customer.setCstmRank(cstmRank);
	
	// paramPwHistory에 set
	PwHistory pwHistory = new PwHistory();
	pwHistory.setId(id);
	pwHistory.setPw(lastPw);
	
	// address에 set
	Address address = new Address();
	address.setId(id);
	address.setAddressName(addressName);
	address.setAddress(cstmAddress); // 고객주소와 주소테이블 주소를 동일하게 함.
	
	CustomerDao cDao = new CustomerDao();
	boolean checkId = cDao.customerSigninIdCk(customer);
	System.out.println("아이디 중복체크 true - 중복 --> :"+checkId);
	
	if(checkId) { 
		// 중복일 경우 회원가입 폼으로 리다이렉션
		System.out.println("중복된 아이디가 존재합니다.");
		String msg = "overLapId";
		response.sendRedirect(request.getContextPath()+"/customer/addCustomer.jsp?msg="+msg);
		return;
	}else {
		// 중복이 아닐경우 회원가입 진행, 메서드 호출
		CustomerDao customerDao = new CustomerDao();
		int addIdList = customerDao.addIdList(idList);
		int addCustomer = customerDao.addCustomer(customer);
		int addAddress = customerDao.addAddress(address);
		if(addIdList == 1) {
		System.out.println("회원가입 성공");
		// 회원가입시 비밀번호를 pwHistory에 추가
		int operatePwHistory = customerDao.operatePwHistory(pwHistory);
		if(operatePwHistory == 1) {
			System.out.println("비밀번호 pwHistory에 추가완료");
		}
		response.sendRedirect(request.getContextPath()+"/customer/myPage.jsp");
		return;
	} else { // DB에 값이 입력되지 않은 경우
	System.out.println("회원가입 실패");
	response.sendRedirect(request.getContextPath()+"/customer/addCustomer.jsp");
		}
	}	
%>   