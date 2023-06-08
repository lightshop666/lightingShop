<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//주문취소 액션	


	//유효성 검사. 주문취소를 위해 orderNo가 없으면 안되니까 리다이렉트
	if (request.getParameter("orderNo") == null) {
        response.sendRedirect(request.getContextPath() + "/orders/orderProductList.jsp");
		return;
	}

// 컬럼 업데이트 처리 후 리다이렉트
	String orderNo = request.getParameter("orderNo");
	String deliStatus = "취소중";						//취소 액션이니까 주문취소 버튼을 누르면 배송상태가 취소중으로 바뀐다.
	
// 컬럼 업데이트 처리 모델 소환
	//기존 주문에서 포인트 얼마나 증가했는지 불러오는 모델 소환 (customer, point_history)	
	
	
	CustomerDao customerDao = new CustomerDao();
	int totalPoint = customerDao.selectPointCustomer(id);

	
	// 다시 리스트로 리다이렉트
	response.sendRedirect(request.getContextPath() + "/orders/orderProductList.jsp");
       
%>
<script>
	alert('취소되었습니다.');
</script>
