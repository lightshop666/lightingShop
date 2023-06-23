<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 orderConfirmDelivery.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- orderConfirmDelivery.jsp");
		return;
	}
	//모델 호출
	OrderDao orderDao = new OrderDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 2;
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = orderProductDao.customerOrderListCnt(loginIdListId  );
	
	//마지막 페이지
	int lastPage = totalRow / rowPerPage;
	//마지막 페이지는 딱 나누어 떨어지지 않으니까 몫이 0이 아니다 -> +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	//페이지 목록 중 가장 작은 숫자의 페이지
	int minPage = ((currentPage - 1) / pageRange ) * pageRange + 1;
	//페이지 목록 중 가장 큰 숫자의 페이지
	int maxPage = minPage + (pageRange - 1 );
	//maxPage 가 last Page보다 커버리면 안되니까 lastPage를 넣어준다
	if (maxPage > lastPage){
		maxPage = lastPage;
	}
	//order모델 소환
	ArrayList<Orders> orderList  = orderDao.justOrders(beginRow, rowPerPage, loginIdListId);   
	ArrayList<HashMap<String, Object>> orderByOrderProduct = new ArrayList<HashMap<String, Object>>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모든 주문 내역</title>
	<meta charset="UTF-8">
	<!-- 웹페이지와 호환되는 Internet Explorer의 버전을 지정합니다. -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- 다양한 기기에서 더 나은 반응성을 위해 뷰포트 설정을 구성합니다. -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
	<!-- Title  -->
	<title>나의 주문 내역 | My Order List</title>
	
	<!-- Favicon  -->
	<link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">
	
	<!-- Core Style CSS -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
</head>
<style>
	.order-info {
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    margin-bottom: 10px;
	}
	
	.order-info span {
	    margin-right: 10px;
	}
	.custom-cancel-button {
	  display: inline-block;
	  min-width: 160px;
	  height: 55px;
	  color: #ffffff;
	  border: none;
	  border-radius: 0;
	  padding: 0 7px;
	  font-size: 18px;
	  line-height: 56px;
	  background-color: black;
	  font-weight: 400; }
	  
</style>

