<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%
	//요청값 검사
	String productNoStr = request.getParameter("productNo");
	String quantityStr = request.getParameter("quantity");
	String discountedPriceStr = request.getParameter("discountedPrice");
	
	if (productNoStr != null && quantityStr != null && discountedPriceStr != null) {
	 int productNo = Integer.parseInt(productNoStr);
	 int quantity = Integer.parseInt(quantityStr);
	 double discountedPrice = Double.parseDouble(discountedPriceStr);
	
	 // selectProductOne 메서드를 호출하여 상품 정보 가져오기
	 CartDao cartDao = new CartDao();
	 HashMap<String, Object> product = cartDao.selectProductOne(productNo);
	
	 // 받아온 정보를 사용하여 개별 변수에 저장
	 String productName = (String) product.get("productName");
	 double price = (double) product.get("discountedPrice");
	 String productPath = (String) product.get("productPath");
	 String productOriFilename = (String) product.get("oriFilename");
	 String productSaveFilename = (String) product.get("saveFilename");
	 String productFileType = (String) product.get("fileType");
	
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
	 } else {
	     // 기존에 상품이 없는 경우, 새로운 상품을 추가
	     HashMap<String, Object> cartProduct = new HashMap<>();
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
	}


    // 세션 검사
    ArrayList<HashMap<String, Object>> cartList = null;
    if (session.getAttribute("loginIdListId") != null) {
        // 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져오기
        String loginId = (String) session.getAttribute("loginIdListId");
        CartDao cartDao = new CartDao();
         cartList = cartDao.cartListById(loginId);
    }
       
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니 목록</title>
</head>
<body>
<h1>장바구니 목록</h1>

