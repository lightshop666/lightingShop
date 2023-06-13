<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");	
//유효성 검사
	//세션 유효성 검사 --> 비회원은 주문할 수 없다 게스트 걸러내기
	Customer customer = new Customer(); // 객체 생성 및 초기화
	customer.setId("test2"); //-------------------------임시 테스트용-------------------------------------//
	if(session.getAttribute("loginMemberId") != null) {
		customer.setId((String)session.getAttribute("loginMemberId"));
	}
	// 제품 번호 배열과 제품 수량 배열을 가져옵니다.
	String[] productNos = request.getParameterValues("productNo");
	String[] productCnts = request.getParameterValues("productCnt");
	String finalPrice = request.getParameter("finalPrice");
	String customerName = request.getParameter("customerName");
	String customerPhone = request.getParameter("customerPhone");
	String customerAddress = request.getParameter("customerAddress");
	String deliOption = request.getParameter("deliOption");
	String otherDeliOption = request.getParameter("otherDeliOption");
	
	// 필수 필드 검사를 수행합니다.
	if (productNos == null || productCnts == null || finalPrice == null) {
		System.out.println("유효성검사에서 튕긴다 <--orderProductAction.jsp");
		response.sendRedirect(request.getContextPath() + "/orderProduct.jsp");
		return;
	}
	
	// productNos 배열의 값 출력
	for (String productNo : productNos) {
		System.out.println(productNo + " <-- productNo orderProductAction.jsp");
	}
	
	// productCnts 배열의 값 출력
	for (String productCnt : productCnts) {
		System.out.println(productCnt + " <-- productCnt orderProductAction.jsp");
	}
	// finalPrice 출력
	System.out.println(finalPrice + " <-- finalPrice orderProductAction.jsp");
	// customerName 출력
	System.out.println(customerName + " <-- customerName orderProductAction.jsp");
	// customerPhone 출력
	System.out.println(customerPhone + " <-- customerPhone orderProductAction.jsp");	
	// customerAddress 출력
	System.out.println(customerAddress + " <-- customerAddress orderProductAction.jsp");	
	// deliOption 출력
	System.out.println(deliOption + " <-- deliOption orderProductAction.jsp");	
	// otherDeliOption 출력
	System.out.println(otherDeliOption + " <-- otherDeliOption orderProductAction.jsp");
	
	//함수에 넣기 위한 vo 호출
	Orders orders = new Orders();
	orders.setId(customer.getId());
	orders.setOrderAddress(customerAddress+deliOption+otherDeliOption);
	orders.setOrderPrice(Double.parseDouble(finalPrice));
	
	//dao 호출
	OrderDao orderDao = new OrderDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	
	//orders 테이블에 삽입 후 pk키 반환
	int orderPk = orderDao.addOrder(orders);
	
	//orderProduct 각각 삽입
	for(int i=0; i<productNos.length; i+=1){
		orderProductDao.addProductDao(orderPk, Integer.parseInt(productNos[i]), Integer.parseInt(productCnts[i]) );
	}
	
	response.sendRedirect(request.getContextPath() + "/order/orderProductOne.jsp?orderNo="+orderPk);
	return;

