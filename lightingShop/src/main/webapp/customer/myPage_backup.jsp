<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	//변수저장
	String id = (String)session.getAttribute("loginIdListId");
	String lastPw = (String)session.getAttribute("loginIdListLastPw");
	String loginMemberId = id;
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 5;
	
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage;
	
	// 객체생성 -> 로그인으로 사용
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	
	// 객체생성 -> selectCustomerOne 메서드에서 사용
	Customer customer = new Customer();
	customer.setId(id);
	
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> loginIdList = cDao.loginMethod(idList);
	
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	OrderProductDao oDao = new OrderProductDao();
	ArrayList<HashMap<String, Object>> AllReviewList = oDao.selectCustomerOrderList(beginRow, rowPerPage, loginMemberId);
	
	ProductDao pDao = new ProductDao();
	
%>

  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 브라우저 방문기록 기준으로 이전 페이지로 돌아감 -->
	<div>
		<script>
			function goBack() {
			  window.history.back();
			}
		</script>
		<button onclick="goBack()">뒤로 가기</button>
	</div>
	
	<%
		// 로그인했다면 마이페이지
		if(session.getAttribute("loginIdListId") != null) {
	%>
		<!-- 내정보 상세보기 -->
		<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/customerOne.jsp" role="button">내정보 상세보기</a>
		
		<!-- 배송지 관리 -->
		<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/addressList.jsp" role="button">배송지 관리</a>
		
		<!-- 포인트 내역 - 추가 예정-->
		<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/customerPointList.jsp" role="button">포인트 내역 확인</a>
		<!-- 주문내역 -->
	<div class="container">	
		<h1>주문내역 리스트</h1>
		<div><!-- 
				템플릿 적용 후 수정 사항
				모든 리뷰 출력, 글 누르면 상품페이지로
				사진 누르면 사진 확대
			 -->
		<%
			for (HashMap<String, Object> m : AllReviewList) {
				//product 모델 소환
				HashMap<String, Object> productOne =  pDao.selectProductAndImgOne((int)m.get("productNo"));
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
		
		<%-- 	
		<!-- 등급확인 - 등급에 따른 이미지 출력-->
		<%=id%>님의 등급은 <%=customerOne.get("c.cstm_rank")%>입니다. 
		--%>
		
		<!-- 리뷰등록, 문의등록 -->
		<div>
			<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/review/addReview.jsp" role="button">리뷰등록</a>
			<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/board/addQuestion.jsp" role="button">문의등록</a>
		</div>
	<%
		} else { // 로그인 전이라면 로그인 폼
	%>
		<!-- 로그인 폼-->
		<div>로고</div>
		<form action="<%=request.getContextPath()%>/customer/loginAction.jsp" method="post">
			<!-- 세션에 저장할 active값과 emp_level 값 -->
			<input type="hidden" name="active" value="<%=loginIdList.get("active")%>">
			<input type="hidden" name="empLevel" value="<%=loginIdList.get("empLevel")%>">
			<table>
				<tr>
					<td>아이디</td>
					<td><input type="text" name="id"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="lastPw"></td>
				</tr>
			</table>
			<button type="submit">로그인</button>
		</form>
		<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/addCustomer.jsp" role="button">회원가입</a>
	<%
			}
	%>
</body>
</html>