<body>
<!-- ##### Main Content Wrapper Start ##### -->
<div class="main-content-wrapper d-flex clearfix">

    <!-- Mobile Nav (max width 767px)-->
    <div class="mobile-nav">
        <!-- Navbar Brand -->
        <div class="amado-navbar-brand">
            <a href="<%=request.getContextPath()%>/resources/<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
        </div>
        <!-- Navbar Toggler -->
        <div class="amado-navbar-toggler">
            <span></span><span></span><span></span>
        </div>
    </div>

    <!-- menu 좌측 bar -->
    <!-- Header Area Start -->
    <div>
        <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
    </div>
    <!-- Header Area End -->

    <div class="cart-table-area section-padding-50">
        <div class="container-fluid">
            <div class="row">
				<div class="col-12 col-lg-11 text-center">
                    <div class="cart-title mt-50">
                        <h2>나의 주문 내역</h2>
                    </div>
                    <div>
                        <!-- 템플릿 적용 후 수정 사항 -->
                        <!-- 모든 주문 출력, 글 누르면 상품페이지로 -->
                        <!-- 사진 누르면 사진 확대 -->
                        <%
                            System.out.println(orderList.size()+"<--orderList.size()-- orderProductList.jsp");
                            for (Orders o : orderList) {
                                int orderNo = o.getOrderNo();
                                System.out.println(orderNo+"<--getOrderNo-- orderProductList.jsp");
                        %>
                        <div class="order-info">
                            <span class="order-no">주문번호 : <%= orderNo %> &nbsp; </span>
                            <span class="order-date">주문일 : <%= o.getCreatedate() %> &nbsp; </span>
                            <span class="order-detail">
                                <a href="<%=request.getContextPath()%>/orders/orderProductOne.jsp?orderNo=<%= orderNo %>">
                                    주문 상세
                                </a>
                            </span>
                        </div>
                        </div>

                        <div class="cart-table clearfix">

                            <table class="table table-responsive" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>Name</th>
                                        <th>Shipping Status</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        orderByOrderProduct = orderProductDao.selectOrderNoByOrderProductNo(orderNo);
                                        for (HashMap<String, Object> m : orderByOrderProduct) {
                                            int productNo = (int) m.get("productNo");
                                            String deliveryStatus = (String) m.get("deliveryStatus");
                                            String reviewWritten = (String) m.get("reviewWritten");
                                            int orderProductNo =(int)m.get("orderProductNo");
                                            System.out.println(orderProductNo+"<--orderProductNo-- orderProductList.jsp");
                                            System.out.println(m.get("orderNo")+"<--orderNo-- orderProductList.jsp");


                                            // 상품 정보 및 이미지를 가져옵니다.
                                            HashMap<String, Object> productMap = productDao.selectProductAndImgOne(productNo);
                                            Product product = (Product) productMap.get("product");
                                            ProductImg productImg = (ProductImg) productMap.get("productImg");
                                    %>
                                    <tr>
                                        <td class="cart_product_img">
                                                <%
                                                    // 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
                                                    if(productImg.getProductSaveFilename() == null) {
                                                %>
                                                    <img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
                                                <%
                                                    }else {
                                                %>
                                                    <img class="thumbnail" src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image">
                                                <%
                                                    }
                                                %>
                                        </td>
                                        <td class="cart_product_desc">
                                            <h5>
                                            	<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= productNo%>">                                            
                                            	<%= product.getProductName() %></a>
                                            </h5>
                                        </td>
                                        <td class="price">
                                            <span><%= deliveryStatus %></span>
                                        </td>
                                        <td>
                                            <!-- 버튼 분기 -->
                                            <% if (deliveryStatus.equals("주문확인중")) { %>
                                              <form action="<%= request.getContextPath() %>/orders/orderCancel.jsp" method="GET">
                                                <input type="hidden" name="orderNo" value="<%= orderNo %>">
                                                <button type="submit" class="btn amado-btn w-100">주문취소</button>
                                              </form>
                                            <% } else if (deliveryStatus.equals("배송중") || deliveryStatus.equals("배송시작") || deliveryStatus.equals("교환중")) { %>
                                              <form action="<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp" method="GET">
                                                <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
                                                <button type="submit" class="btn amado-btn w-100">수취확인</button>
                                              </form>
                                            <% } else if (deliveryStatus.equals("배송완료")) { %>
                                              <form action="<%= request.getContextPath() %>/orders/orderPurchase.jsp" method="GET">
                                                <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
                                                <button type="submit" class="btn amado-btn w-100">구매확정</button>
                                              </form>
                                            <% } else if (deliveryStatus.equals("취소중")) { %>
                                              <form action="<%= request.getContextPath() %>/orders/orderCancelWithdraw.jsp" method="GET">
                                                <input type="hidden" name="orderNo" value="<%= orderNo %>">
                                                <button type="submit" class="btn amado-btn w-100">취소철회</button>
                                              </form>
                                            <% } else if (deliveryStatus.equals("구매확정") && reviewWritten.equals("N")) { %>
                                              <form action="<%= request.getContextPath() %>/review/addReview.jsp" method="GET">
                                                <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
                                                <button type="submit" class="btn amado-btn w-100">상품평</button>
                                              </form>
                                            <% } else if (deliveryStatus.equals("취소완료")) { %>
                                              <button disabled class="custom-cancel-button">취소완료</button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                        <%} %>
                        
                      
 <!-- 페이징 -->
						<div class="pagination justify-content-center mt-50">
								<nav aria-label="navigation">
									<ul class="pagination justify-content-end mt-50">
									    <%
									        //1번 페이지보다 작은데 나오면 음수로 가버린다
									        if (minPage > 1) {
									    %>
									            <li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage-pageRange%>">이전</a></li>
									    <%
									        }
									        for(int i=minPage; i <= maxPage; i=i+1){
									            if ( i == currentPage){
									    %>
									                <li class="page-item active"><a class="page-link" href="#"><%=i %>. </a></li>
									    <%
									            }else{
									    %>
									                <li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=i%>"><%=i %>.</a></li>
									    <%
									            }
									        }
									        //maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
									        if(maxPage != lastPage ){
									    %>
									            <!-- maxPage+1해도 동일하다 -->
									            <li class="page-item"><a class="page-link"  href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage+pageRange%>">다음</a></li>
									    <%
									        }
									    %>
					    			</ul>
							</nav>
						</div>
                    </div>
            	 </div>
                <div class="row">
                </div>               
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
    <div>    
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>
    </div>
</body>
</html>