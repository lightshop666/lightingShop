<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%

	 CartDao cartDao = new CartDao();
	
	// 세션 검사 후 로그인 상태일 경우에는 장바구니에 담은 품목 데이터 추가 후, 최신 데이터 정보 가져오기
	ArrayList<HashMap<String, Object>> cartList = null;
	if (session.getAttribute("loginIdListId") != null) {
		// 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져오기
	    String loginId = (String) session.getAttribute("loginIdListId");
				
	    cartList = cartDao.cartListById(loginId); //카트테이블에 있는 상품리스트 가져오기
	    
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
    // 로그인 여부를 확인
    if (session.getAttribute("loginIdListId") == null) {
        // 로그인되지 않은 경우 세션 카트 정보를 표시
        HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
        if (cart != null && cart.size() > 0) {
        	
            // 장바구니에 담긴 상품 목록을 표시
%>
            <table>
                <thead>
                    <tr>
                        <th>선택</th>
                        <th>상품명</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 장바구니에 담긴 각 상품에 대한 정보를 표시
                        int totalPrice = 0; // 총 가격을 누적하기 위한 변수
                        for (String productNos : cart.keySet()) {
                            HashMap<String, Object> cartProduct = (HashMap<String, Object>) cart.get(productNos);
                            System.out.println("productNo: " + (Integer)cartProduct.get("productNo"));//디버깅
                            int discountedPrice = (Integer)cartProduct.get("price");
                            int productTotalPrice = ((Integer)cartProduct.get("quantity") *discountedPrice);
                    %>
                            <tr>
                                <td>
                                    <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>">
                                    <%
                                        // 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
                                        if(cartProduct.get("productSaveFilename") == null) {
                                    %>
                                            <img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
                                    <%
                                        } else {
                                    %>
                                        <%
                                            String productImagePath = request.getContextPath() + "/" + cartProduct.get("productPath") + "/" + cartProduct.get("productSaveFilename");
                                        %>
                                        <img src="<%= productImagePath %>" alt="<%= cartProduct.get("productOriFilename") %>">
                                    <%  
                                        }
                                    %>  
                                
                                </td>
                                <td><%= cartProduct.get("productName") %></td>
                                <td><%= discountedPrice %>원</td>
                                <td>
                                    <button onclick="increaseQuantity('<%= productNos %>')">+</button>
                                    <span id="quantity_<%= productNos %>"><%= cartProduct.get("quantity") %></span>
                                    <button onclick="decreaseQuantity('<%= productNos %>')">-</button>
                                </td>
                                <td>
                                     <a href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= (Integer)cartProduct.get("productNo") %>&action=deleteSession">X</a>
                                </td>
                            </tr>
                    <%
                                // 각 상품의 가격을 누적하여 총 가격을 계산
                                totalPrice += productTotalPrice;
                    %>
                    
                    <% 
                        }
                    %>
                </tbody>
            </table>
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
            </script>

            <h3>총 가격: <%= totalPrice %>원</h3>

       
            <a role="button" href= "<%=request.getContextPath()%>/customer/mypage.jsp">로그인</a>

        <%
           } else {
        %>
                <p>장바구니가 비어있습니다.</p>
        <%
           }
       } else {
            // 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져와 출력
            if (cartList != null && cartList.size() > 0) {
                // 장바구니 정보를 표시하는 코드
	%>
        <form  method="post">
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
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 장바구니에 담긴 각 상품에 대한 정보를 표시
                        int totalPrice = 0; // 총 가격을 누적하기 위한 변수                      
                        for (HashMap<String, Object> cartProduct : cartList) {
                        
                         int productNo = (Integer) cartProduct.get("productNo"); // 각 상품의 productNo 가져오기
                       	 int productTotalPrice =  (Integer)cartProduct.get("quantity") * (Integer)cartProduct.get("price") ;
						 int quantity =  (Integer)cartProduct.get("quantity");                  
                   	%>
                            <tr>
                                <td>
                                    <input type="checkbox" name="productNo[]" value="<%= cartProduct.get("productNo") %>">
				 	<%
										// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
										if(cartProduct.get("productSaveFilename") == null) {
									%>
											<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
									<%
										} else {
									%>
										<% 
									        String productImagePath = request.getContextPath() + "/" + cartProduct.get("productPath") + "/" + cartProduct.get("productSaveFilename");
									    %>
									    <img src="<%= productImagePath %>" alt="<%= cartProduct.get("productOriFilename") %>">
									<%	
										}
					%>	                                
                                </td>
                                <td><%= cartProduct.get("productName") %></td>
                                <td><%= cartProduct.get("price") %>원</td>
			                    <td>
								<td>
								 	<button type="button" onclick="increaseQuantity('<%= productNo %>')">+</button>
                                    <span id="quantity_<%= productNo %>"><%= cartProduct.get("quantity") %></span>
                                    <button type="button" onclick="decreaseQuantity('<%= productNo %>')">-</button>
								</td>
			                    
		                        <td>
		                            <input type="hidden" name="productCnt[]" value="<%= cartProduct.get("quantity") %>">
		                            <!-- 숨겨진 input 태그를 이용하여 수량을 배열로 전달 -->
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
	        </script>	
	        
	        

            <h3>총 가격: <%= totalPrice %>원</h3>

             <button type="button" onclick="submitOrder()">선택 상품 주문</button>
            
        </form>
        

       	<%
           } else {
        %>
            <p>장바구니가 비어있습니다.</p>
        <%
            }	
    } 
%>
<script>
function submitOrder() {
    // 클릭시 페이지 이동
    window.location.href = "<%=request.getContextPath()%>/orders/orderProduct.jsp";
    
}
</script>
			
</body>
</html>