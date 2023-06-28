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
    <title>lighting shop</title>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
    
    <!-- Google Fonts 링크 추가 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display&display=swap">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Lato&display=swap">
    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
<style>

selector {
  property: value !important;
}



a.product-name {
 font-family: 'Montserrat', sans-serif !important;
  font-size: 16px !important;
  font-weight: bold !important;
  color: #333333 !important;
  text-decoration: underline !important;
}

td.total-price {
  font-family: 'Lato', sans-serif !important;
}
td button {
  width: 30px;
  height: 30px;
  background-color: #f5f5f5;
  border: 1px solid #ccc;
  cursor: pointer;
}

td button:hover {
  background-color: #e0e0e0;
}

td span {
  font-weight: bold;
}

.cart-table {
  width: 100%;
  border-collapse: collapse;
}

.cart-table th,
.cart-table td {
  padding: 10px;
  text-align: center;
}

.cart-table input[type="checkbox"] {
  display: block;
  margin: 0 auto;
}

.cart-table tbody tr {
  border-bottom: 1px solid #ccc; 
}


</style>

</head>
<body>
<jsp:include page="/inc/header.jsp"></jsp:include>
	<!-- Search Wrapper Area Start -->
	<div class="search-wrapper section-padding-100">
	   <div class="search-close">
	      <i class="fa fa-close" aria-hidden="true"></i>
	   </div>
	   <div class="container">
	      <div class="row">
	         <div class="col-12">
	            <div class="search-content">
	               <form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
	                  <input type="search" name="searchWord" id="search" placeholder="키워드를 입력하세요">
	                  <button type="submit"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""></button>
	               </form>
	            </div>
	         </div>
	      </div>
	   </div>
	</div>
	<!-- Search Wrapper Area End -->

<!-- ##### Main Content Wrapper Start ##### -->

