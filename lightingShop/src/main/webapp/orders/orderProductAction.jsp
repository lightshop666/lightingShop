<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//유효성 검사
	//세션 유효성 검사 --> 비회원은 주문할 수 없다 게스트 걸러내기
	Customer customer = null;
	customer.setId("test2");	//-------------------------임시 테스트용-------------------------------------//
	if(session.getAttribute("loginMemberId") != null) {
		customer.setId((String)session.getAttribute("loginMemberId"));
	}
	   // 제품 번호 배열과 제품 수량 배열을 가져옵니다.
	String[] productNos = request.getParameterValues("productNo");
	String[] productCnts = request.getParameterValues("productCnt");
	String finalPrice = request.getParameter("finalPrice");
	
	// 필수 필드 검사를 수행합니다.
	if (productNos == null || productCnts == null || finalPrice == null) {
		System.out.println("유효성검사에서 튕긴다 <--orderProductAction.jsp");
		response.sendRedirect("request.getContextPath() /orderProduct.jsp");
		return;
	}
	
%>
