<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CartDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
    String productNoStr = request.getParameter("productNo");
    String action = request.getParameter("action");
	
    System.out.println("productNoStr: " + productNoStr);
	System.out.println("action: " + action);
	
    
    if (productNoStr != null && action != null) {
        int productNo = Integer.parseInt(productNoStr);
        
        // CartDao 클래스의 인스턴스 생성
        CartDao cartDao = new CartDao();

        if (action.equals("deleteSession")) {
            // 세션 장바구니에서 상품 제거
            HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
            if (cart != null) {
                cart.remove(String.valueOf(productNo));
                session.setAttribute("cart", cart);
            }
        } else if (action.equals("deleteData")) {
            // 데이터베이스 장바구니에서 상품 제거
            if (session.getAttribute("loginIdListId") != null) {
                String loginId = (String) session.getAttribute("loginIdListId");
                cartDao.deleteProductFromCart(productNo, loginId);
            }
        }
    }

    // 장바구니 페이지로 리디렉션
    response.sendRedirect(request.getContextPath() + "/cart/cartList.jsp");
%>