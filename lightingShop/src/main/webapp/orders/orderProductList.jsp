<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "user1";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
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
	int rowPerPage = 3;
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = orderProductDao.customerOrderListCnt(loginMemberId);
	
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
	ArrayList<Orders> orderList  = orderDao.justOrders(beginRow, rowPerPage, loginMemberId);   
	ArrayList<HashMap<String, Object>> orderByOrderProduct = new ArrayList<HashMap<String, Object>>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모든 주문 내역</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	
	/*이미지 사이즈, 클릭시 풀스크린*/
	.thumbnail {
    max-width: 200px;
    cursor: pointer;
  	}
	.fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background-color: white;
    display: flex;
    align-items: center;
    justify-content: center;
  	}
	.fullscreen img {
    max-width: 80%;
    max-height: 80%;
	}
</style>
</head>
<body>
<div class="container">	
<h1>주문내역 리스트</h1>
	<div>	<!-- 
			템플릿 적용 후 수정 사항
			모든 리뷰 출력, 글 누르면 상품페이지로
			사진 누르면 사진 확대
		 -->
	<%
	System.out.println(orderList.size()+"<--orderList.size()-- orderProductList.jsp");
		for (Orders o : orderList) {
			int orderNo = o.getOrderNo();
			System.out.println(orderNo+"<--getOrderNo-- orderProductList.jsp");
	%>

			<h4>주문 번호 : <%= orderNo %></h4>
			<p>
				<a href="<%=request.getContextPath()%>/orders/orderProductOne.jsp?orderNo=<%= orderNo %>">
				주문 상세
				</a>
			</p>
			<p>주문일: <%= o.getCreatedate() %></p>
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
				<p>상세상품번호 : <%= productNo%></p>			
				<p>배송 상태: <%= deliveryStatus %></p>
				<p>상품 이미지
					<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= productNo%>">
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
					</a>
				</p>
				<p>상품 이름
					<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%= productNo%>">
						<%= product.getProductName() %>
					</a>
				</p>	
<p><!-- 버튼 분기 -->
<% if (deliveryStatus.equals("주문확인중")) { %>
  <form action="<%= request.getContextPath() %>/orders/orderCancel.jsp" method="GET">
    <input type="hidden" name="orderNo" value="<%= orderNo %>">
    <button type="submit">주문취소</button>
  </form>
<% } else if (deliveryStatus.equals("배송중") || deliveryStatus.equals("배송시작") || deliveryStatus.equals("교환중")) { %>
  <form action="<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp" method="GET">
    <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
    <button type="submit">수취확인</button>
  </form>
<% } else if (deliveryStatus.equals("배송완료")) { %>
  <form action="<%= request.getContextPath() %>/orders/orderPurchase.jsp" method="GET">
    <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
    <button type="submit">구매확정</button>
  </form>
<% } else if (deliveryStatus.equals("취소중")) { %>
  <form action="<%= request.getContextPath() %>/orders/orderCancelWithdraw.jsp" method="GET">
    <input type="hidden" name="orderNo" value="<%= orderNo %>">
    <button type="submit">취소철회</button>
  </form>
<% } else if (deliveryStatus.equals("구매확정") && reviewWritten.equals("N")) { %>
  <form action="<%= request.getContextPath() %>/review/addReview.jsp" method="GET">
    <input type="hidden" name="orderProductNo" value="<%= orderProductNo %>">
    <button type="submit">상품평</button>
  </form>
<% } else if (deliveryStatus.equals("취소완료")) { %>
  <button disabled>취소완료</button>
<% } %>
</p>

	<%
			}
	%>
		<hr>
	<%
		}
	%>
	</div>
	
	
	<div class="center" >
	<%
		//1번 페이지보다 작은데 나오면 음수로 가버린다
		if (minPage > 1) {
	%>
			<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage-pageRange%>">이전</a>
	
	<%	
		}
		for(int i=minPage; i <= maxPage; i=i+1){
			if ( i == currentPage){		
	%>
				<span><%=i %></span>
	<%
			}else{
	%>
				<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=i%>"><%=i %></a>
	<%
			}
		}
	
		//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
		if(maxPage != lastPage ){
	%>
			<!-- maxPage+1해도 동일하다 -->
			<a href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage+pageRange%>">다음</a>
	<%
		}
	%>
	
	</div>
</div>
</body>
</html>