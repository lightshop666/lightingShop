<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%
	//교환 액션
	request.setCharacterEncoding("utf-8");	
	
	int orderProductNo=0;
	if(request.getParameter("orderProductNo") != null){
		orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
		System.out.println(request.getParameter("orderProductNo")+"<--parm-- orderProductNo switchProductAction.jsp");
	}
	//교환사유
	String exchangeReason = null;
	if(request.getParameter("exchangeReason") != null){
		exchangeReason = request.getParameter("exchangeReason");
		System.out.println(request.getParameter("exchangeReason")+"<--parm-- exchangeReason switchProductAction.jsp");
	}else if(exchangeReason == null || exchangeReason.trim().isEmpty()) {
		System.out.println(request.getParameter("exchangeReason")+"<--parm-- 교환사유 공란 switchProductAction.jsp");
		out.println("<script>alert('교환 사유를 선택해주세요.'); history.back();</script>");
	}
	//상세사유
	String detailReason = request.getParameter("detailReason");
	System.out.println(request.getParameter("detailReason")+"<--parm-- detailReason switchProductAction.jsp");

	//모델 호출
	EmpDao empDao = new EmpDao();
	String deliveryStatus = "교환중";
	//정환님 딜리버리 업데이트 dao
	int result = empDao.updateOrder(deliveryStatus, orderProductNo);
	
	if(result == 0 ){
		System.out.println(result+"<--result-- 교환 업데이트 실패 orderConfirmDelivery.jsp");
		out.println("<script>alert('교환 실패.'); history.go(-1);</script>");
	}else{
		// 교환 성공 메시지 출력 후 이전 페이지 이동
		System.out.println(result+"<--result-- 교환 업데이트 성공 orderConfirmDelivery.jsp");
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
%>