<div class="main-content-wrapper d-flex clearfix">  
	<!-- menu 좌측 bar -->
	<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
			
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
					        <table class="cart-table">
					         <thead>
					            <tr style="background-color: black; color: white;">
					                    <th style="color: white;">check</th>
									    <th style="color: white;">product</th>
									    <th style="color: white;">price</th>
									    <th style="color: white;">quantity</th>
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
					                               <td width="20" >
					                                   <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>" onchange="updateTotalPrice()">                            
					                               </td>
					                               <td width="50" colspan="2"  class="cart_product_img" style="text-align: left;">                        
					                               
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
					                                
					                			 		<a style="text-decoration: underline;" class="product-name" href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= cartProduct.get("productNo") %>"><%= cartProduct.get("productName") %></a>                			 
					                			 	</td>
					                                <td class="price"><span><%= discountedPrice %>원</span></td>
					                                <td>
					                                       <div>	                              
					                                            <div>
								                                    <button onclick="increaseQuantity('<%= productNos %>')">+</button>
								                                    <span id="quantity_<%= productNos %>"><%= cartProduct.get("quantity") %></span>
								                                    <button onclick="decreaseQuantity('<%= productNos %>')">-</button>
								              						<a style="color: red;" role="button" href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= (Integer)cartProduct.get("productNo") %>&action=deleteSession">X</a>
							                               		</div>
							                                </div> 	                            
						                            </td> 
					                            </tr>
					                    <%
					                        }				                
					           			} else {
					       				 %>
					        	
					        				 <tr>
							                	<td colspan="5" style="text-align: center;" >cart is empty.</td>
							                </tr>  							                
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
					                    
					                    updateTotalPrice(); // 수량이 변경될 때마다 총 가격 업데이트
					                }
					            
					                function decreaseQuantity(productNo) {
					                    var quantityElement = document.getElementById("quantity_" + productNo);
					                    var quantity = parseInt(quantityElement.innerHTML);
					                    if (quantity > 1) {
					                        quantity -= 1;
					                        quantityElement.innerHTML = quantity;
					                    }
					                    updateTotalPrice(); // 수량이 변경될 때마다 총 가격 업데이트
					                }
					            </script>
					            </div>
					           </div>
					           <div class="col-12 col-lg-4">
					                <div class="cart-summary">
					                    <h5>Cart Total</h5>
					                    <ul class="summary-table">
					                        <li><span>delivery:</span> <span>Free</span></li>
					                        <li><span>total:</span> <span class="total-price"><%= totalPrice %>원</span></li>
					                    </ul>
					                    <div class="cart-btn mt-100">
					                        <a href="<%=request.getContextPath()%>/customer/myPage.jsp" class="btn amado-btn w-100">Login</a>
					                    </div>
					                </div>
					            </div>
					       </div>
						   <script>
						   function updateTotalPrice() {
						        var checkboxes = document.getElementsByName("selectedProducts");
						        var totalPriceElement = document.querySelector(".total-price"); // 클래스로 요소 선택
					
						        var totalPrice = 0;
						        for (var i = 0; i < checkboxes.length; i++) {
						            if (checkboxes[i].checked) {
						                var quantityElement = document.getElementById("quantity_" + checkboxes[i].value);
						                var quantity = parseInt(quantityElement.innerHTML);
						                var priceElement = checkboxes[i].closest("tr").querySelector(".price");
						                var price = parseFloat(priceElement.innerText); // 문자열에서 가격 값을 추출
						                totalPrice += quantity * price;
						            }
						        }
					
						        totalPriceElement.innerHTML = totalPrice + "원";
						    }   
						   </script>
					<% 
							} else {
					            // 로그인된 사용자일 경우, 실제 데이터베이스에서 장바구니 정보를 가져와 출력
					            // 장바구니에 담긴 각 상품에 대한 정보를 표시         
					            int totalPrice = 0; // 총 가격을 누적하기 위한 변수 4
					            %>
					       <div>
				               	<input type="hidden" name="cartOrder" value="cartOrder">
				           </div>
						   <div class="cart-table clearfix">
						 	 <table class="cart-table">
		        				 <thead>
						            <tr style="background-color: black; color: white;">
						                    <th style="color: white;">check</th>
										    <th style="color: white;">product</th>
										    <th style="color: white;">price</th>
										    <th style="color: white;">quantity</th>
						            </tr>
						        </thead>
				                <tbody>
				    <%             
					            if (cartList != null && cartList.size() > 0) {
					                // 장바구니 정보를 표시하는 코드
					%>
					        
							                    <%
							                                      
							                        for (HashMap<String, Object> cartProduct : cartList) {
							                        
							                         int productNo = (Integer) cartProduct.get("productNo"); // 각 상품의 productNo 가져오기
							                       	                  
							                   	%>
							                            <tr>
							                                <td>
							                                    <input type="checkbox" name="selectedProducts" value="<%= cartProduct.get("productNo") %>" onchange="updateTotalPrice()">
											 				</td>
											 			    <td class="cart_product_desc"> 
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
							                                	<a class="product-name" style="text-decoration: underline;"  href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>"><%= cartProduct.get("productName") %></a>
							                                </td>
							                                <td class="price"><span><%= cartProduct.get("price") %>원</span></td>
														    <td colspan="2" class="qty">
															 	<button type="button" onclick="increaseQuantity('<%= productNo %>')">+</button>
							                                    <span id="quantity_<%= productNo %>"><%= cartProduct.get("quantity") %></span>
							                                    <button type="button" onclick="decreaseQuantity('<%= productNo %>')">-</button>
																
																<input type="hidden" name="productCnt[]" value="<%= cartProduct.get("quantity") %>">
									                            <!-- 숨겨진 input 태그를 이용하여 수량을 배열로 전달 -->																
															
							           							 <a style="color: red;" role="button" href="<%=request.getContextPath()%>/cart/removeCartAction.jsp?productNo=<%= cartProduct.get("productNo") %>&action=deleteData">&nbsp;X</a>
							                                </td>
					
										                   
							                            </tr>
							                            
							        <%
							                     int quantity =  (Integer)cartProduct.get("quantity");
							                    
							                   	}
							           		} else {
							        %>
							                <tr>
							                	<td colspan="5" style="text-align: center;" >cart is empty.</td>
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
							                
							                updateTotalPrice(); // 수량이 변경될 때마다 총 가격 업데이트
							            }
							        
							            function decreaseQuantity(productNo) {
							                var quantityElement = document.getElementById("quantity_" + productNo);
							                var quantity = parseInt(quantityElement.innerHTML);
							                if (quantity > 1) {
							                    quantity -= 1;
							                    quantityElement.innerHTML = quantity;
							                    
							                    
							                }
							                
							                updateTotalPrice(); // 수량이 변경될 때마다 총 가격 업데이트
							            }
								        </script>	
								           
							          </div>
							          <div class="col-12 col-lg-4">
							                <div class="cart-summary">
							                    <h5>Cart Total</h5>
							                    <ul class="summary-table">
							                        <li><span>delivery:</span> <span>Free</span></li>
							                        <li><span>total:</span>  <span class="total-price"><%= totalPrice %>원</span></li>
							                    </ul>
							                    
							                    <!-- 주문서 제출을 위한 form -->
												<form id="orderForm" method="post" action="<%=request.getContextPath()%>/orders/orderProduct.jsp">
												       <input type="hidden" name="productNo" value="">
					    							   <input type="hidden" name="productCnt" value=""> 
												   <div class="cart-btn mt-100">
												      <button type="button" class="btn amado-btn w-100" onclick="submitOrder()">Check Out</button>
												   </div>
												</form>
										 	</div>
                    					</div>		
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
													           productNoInput.setAttribute("name", "productNo");
													           productNoInput.setAttribute("value", checkboxes[i].value);
													           form.appendChild(productNoInput);
					
													           
													           var productCntInput = document.createElement("input");
													           productCntInput.setAttribute("type", "hidden");
													           productCntInput.setAttribute("name", "productCnt");
													           productCntInput.setAttribute("value", quantityInputs[i].value);
													           form.appendChild(productCntInput);
													       }
													   }
					
													   form.submit();
												}
												
											    function updateTotalPrice() {
											        var checkboxes = document.getElementsByName("selectedProducts");
											        var totalPriceElement = document.querySelector(".total-price"); // 클래스로 요소 선택
					
											        var totalPrice = 0;
											        for (var i = 0; i < checkboxes.length; i++) {
											            if (checkboxes[i].checked) {
											                var quantityElement = document.getElementById("quantity_" + checkboxes[i].value);
											                var quantity = parseInt(quantityElement.innerHTML);
											                var priceElement = checkboxes[i].closest("tr").querySelector(".price");
											                var price = parseFloat(priceElement.innerText); // 문자열에서 가격 값을 추출
											                totalPrice += quantity * price;
											            }
											        }
					
											        totalPriceElement.innerHTML = totalPrice + "원";
											    }
												</script>					      						                     
							<%       
							    }//로그인했을경우 끝 
							%>	
	                
                </div>
            </div>
        </div>
    </div>
<!-- ##### Main Content Wrapper End ##### -->
<!-- ##### Footer Area Start ##### -->
    <div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
<!-- ##### Footer Area End ##### -->

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>
</body>
</html>