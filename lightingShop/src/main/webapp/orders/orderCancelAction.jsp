<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	// 선택한 상품 취소 처리
	/*
	orderNo에 종속된 point_history 소환
		1)point_pm에서 m인 경우(=포인트를 사용한 경우) 포인트를 우선 환불
			1-1)point 사용량이 환불 총액보다 많은 경우 -> 환불 총액만큼 포인트 P 해줌
			1-2)point 사용량이 환불 총액보다 적은 경우 -> 사용한 포인트만큼 P 해주고 차액만큼 환불
		2)point_pm에서 P인 경우(=주문한 금액만큼 적립)
		 	3-1) P컬럼만큼 M 해주고 
			3-2)unselectedPrice(주문취소하지 않은 상품들 누적 총액)만큼 다시 계산해서 insert한다.
	*/
	// 유효성 검사
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	System.out.println(orderNo + "<-parm-- orderNo orderCancelAction.jsp");
	
	//체크박스 선택된 값들 받아온다
	String[] selectedProductList = request.getParameterValues("selectedProducts");
	//인트 배열 선언
	int[] intSelectedProducts = null;
	//받아온 값들이 널이 아니라면
	if (selectedProductList != null) {
		//배열의 길이만큼 int 선언
		intSelectedProducts = new int[selectedProductList.length];
		for (int i = 0; i<selectedProductList.length; i += 1){	//배열에 새로운 값을 써줘야하기 때문에 foreach가 아니라 for문
			intSelectedProducts[i] = Integer.parseInt(selectedProductList[i]);
		}
		System.out.println(intSelectedProducts.length + "<-selectedProducts.size-- orderNo orderCancelAction.jsp");
	}else{
	    out.println("<script>alert('선택된 상품이 없습니다.'); history.go(-1);</script>");
	    return;
	}
	
	//체크박스 선택된 값들 받아온다
	String[] productCntList = request.getParameterValues("productCnt");
	//인트 배열 선언
	int[] intProductCntList = null;
	
	//받아온 값들이 널이 아니라면
	if (productCntList != null) {
		//배열의 길이만큼 int 선언
		intSelectedProducts = new int[productCntList.length];
		for (int i = 0; i<productCntList.length; i += 1){	//배열에 새로운 값을 써줘야하기 때문에 foreach가 아니라 for문
			intProductCntList[i] = Integer.parseInt(productCntList[i]);
		}
		System.out.println(intProductCntList.length + "<-selectedProducts.size-- orderNo orderCancelAction.jsp");
	}else{
	    out.println("<script>alert('선택된 상품(개수)이 없습니다.'); history.go(-1);</script>");
	    return;
	}
	
	
	String selectedPriceStr = request.getParameter("totalPriceInput");
	int selectedPrice = 0;
	// null이거나 비어있지 않다면 넣어준다.
	if (selectedPriceStr != null && !selectedPriceStr.isEmpty()) {
	    selectedPrice = Integer.parseInt(selectedPriceStr);
	    System.out.println(selectedPrice + "<-selectedPrice-- orderNo orderCancelAction.jsp");
	}
	
	// 취소되지 않은 상품의 금액
	String unselectedTotalPriceStr = request.getParameter("unselectedPrice");
	int unselectedTotalPrice = 0;
	if (unselectedTotalPriceStr != null && !unselectedTotalPriceStr.isEmpty()) {
	    unselectedTotalPrice = Integer.parseInt(unselectedTotalPriceStr);
	    System.out.println(unselectedTotalPrice + "<-unselectedTotalPrice-- orderNo orderCancelAction.jsp");
	}
	

// 포인트 환불/적립 로직 추가
	
	//모델 소환
	PointHistoryDao pointHistoryDao = new PointHistoryDao();
	OrderDao orderDao = new OrderDao();
	
	// 주문에 따른 포인트 내역 가져오기
	ArrayList<PointHistory> phList = pointHistoryDao.pointListByOrder(orderNo);
	// 주문 정보 가져오기
	HashMap<String, Object> orderOne = orderDao.selectOrdersOne(orderNo);
	//총 주문금액
	int totalPrice = (int)orderOne.get("orderPrice");
	
	//환불해줄 금액
	int refundAmount =0;
		
	for (PointHistory p : phList) {
//point_pm에서 m인 경우(=포인트를 사용한 경우) 포인트 환불
		if (p.getPointPm().equals("M")) {
			//차감할 포인트 변수
			int refundpoint = 0;
			//사용한 포인트
			int usedPoint = p.getPoint();
			
	// 1-1) point 사용량이 환불 총액보다 많은 경우 -> 환불 총액만큼 포인트 P 해줌
			if (selectedPrice <usedPoint) {
				refundpoint =usedPoint - selectedPrice;
				refundAmount = 0;
	// 1-2) point 사용량이 환불 총액보다 적은 경우 -> 사용한 포인트만큼 P 해주고 차액만큼 환불
			} else {
				refundpoint =usedPoint;
				refundAmount = selectedPrice-refundpoint;
			}
	//포인트 환불-증가
			int pointPkRefund = pointHistoryDao.pointByCancel(orderNo, refundpoint);
	//customer 테이블의 point 총합 업데이트
			int pointResult1= pointHistoryDao.cstmPointUpdate(pointPkRefund);
		}


		// 2) point_pm에서 P인 경우(=주문한 금액만큼 적립)
		if (p.getPointPm().equals("P")) {
			//사용한 포인트
			int usedPoint = p.getPoint();
	//3-1) 얻은 포인트만큼 빼주고-감소
			int pointCancelM = pointHistoryDao.usedPoint(orderNo, usedPoint);
	//3-2)unselectedPrice(주문취소하지 않은 상품들 누적 총액)만큼 다시 계산해서 insert한다.
			int pointCancelP = pointHistoryDao.pointCancelP(orderNo, unselectedTotalPrice);
	
	//customer 테이블의 point 총합 업데이트
			int pointResult2 = pointHistoryDao.cstmPointUpdate(pointCancelM);
			int pointResult3 = pointHistoryDao.cstmPointUpdate(pointCancelP);
		}
	}
	
	// 주문 취소 성공 메시지 출력 후 페이지 이동
	out.println("<script>alert('주문 취소가 성공적으로 처리되었습니다.'); location.href='" + request.getContextPath() + "/orders/orderProductOne.jsp?orderNo=" + orderNo + "';</script>");

%>
