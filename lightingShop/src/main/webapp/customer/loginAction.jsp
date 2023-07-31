<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%
	//	세션검사
	if (session.getAttribute("loginIdListId") != null) { // 회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	// 변수전달
	String id = request.getParameter("id");
	String lastPw = request.getParameter("lastPw");
	String loginMsg = "";
	
	if (id.equals(null) || lastPw.equals(null)) {	// 로그인 ID, PW를 입력하지 않은 경우
		// 로그인 폼으로 리다이렉션
		response.sendRedirect(request.getContextPath() + "/customer/myPage.jsp");
		return;
	}
	
	// idList객체 생성
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	
	// 로그인 메서드 실행
	CustomerDao cDao = new CustomerDao();
	// id와 lastPw가 DB의 내역과 일치하지 않는다면 loginIdList.get("active")와 loginIdList.get("empLevel")는 null값이 출력된다.
	HashMap<String, Object> loginIdList = cDao.loginMethod(idList);
	cDao.lastLoginUpdate(idList); // 마지막 로그인시간 업데이트
	
	System.out.println(id + " " + lastPw); // 디버깅
	System.out.println(loginIdList.get("active")); // 디버깅
	System.out.println(loginIdList.get("empLevel")); // 디버깅
	
	// 아이디와 비밀번호가 DB와 같지 않은 경우
	if (loginIdList.get("active") == null) { 
		System.out.println("아이디 혹은 비밀번호가 틀렸습니다.\n다시 한 번 확인해주세요.");
		loginMsg = URLEncoder.encode("아이디 혹은 비밀번호가 틀렸습니다.\n다시 한 번 확인해주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/customer/myPage.jsp?loginMsg="+loginMsg);
		return;
	}
	
	if (loginIdList.get("active").equals("Y")) { // 탈퇴회원이 아니고 id와 pw가 DB의 id_list와 일치할 경우
		
		// 로그인 정보를 Session에 저장
		session.setAttribute("loginIdListId", loginIdList.get("id"));	// 세션에 로그인 성공한 id_list id를 저장
		session.setAttribute("loginIdListLastPw", loginIdList.get("lastPw"));	// 세션에 로그인 성공한 id_list last_pw를 저장
		session.setAttribute("loginIdListRank", loginIdList.get("cstmRank"));	// 세션에 로그인 성공한 customer cstm_rank 저장
		session.setAttribute("loginIdListActive", loginIdList.get("active"));	// 세션에 로그인 성공한 id_list active를 저장
		session.setAttribute("loginIdListEmpLevel", loginIdList.get("empLevel")); // 세션에 로그인 성공한 employees emp_level을 저장
		
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
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListLastPw"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListRank"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListActive"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginIdListEmpLevel"));
		
		if(loginIdList.get("empLevel") == null) {  // 레벨이 없다면 고객이므로 고객 home으로 보낸다
			response.sendRedirect(request.getContextPath() + "/home.jsp");
			return;
		} else { // 레벨이 있다면 사원이므로 관리자 문의리스트로 보낸다.
			response.sendRedirect(request.getContextPath() + "/admin/adminQuestionList.jsp");
			return;
		}
			
	} else {	// 로그인에 실패했을 경우 -> 탈퇴회원인 경우
		if (loginIdList.get("active").equals("N")) {	// Y면 가입된 사용자, N이면 탈퇴한 사용자
			System.out.println("탈퇴된 사용자입니다.");
			response.sendRedirect(request.getContextPath() + "/customer/home.jsp");
			return;
		} 
	}
%>  