<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%
	//교환 액션
	request.setCharacterEncoding("utf-8");	
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 returnProductAction.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- returnProductAction.jsp");
		return;
	}
	
	int orderProductNo=0;
	if(request.getParameter("orderProductNo") != null){
		orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
		System.out.println(request.getParameter("orderProductNo")+"<--parm-- orderProductNo returnProductAction.jsp");
	}
	//반품사유
	String returnReason = null;
	if(request.getParameter("returnReason") != null){
		returnReason = request.getParameter("returnReason");
		System.out.println(request.getParameter("returnReason")+"<--parm-- returnReason returnProductAction.jsp");
	}else if(returnReason == null || returnReason.trim().isEmpty()) {
		System.out.println(request.getParameter("returnReason")+"<--parm-- 반품사유 공란 returnProductAction.jsp");
		out.println("<script>alert('반품 사유를 선택해주세요.'); history.back();</script>");
	}
	//상세사유
	String detailReason = request.getParameter("detailReason");
	System.out.println(request.getParameter("detailReason")+"<--parm-- detailReason returnProductAction.jsp");

	//모델 호출
	EmpDao empDao = new EmpDao();
	String deliveryStatus = "배송중";
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