<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
	//주문취소 액션
	
    // 컬럼 업데이트 처리 후 리다이렉트
    if (request.getParameter("orderNo") != null) {
        String canceledOrderProductNo = request.getParameter("orderProductNo");
        
        // 컬럼 업데이트 처리
        // ...
        
        // 현재 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/orders/orderProductList.jsp");
        
    }
%>
        <script>
            alert('취소되었습니다.');
        </script>
