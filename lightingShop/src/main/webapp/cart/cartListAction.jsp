<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.net.URLEncoder" %>
<%

	//요청값 검사
	String productNoStr = request.getParameter("productNo");
	String quantityStr = request.getParameter("productCnt");
	String discountedPriceStr = request.getParameter("discountedPrice");
	
	System.out.println("productNoStr: " + productNoStr);
	System.out.println("quantityStr: " + quantityStr);
	System.out.println("discountedPriceStr: " + discountedPriceStr);
	
	//값초기화
	int productNo = 0;
	int quantity = 0;
	int discountedPrice = 0;
	
	if (productNoStr != null && quantityStr != null && discountedPriceStr != null) {
		 productNo = Integer.parseInt(productNoStr);
		 quantity = Integer.parseInt(quantityStr);
		 discountedPrice = Integer.parseInt(discountedPriceStr);
	}	
	 // selectProductOne 메서드를 호출하여 상품 정보 가져오기
	 CartDao cartDao = new CartDao();
	 HashMap<String, Object> product = cartDao.selectProductOne(productNo);
	
	 // 받아온 정보를 사용하여 개별 변수에 저장
	 String productName = (String) product.get("productName");
	 int price = (Integer) product.get("productPrice");
	 if (discountedPriceStr != null) {
		 price = Integer.parseInt(discountedPriceStr);	 
	}
	 String productPath = (String) product.get("productPath");
	 String productOriFilename = (String) product.get("oriFilename");
	 String productSaveFilename = (String) product.get("saveFilename");
	 String productFileType = (String) product.get("fileType");
	 int productPrice = (Integer)product.get("productPrice"); 

	// 세션 검사 후 로그인 상태일 경우에는 장바구니에 담은 품목 데이터 추가 후, 최신 데이터 정보 가져오기
	int insertCartRow = 0;
	if (session.getAttribute("loginIdListId") != null) {
		// 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져오기
	    String loginId = (String) session.getAttribute("loginIdListId");
	   
		
		//장바구니에 담은 상품 카트 테이블에 insert해주기
		HashMap<String,Object> cartProduct = new HashMap<>();
		 cartProduct.put("productNo",productNo);
		 cartProduct.put("id",loginId);
		 cartProduct.put("productCnt",quantity);
	     cartProduct.put("productName", productName);
	     cartProduct.put("price", price);
	     cartProduct.put("quantity", quantity);// 담는 상품의 수량
	     cartProduct.put("productPath", productPath);
	     cartProduct.put("productOriFilename", productOriFilename);
	     cartProduct.put("productSaveFilename", productSaveFilename);
	     cartProduct.put("productFileType", productFileType);

		insertCartRow = cartDao.insertCartProduct(cartProduct); //카트테이블에 상품추가
			
	    
	}else{
		//2)비로그인 시에 카트세션에 저장
		
		 // 세션에서 기존 카트 정보를 가져오거나 새로 생성
		 HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
		 if (cart == null) {
		     cart = new HashMap<>();
		 }
		
		 // 기존에 동일한 상품이 이미 있는지 확인
		 String cartProductKey = String.valueOf(productNo);
		 if (cart.containsKey(cartProductKey)) {
		     // 기존에 상품이 있는 경우, 수량을 더해줌
		     HashMap<String, Object> cartProduct = (HashMap<String, Object>) cart.get(cartProductKey);
		     int currentQuantity = (int) cartProduct.get("quantity");
		     cartProduct.put("quantity", currentQuantity + quantity);
		   insertCartRow = 1;
		 } else {
		     // 기존에 상품이 없는 경우, 새로운 상품을 추가
		     HashMap<String, Object> cartProduct = new HashMap<>();
		     cartProduct.put("productNo",productNo);
		     cartProduct.put("productName", productName);
		     cartProduct.put("price", price);
		     cartProduct.put("quantity", quantity);
		     cartProduct.put("productPath", productPath);
		     cartProduct.put("productOriFilename", productOriFilename);
		     cartProduct.put("productSaveFilename", productSaveFilename);
		     cartProduct.put("productFileType", productFileType);
		
		     cart.put(cartProductKey, cartProduct);
		 }
		
		 // 세션에 카트 정보 저장
		 session.setAttribute("cart", cart);
		insertCartRow = 1;
	}
	String msg = null;
	if(insertCartRow== 1){
		msg = URLEncoder.encode("장바구니에 상품이 담겼습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?msg="+msg+"&productNo="+productNo);	
    	return;
	}
%>