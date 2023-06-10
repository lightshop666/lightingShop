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
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	String deliStatus = "취소중";						//취소 액션이니까 주문취소 버튼을 누르면 배송상태가 취소중으로 바뀐다.
	
// 컬럼 업데이트 처리 모델 소환
	//기본 주문one 소환
	OrderDao orderDao = new OrderDao();
	HashMap<String, Object> map = orderDao.selectOrdersOne(orderNo);
	//vo에 나눠담기
	Orders orders = (Orders) map.get("orders");
	OrderProduct orderProduct = (OrderProduct) map.get("orderProduct");
	System.out.println(orders.getId() + " <--getId-- orderCancelAction.jsp");
	
	//총 포인트에서 주문시 포인트 빼기
	//총 포인트 호출 모델.
	CustomerDao customerDao = new CustomerDao();
	int totalPoint  = customerDao.selectPointCustomer(orders.getId());
	
	//기존 주문에서 포인트 얼마나 증가했는지 불러오는 모델 소환 (customer, point_history)
	
	//업데이트 쿼리 호출
	orderDao.OPNDeleiveryStatus((String)orders.getDeliveryStatus(), (int)orderProduct.getOrderProductNo());

	
	// 다시 리스트로 리다이렉트
	response.sendRedirect(request.getContextPath() + "/orders/orderProductList.jsp");
       
%>
<script>
	alert('취소되었습니다.');
</script>
