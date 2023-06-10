<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	//모델 호출
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 5;
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = orderProductDao.CustomerOrderListCnt(loginMemberId);
	
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
	
	//orderProduct 모델 소환
	 ArrayList<HashMap<String, Object>> AllReviewList  = orderProductDao.selectCustomerOrderList(beginRow, rowPerPage, loginMemberId);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>
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
	h1{	
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
    background: rgba(0, 0, 0, 0.7);
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
		for (HashMap<String, Object> m : AllReviewList) {
			//product 모델 소환
			HashMap<String, Object> productOne =  productDao.selectProductAndImgOne((int)m.get("productNo"));
		    // productOne에서 필요한 데이터 가져오기
		    Product product = (Product) productOne.get("product");
		    ProductImg productImg = (ProductImg) productOne.get("productImg");		
	%>
			<h4>주문 번호 : <%= m.get("orderNo") %></h4>
			<p>
				<a href="<%=request.getContextPath()%>/review/reviewOne.jsp?orderNo=<%=m.get("orderNo")%>">
					주문 상세
				</a>
			</p>			
			<p>주문일: <%= m.get("createdate") %></p>
			<p>배송 상태: <%= m.get("deliveryStatus") %></p>
			<p>
			    <a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
			        <img class="thumbnail" src="<%= request.getContextPath() + "/" + productImg.getProductPath() + "/" + productImg.getProductSaveFilename() %>" alt="Product Image">
			    </a>
			</p>
			<p>
			    <a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("productNo")%>">
			        <%= product.getProductName() %>
			    </a>
			</p>			
		<%
			System.out.println(m.get("deliveryStatus"));
			System.out.println(m.get("reviewWritten"));
		    if (m.get("deliveryStatus").equals("구매확정")) {	//주문확인중 이 맞는데 임시로
		        // 주문 취소 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelAction.jsp?orderNo=<%=m.get("orderNo")%>'">주문취소</button>
		<%
		    } else if (m.get("deliveryStatus").equals("배송중")) {
		        // 수취 확인 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
		<%
		    } else if (m.get("deliveryStatus").equals("배송시작")) {
		        // 수취 확인 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
		<%
		    } else if (m.get("deliveryStatus").equals("배송완료")) {
		        // 구매 확정 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderPurchase.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">구매확정</button>
		<%
		    } else if (m.get("deliveryStatus").equals("취소중")) {
		        // 취소 철회 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderCancelWithdraw.jsp?orderNo=<%=m.get("orderNo")%>'">취소철회</button>
		<%
		    } else if (m.get("deliveryStatus").equals("교환중")) {
		        // 수취 확인 버튼 클릭 시 동작
		%>
		        <button onclick="location.href='<%= request.getContextPath() %>/orders/orderConfirmDelivery.jsp?orderProductNo=<%=m.get("orderProductNo")%>'">수취확인</button>
		<%
		    } else if (m.get("deliveryStatus").equals("구매확정")
		    && m.get("reviewWritten").equals("N")) {
		        // 상품평 버튼 클릭 시 동작
		%>
				<button onclick="location.href='<%= request.getContextPath() %>/review/addReview.jsp?orderProductNo=<%= m.get("orderProductNo") %>'">상품평</button>
		<%
		    } else if (m.get("deliveryStatus").equals("취소완료")) {
		        // 상품평 버튼 클릭 시 동작
		%>
				<button disabled>취소완료</button>
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