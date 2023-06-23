<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%
	//수취확인 액션
	request.setCharacterEncoding("utf-8");	
	
	String loingIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loingIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loingIdListId+"<--새로 들어온 아이디 orderConfirmDelivery.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- orderConfirmDelivery.jsp");
		return;
	}

	int orderProductNo=0;
	if(request.getParameter("orderProductNo")!=null){
		orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
		System.out.println(request.getParameter("orderProductNo")+"<--parm-- orderProductNo orderConfirmDelivery.jsp");
	}
	
	//모델 호출
	EmpDao empDao = new EmpDao();
	String deliveryStatus = "배송완료";
	//정환님 딜리버리 업데이트 dao
	int result = empDao.updateOrder(deliveryStatus, orderProductNo);
	
	if(result == 0 ){
		System.out.println(result+"<--result-- 수취확인 업데이트 실패 orderConfirmDelivery.jsp");
		out.println("<script>alert('Error.'); window.close(); location.href='" + request.getContextPath() + "/home';</script>");
	}else{
		// 수취확인 성공 메시지 출력 후 이전 페이지 이동
		System.out.println(result+"<--result-- 수취확인 업데이트 성공 orderConfirmDelivery.jsp");
		out.println("<script>alert('수취 확인이 성공적으로 처리되었습니다.'); history.go(-1);</script>");
	}
	
%>