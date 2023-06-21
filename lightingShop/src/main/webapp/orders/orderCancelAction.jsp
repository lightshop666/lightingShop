<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");	

   // 선택한 상품 취소 처리
   /*
   orderNo에 종속된 point_history 소환
       1)point_pm에서 m인 경우(=포인트를 사용한 경우) 포인트를 우선 환불
           1-1)point 사용량이 환불 총액보다 많은 경우 -> 환불 총액만큼 포인트 P 해줌
           1-2)point 사용량이 환불 총액보다 적은 경우 -> 사용한 포인트만큼 P 해주고 차액만큼 환불
       2)point_pm에서 P인 경우(=주문한 금액만큼 적립)
            3-1) P컬럼만큼 M 해주고 
           3-2)unselectedPrice(주문취소하지 않은 상품들 누적 총액)만큼 다시 계산해서 insert한다.
	완료된 행의 배송상태를 취소완료로 바꿔준다.
   */
	   // 유효성 검사
	String orderNoParam = request.getParameter("orderNo");
	int orderNo = 0;
	if (orderNoParam == null || orderNoParam.isEmpty()) {
	    System.out.println("orderNo 유효성 검사에서 튕긴다. orderNo orderCancelAction.jsp");
	    response.sendRedirect(request.getContextPath() + "/home.jsp");
	    return;
	}
	orderNo = Integer.parseInt(orderNoParam);
	System.out.println(orderNo + "<-parm-- orderNo orderCancelAction.jsp");
	
	//체크박스 선택된 값들 받아온다
	String[] StrOrderProductList = request.getParameterValues("selectedProducts[]");
	if (StrOrderProductList != null) {
	    System.out.println(StrOrderProductList.length + "<-StrOrderProductList.length-- orderNo orderCancelAction.jsp");
	} else {
	    out.println("<script>alert('선택된 상품이 없습니다. StrOrderProductList'); history.go(-1);</script>");
	    return;
	}
	//인트 배열 선언
	int[] orderProductList = null;
	//받아온 값들이 널이 아니라면
	if (StrOrderProductList.length > 0) {
	    //배열의 길이만큼 int 선언
	    orderProductList = new int[StrOrderProductList.length];
	    for (int i = 0; i < StrOrderProductList.length; i += 1) {    //배열에 새로운 값을 써줘야하기 때문에 foreach가 아니라 for문
	        orderProductList[i] = Integer.parseInt(StrOrderProductList[i]);
	        System.out.println(orderProductList[i]+ "<-orderProductList[i]-- 상품번호  orderCancelAction.jsp");
	    }
	    System.out.println(orderProductList.length + "<-orderProductList.size-- orderNo orderCancelAction.jsp");
	}
	
	//체크박스 선택된 값들 받아온다
	String[] productCntList = request.getParameterValues("productCnt[]");
	//인트 배열 선언
	int[] intProductCntList = null;
	
	//받아온 값들이 널이 아니라면
	if (productCntList != null) {
	    //배열의 길이만큼 int 선언
	    intProductCntList = new int[productCntList.length];
	    for (int i = 0; i < productCntList.length; i += 1) {    //배열에 새로운 값을 써줘야하기 때문에 foreach가 아니라 for문
	        intProductCntList[i] = Integer.parseInt(productCntList[i]);
	        System.out.println(intProductCntList[i]+ "<-intProductCntList[i]-- 상품갯수  orderCancelAction.jsp");
	    }
	    System.out.println(intProductCntList.length + "<-selectedProducts.size--  orderCancelAction.jsp");
	} else {
	    out.println("<script>alert('선택된 상품(개수)이 없습니다.'); history.go(-1);</script>");
	    return;
	}
	
	
	String selectedPriceStr = request.getParameter("totalPriceInput[]");
	int selectedPrice = 0;
	// null이거나 비어있지 않다면 넣어준다.
	if (selectedPriceStr != null && !selectedPriceStr.isEmpty()) {
	    selectedPrice = Integer.parseInt(selectedPriceStr);
	    System.out.println(selectedPrice + "<-selectedPrice-- 선택된 상품의 금액 orderCancelAction.jsp");
	}
	
	// 취소되지 않은 상품의 금액
	String unselectedTotalPriceStr = request.getParameter("unselectedPrice");
	int unselectedTotalPrice = 0;
	if (unselectedTotalPriceStr != null && !unselectedTotalPriceStr.isEmpty()) {
	    unselectedTotalPrice = Integer.parseInt(unselectedTotalPriceStr);
	    System.out.println(unselectedTotalPrice + "<-unselectedTotalPrice-- 취소되지 않은 상품의 금액 orderCancelAction.jsp");
	}
	
	
	// 포인트 환불/적립 로직 추가
	
	//모델 소환
	PointHistoryDao pointHistoryDao = new PointHistoryDao();
	OrderDao orderDao = new OrderDao();
	EmpDao empDao = new EmpDao();
	
	// 주문에 따른 포인트 내역 가져오기
	ArrayList<PointHistory> phList = pointHistoryDao.pointListByOrder(orderNo);
	// 주문 정보 가져오기
	HashMap<String, Object> map = null;
	map = orderDao.selectOrdersOne(orderNo);
	if (map == null) {
	    System.out.println("주문 정보를 가져오는 데 실패했습니다.  orderCancelAction.jsp");
	    response.sendRedirect(request.getContextPath() + "/home.jsp");
	    return;
	}
	Orders orders = (Orders)map.get("orders");
	OrderProduct orderProduct = (OrderProduct)map.get("orderProduct");
	
	//총 주문금액
	int totalPrice =(int) orders.getOrderPrice();
    System.out.println(totalPrice + "<--totalPrice--총 주문금액 orderCancelAction.jsp");

	
	//환불해줄 금액
	int refundAmount = 0;
	
	 for (PointHistory p : phList) {
		//point_pm에서 m인 경우(=포인트를 사용한 경우) 포인트 환불
		if (p.getPointPm().equals("M")) {
			System.out.println("point_pm에서 M인 경우 orderCancelAction.jsp");
			//차감할 포인트 변수
			int refundpoint = 0;
			//사용한 포인트
			int usedPoint = p.getPoint();
		    System.out.println(totalPrice + "<--usedPoint--포인트사용한 경우 사용한 포인트 orderCancelAction.jsp");
			
			// 1-1) point 사용량이 환불 총액보다 많은 경우 -> 환불 총액만큼 포인트 P 해줌
			if (selectedPrice < usedPoint) {
				refundpoint = usedPoint - selectedPrice;
			    System.out.println(refundpoint + "<--refundpoint--환불총액보다 포인트 보유량이 많은 경우 orderCancelAction.jsp");
				refundAmount = 0;
				
			// 1-2) point 사용량이 환불 총액보다 적은 경우 -> 사용한 포인트만큼 P 해주고 차액만큼 환불
			} else {
				refundpoint = usedPoint;
				refundAmount = selectedPrice - refundpoint;
			    System.out.println(refundAmount + "<--refundAmount--point 사용량이 환불 총액보다 적은 경우 orderCancelAction.jsp");

			}
			 //포인트 환불-증가
			int pointPkRefund = pointHistoryDao.pointByCancel(orderNo, refundpoint);
		    System.out.println(pointPkRefund + "<--pointPkRefund--포인트 환불 orderCancelAction.jsp");

			//customer 테이블의 point 총합 업데이트
			int pointResult1 = pointHistoryDao.cstmPointUpdate(pointPkRefund);
		    System.out.println(pointResult1 + "<--pointResult1--customer테이블 업데이트PK orderCancelAction.jsp");

	}
	
	
	// 2) point_pm에서 P인 경우(=주문한 금액만큼 적립)
		if (p.getPointPm().equals("P")) {
			System.out.println("point_pm에서 P인 경우 orderCancelAction.jsp");
			//얻은 포인트
			int usedPoint = p.getPoint();
			System.out.println(usedPoint + "<--usedPoint-- 적립한포인트 orderCancelAction.jsp");
			//3-1) 얻은 포인트만큼 빼주고-감소
			int pointCancelM = pointHistoryDao.usedPoint(orderNo, usedPoint);
			System.out.println(pointCancelM + "<--pointCancelM-- 적립된 포인트만큼 감소  orderCancelAction.jsp");
			 //3-2)unselectedPrice(주문취소하지 않은 상품들 누적 총액)만큼 다시 계산해서 insert한다.
			int pointCancelP = pointHistoryDao.pointCancelP(orderNo, unselectedTotalPrice);
			System.out.println(pointCancelP + "<--pointCancelP-- 주문취소하지 않은 상품 총액만큼 포인트계산  orderCancelAction.jsp");
			
			//customer 테이블의 point 총합 업데이트
			int pointResult2 = pointHistoryDao.cstmPointUpdate(pointCancelM);
			int pointResult3 = pointHistoryDao.cstmPointUpdate(pointCancelP);
		    System.out.println(pointResult2 + "<--pointResult2--customer테이블 업데이트PK orderCancelAction.jsp");
		    System.out.println(pointResult3 + "<--pointResult3--customer테이블 업데이트PK orderCancelAction.jsp");

		}
	}
	 
	 

	//배송상태 수정
	for(int i = 0; i< orderProductList.length; i+=1 ){
		String deliveryStatus = "취소완료";
		//정환님 딜리버리 업데이트 dao
		int result = empDao.updateOrder(deliveryStatus, orderProductList[i]);
		
		if(result == 0 ){
			System.out.println(result+"<--result-- 취소 업데이트 실패 orderCancelAction.jsp");
			out.println("<script>alert('취소 실패.'); history.go(-1);</script>");
		}else{
			// 취소 성공 메시지 출력 후 이전 페이지 이동
			System.out.println(result+"<--result-- 취소 업데이트 성공 orderCancelAction.jsp");
			out.println("alert('주문이 취소되었습니다.');");
			response.sendRedirect(request.getContextPath() + "/home.jsp");
		}
	}
%>