<%
    // 로그인 여부를 확인합니다
    if (session.getAttribute("loginIdListId") == null) {
        // 로그인되지 않은 경우 세션 카트 정보를 표시합니다
        HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
        if (cart != null && cart.size() > 0) {
            // 장바구니에 담긴 상품 목록을 표시합니다
%>
        <form action="<%=request.getContextPath()%>/order/orderProduct.jsp" method="post">
            <table>
                <thead>
                    <tr>
                        <th>선택</th>
                        <th>상품명</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>이미지</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 장바구니에 담긴 각 상품에 대한 정보를 표시합니다
                        double totalPrice = 0.0; // 총 가격을 누적하기 위한 변수
                        for (String productNo : cart.keySet()) {
                            HashMap<String, Object> cartProduct = (HashMap<String, Object>) cart.get(productNo);
                            int quantity = 0;
                            double discountedPrice = (double) cartProduct.get("discountedPrice");
                            double productTotalPrice = quantity * discountedPrice;
                    %>
                            <tr>
                                <td>
                                    <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>">
                                </td>
                                <td><%= cartProduct.get("productName") %></td>
                                <td><%= cartProduct.get("price") %></td>
                                <td>
                                    <span id="quantity_<%= cartProduct.get("productNo") %>"><%= cartProduct.get("quantity") %></span>
                                    
                                   	<%  quantity =(int) cartProduct.get("quantity"); %>
                                    <button onclick="increaseQuantity(<%= cartProduct.get("productNo") %>)">+</button>
                                    <button onclick="decreaseQuantity(<%= cartProduct.get("productNo") %>)">-</button>
                                </td>
                                <td><img src="<%= cartProduct.get("productPath").toString() + cartProduct.get("productSaveFilename").toString() %>" alt="<%= cartProduct.get("productOriFilename") %>"></td>
                                <td>
           							 <a href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= cartProduct.get("productNo") %>&action=deleteSession">X</a>
                                </td>
                            </tr>
                    <%
                                // 각 상품의 가격을 누적하여 총 가격을 계산
                                totalPrice += (double) cartProduct.get("price");
                        }
                    %>
                </tbody>
            </table>

            <h3>총 가격: <%= totalPrice %></h3>

       
            <a role="button" href= "<%=request.getContextPath()%>/customer/mypage.jsp">로그인</a>
        </form>

        <script>
            function increaseQuantity(productNo) {
                var quantityElement = document.getElementById("quantity_" + productNo);
                var quantity = parseInt(quantityElement.innerHTML);
                quantity += 1;
                quantityElement.innerHTML = quantity;
            }

            function decreaseQuantity(productNo) {
                var quantityElement = document.getElementById("quantity_" + productNo);
                var quantity = parseInt(quantityElement.innerHTML);
                if (quantity > 1) {
                    quantity -= 1;
                    quantityElement.innerHTML = quantity;
                }
            }

           
            }
        </script>
		<%
           } else {
		%>
        		<p>장바구니가 비어있습니다.</p>
	<%
           }
       } else {
            // 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져와 출력
             HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
            if (cartList != null && cartList.size() > 0) {
                // 장바구니 정보를 표시하는 코드
	%>
        <form action="<%=request.getContextPath()%>/orders/orderProduct.jsp" method="post">
        	<div>
               	<input type="hidden" name="cartOrder" value="cartOrder">
           	</div>
            <table>
                <thead>
                    <tr>
                        <th>선택</th>
                        <th>상품명</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>이미지</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 장바구니에 담긴 각 상품에 대한 정보를 표시
                        double totalPrice = 0.0; // 총 가격을 누적하기 위한 변수
                        
                        for (String productNo : cart.keySet()) {
                            HashMap<String, Object> cartProduct = (HashMap<String, Object>) cart.get(productNo);
                            int quantity = 0;
                            double discountedPrice = (double) cartProduct.get("discountedPrice");
                            double productTotalPrice = quantity * discountedPrice;
                    %>
                            <tr>
                                <td>
                                    <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>">
                                </td>
                                <td><%= cartProduct.get("productName") %></td>
                                <td><%= cartProduct.get("price") %></td>
                                <td>
                                    <span id="quantity_<%= cartProduct.get("productNo") %>"><%= cartProduct.get("quantity") %></span>
                                    <%  quantity =(int) cartProduct.get("quantity"); %>
                                    <button onclick="increaseQuantity(<%= cartProduct.get("productNo") %>)">+</button>
                                    <button onclick="decreaseQuantity(<%= cartProduct.get("productNo") %>)">-</button>
                                </td>
                                <%  
                                	int productCnt = quantity;  
                                %>
                                <td>
                                	<input type="hidden" name="productCnt_<%= productNo %>" value="<%= productCnt %>">
                                </td>
                                <td>
                                	<img src="<%= String.valueOf(cartProduct.get("productPath")) + String.valueOf(cartProduct.get("productSaveFilename")) %>" alt="<%= cartProduct.get("productOriFilename") %>">
                                </td>
                                
                                <td>
           							 <a href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= cartProduct.get("productNo") %>&action=deleteData">X</a>
                                </td>
                            </tr>
                    <%
                            // 각 상품의 가격을 누적하여 총 가격을 계산
                    			totalPrice += productTotalPrice;
                        }
                    %>
                </tbody>
            </table>

            <h3>총 가격: <%= totalPrice %></h3>

            <input type="submit" value="선택 상품 주문">
            
        </form>
        <script>
            function increaseQuantity(productNo) {
                var quantityElement = document.getElementById("quantity_" + productNo);
                var quantity = parseInt(quantityElement.innerHTML);
                quantity += 1;
                quantityElement.innerHTML = quantity;
            }

            function decreaseQuantity(productNo) {
                var quantityElement = document.getElementById("quantity_" + productNo);
                var quantity = parseInt(quantityElement.innerHTML);
                if (quantity > 1) {
                    quantity -= 1;
                    quantityElement.innerHTML = quantity;
                }
            }

           
            }
        </script>	
        
       	<%
           } else {
        %>
            <p>장바구니가 비어있습니다.</p>
        <%
            }
    }
        
%>
			
</body>
</html>