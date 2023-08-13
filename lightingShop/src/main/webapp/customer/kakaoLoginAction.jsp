<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//	세션검사
	if (session.getAttribute("loginIdListId") != null) { // 회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//인코딩
	request.setCharacterEncoding("UTF-8");

	//요청값 디버깅
	System.out.println(request.getParameter("id")+"<-- kakaoLoginAction.jsp id");
	
	//요청값 변수에 저장
	String id = request.getParameter("id");
	
	// idList객체 생성
	IdList idList = new IdList();
	idList.setId(id);
	
	System.out.println(idList.getId()+"<-- kakaoLoginAction.jsp idList.getId()"); // 디버깅
	
	// 카카오톡 id체크 메서드 호출
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> loginIdList = cDao.checkIdkakao(idList);
	
	System.out.println(loginIdList.get("id")+"<-- kakaoLoginAction.jsp loginIdList.getId()"); // 디버깅
	
	cDao.lastLoginUpdate(idList); // 마지막 로그인시간 업데이트
	// 카카오톡 로그인아이디가 DB와 일치할 경우
	if(loginIdList.get("id") != null) {
		// 로그인 정보를 Session에 저장
		session.setAttribute("loginIdListId", id);
		
		// 로그인시 비로그인상태에서 cart세션에 담은 물건이 있을경우
		if(session.getAttribute("cart") != null) { 
			System.out.println("비회원이 장바구니에 물건을 넣은 상태");
		
			// 세션에 저장된 cart 값을 받는다.
			HashMap<String, Object> cart  = (HashMap<String, Object>) session.getAttribute("cart");
			// cart.keySet() - cart 객체 내부에 있는 모든 키값들을 Set 자료형으로 반환
			for(String productNos : cart.keySet()) {
				// 해당 상품정보가 담긴 HashMap 객체를 가져오기 위함
				HashMap<String,Object> cartProduct = (HashMap<String,Object>)cart.get(productNos);
				
				System.out.println("productNo :"+ (int)cartProduct.get("productNo")); // 넘버확인
				System.out.println("quantity :"+ (int)cartProduct.get("quantity")); // 수량확인
				
				// 카트 객체생성
				Cart cartVo = new Cart();
				cartVo.setId((String)session.getAttribute("loginIdListId")); 
				
				// 기존 회원장바구니에 중복된 품목인지 확인 -> 중복일경우 수량 추가
				int thisProductNo = (int)cartProduct.get("productNo");
				System.out.println(thisProductNo+"번 품목 중복검사 실행중");
				cartVo.setProductNo((Integer)cartProduct.get("productNo"));
				
				// 제품 중복검사
				boolean cartProductCk = cDao.cartListCk(cartVo); 
				System.out.println(cartProductCk+" true이면 중복");
				
				if(cartProductCk) {
					System.out.println("중복된 품목 -> 수량조절");
					int addQuantity = (Integer)cartProduct.get("quantity"); // 비회원이 추가한 품목의 개수
					int oldQuantity = cDao.cartOneQty(cartVo); // 기존 DB에 저장된 해당 품목의 개수
					int newQuantity = addQuantity + oldQuantity; // 총 수량
					System.out.println("addQuantity/oldQuantity/newQuantity"+addQuantity+"/"+oldQuantity+"/"+newQuantity);
					// 카트의 수량을 변경
					int modifyQuantity = cDao.modifyCart(newQuantity, thisProductNo, id);
					if(modifyQuantity == 1) {
						System.out.println("중복된 품목 수량 추가");
					} 
				} else {
					System.out.println("중복된 품목이 아니므로 기존 장바구니에 추가");
					cartVo.setCartCnt((int)cartProduct.get("quantity"));
					int row = cDao.addCart(cartVo); // 카트추가
					if(row == 1) {
						System.out.println(thisProductNo+"번 품목이 장바구니에 추가되었습니다.");
					}
				}
				
				// 비회원 세션 삭제
				session.removeAttribute("cart"); 
			}
		}
		
		// 디버깅
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListId"));
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	} else if(loginIdList.get("id") == null) {
		System.out.println("카카오톡 로그인에 실패했습니다.");
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
%>