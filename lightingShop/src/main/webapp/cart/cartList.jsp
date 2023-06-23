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
<html lang="en">
<head>
	<meta charset="UTF-8">
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Amado - Furniture Ecommerce Template | Cart</title>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
</head>
<body>
<!-- menu 좌측 bar -->
<!-- ##### Main Content Wrapper Start ##### -->
<div class="main-content-wrapper d-flex clearfix">
    
<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
</div>
<div class="cart-table-area section-padding-100">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 col-lg-8">
                <div class="cart-title mt-50">
                    <h2>Shopping Cart</h2>
                </div>


<%
    // 로그인 여부를 확인
    if (session.getAttribute("loginIdListId") == null) {
        // 로그인되지 않은 경우 세션 카트 정보를 표시
        HashMap<String, Object> cart = (HashMap<String, Object>) session.getAttribute("cart");
%>
        <div class="cart-table clearfix">
        <table class="table table-responsive">
         <thead>
            <tr>
                <th>check</th>
                <th>product</th>
                <th></th>
                <th>price</th>
                <th>quantity</th>
                <th></th>
            </tr>
        </thead>
<%
		int totalPrice = 0; // 총 가격을 누적하기 위한 변수
        if (cart != null && cart.size() > 0) {
        	
            // 장바구니에 담긴 상품 목록을 표시
%>

                <tbody>
                    <%
                        // 장바구니에 담긴 각 상품에 대한 정보를 표시
                        
                        for (String productNos : cart.keySet()) {
                            HashMap<String, Object> cartProduct = (HashMap<String, Object>) cart.get(productNos);
                            System.out.println("productNo: " + (Integer)cartProduct.get("productNo"));//디버깅
                            int discountedPrice = (Integer)cartProduct.get("price");
                            int productTotalPrice = ((Integer)cartProduct.get("quantity") *discountedPrice);
                    %>
                            <tr>
                               <td >
                                   <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>">                            
                               </td>
                               <td> 
                               
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
                                <td class="cart_product_desc"> <%= cartProduct.get("productName") %></td>
                                <td class="price"><%= discountedPrice %>원</td>
                                <td class="qty">
	                                <div>
		                                <div>
		                                    <button onclick="increaseQuantity('<%= productNos %>')">+</button>
		                                    <span id="quantity_<%= productNos %>"><%= cartProduct.get("quantity") %></span>
		                                    <button onclick="decreaseQuantity('<%= productNos %>')">-</button>
		              
		                                </div> 
		                            </div>
	                            </td> 
	                            <td>
	                            	<a role="button" href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= (Integer)cartProduct.get("productNo") %>&action=deleteSession">X</a>
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
                        <%
           } else {
        %>
        	
        	<tbody>
                <tr>
                	<td colspan="5">장바구니가 비었습니다.</td>
                </tr>
            </tbody>    
        <%
           }
    
    	 %>  
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
            </div>
           </div>
           <div class="col-12 col-lg-4">
                <div class="cart-summary">
                    <h5>Cart Total</h5>
                    <ul class="summary-table">
                        <li><span>subtotal:</span> <span><%= totalPrice %>원</span></li>
                        <li><span>delivery:</span> <span>Free</span></li>
                        <li><span>total:</span> <span><%= totalPrice %>원</span></li>
                    </ul>
                    <div class="cart-btn mt-100">
                        <a href="<%=request.getContextPath()%>/customer/myPage.jsp" class="btn amado-btn w-100">login</a>
                    </div>
                </div>
            </div>
       </div>

<% 
		} else {
            // 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져와 출력
            // 장바구니에 담긴 각 상품에 대한 정보를 표시         
            int totalPrice = 0; // 총 가격을 누적하기 위한 변수 
            if (cartList != null && cartList.size() > 0) {
                // 장바구니 정보를 표시하는 코드
%>
        
        	<div>
               	<input type="hidden" name="cartOrder" value="cartOrder">
           	</div>
		   <div class="cart-table clearfix">
		        <table class="table table-responsive">
		                <thead>
		                    <tr>
		                        <th>check</th>
				                <th>product</th>
				                <th></th>
				                <th>price</th>
				                <th>quantity</th>
				                <th></th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <%
		                                      
		                        for (HashMap<String, Object> cartProduct : cartList) {
		                        
		                         int productNo = (Integer) cartProduct.get("productNo"); // 각 상품의 productNo 가져오기
		                       	                  
		                   	%>
		                            <tr>
		                                <td>
		                                    <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>">
						 				</td>
						 				<td>
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
		                                <td class="price"><%= cartProduct.get("price") %>원</td>
									    <td class="qty">
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
		                     int quantity =  (Integer)cartProduct.get("quantity");
		                     int productTotalPrice =  quantity * (Integer)cartProduct.get("price") ;
							
		                            // 각 상품의 가격을 누적하여 총 가격을 계산
		                    			totalPrice += productTotalPrice;
		                   	}
		           		} else {
		        %>
		                <tr>
		                	<td colspan="5">장바구니가 비었습니다.</td>
		                </tr>
		        <%
		            }	
		        %>   
		        	
		         	</tbody>
		        </table>
		       </div> 
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
			           
		           </div>
		           <div class="col-12 col-lg-4">
		                <div class="cart-summary">
		                    <h5>Cart Total</h5>
		                    <ul class="summary-table">
		                        <li><span>subtotal:</span> <span><%= totalPrice %>원</span></li>
		                        <li><span>delivery:</span> <span>Free</span></li>
		                        <li><span>total:</span> <span><%= totalPrice %>원</span></li>
		                    </ul>
		                    <div class="cart-btn mt-100">
		                    <!-- 주문서 제출을 위한 form -->
							<form id="orderForm" method="post" action="<%=request.getContextPath()%>/orders/orderProduct.jsp">
							       <input type="hidden" name="productNo[]" value="">
    							   <input type="hidden" name="productCnt[]" value=""> 
							   <div class="cart-btn mt-100">
							      <button type="button" class="btn amado-btn w-100" onclick="submitOrder()">선택 상품 주문</button>
							   </div>
							</form>
		                   	<!-- submitOrder() 함수 -->
							<script>
							function submitOrder() {
								   var checkboxes = document.getElementsByName("selectedProducts");
								   var quantityInputs = document.getElementsByName("productCnt[]");
								   var form = document.getElementById("orderForm");

								   for (var i = 0; i < checkboxes.length; i++) {
								       if (checkboxes[i].checked) {
								           var productNoInput = document.createElement("input");
								           productNoInput.setAttribute("type", "hidden");
								           productNoInput.setAttribute("name", "productNo[]");
								           productNoInput.setAttribute("value", checkboxes[i].value);
								           form.appendChild(productNoInput);

								           
								           var productCntInput = document.createElement("input");
								           productCntInput.setAttribute("type", "hidden");
								           productCntInput.setAttribute("name", "productCnt[]");
								           productCntInput.setAttribute("value", quantityInputs[i].value);
								           form.appendChild(productCntInput);
								       }
								   }

								   form.submit();
							}
							</script>
							
		                    </div>
		                </div>
		            </div>
		          </div>	
		                     
		<%       
		    } 
		%>		
</body>
</html>