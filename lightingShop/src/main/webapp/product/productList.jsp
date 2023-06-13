<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");	

	// 1. 유효성 검사
	// 카테고리를 선택하지 않으면 카테고리별 상품 리스트 페이지에 올 수 없다
	/*
	if(request.getParameter("categoryName") == null
			|| request.getParameter("categoryName").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String categoryName = request.getParameter("categoryName");
	*/
	String categoryName = "스탠드"; // 테스트용
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String orderBy = "";
	if(request.getParameter("orderBy") != null) {
		orderBy = request.getParameter("orderBy");
	}
	
	// 2. 모델값
	// 2-1. 데이터 출력부
	int beginRow = (currentPage - 1) * rowPerPage;
	// 메서드 호출
	ProductDao dao = new ProductDao();
	// 해당 카테고리의 특가할인 상품 상위 n개 조회 메서드 호출
	int n = 5; // 몇개 조회할지 선택
	ArrayList<HashMap<String, Object>> discountProductList = dao.selectDiscountProductTop(categoryName, n);
	// 문의글 리스트 조회 메서드 호출
	ArrayList<HashMap<String, Object>> list = dao.selectProductListByPage(categoryName, orderBy, beginRow, rowPerPage);
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 카테고리별 상품 수 메서드 호출
	int totalRow = dao.selectProductCnt(categoryName);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>productList</title>
<style>
	div {
		display:table;
		float:left;
	}
	p {
		display:table-cell;
	}
	.font-bold {
		font-weight:bold;
	}
	.font-orange {
		color:#FF5E00;
	}
	.line-through {
	  text-decoration: line-through;
	}
</style>
</head>
<body>
	<h1>카테고리별 상품 리스트</h1>
	<!-- 배너 이미지 출력예정 -->
	
	<h1>특가 상품</h1>
	<!-- 해당 카테고리의 특가할인 상품 상위 n개 출력 -->
	<!-- (자바스크립트) 자동 슬라이드 효과 예정 -->
	<%
		for(HashMap<String, Object> m : discountProductList) {
	%>
			<div>
				<!-- 상품 이미지 or 이름 클릭시 상품 상세로 이동 -->
				<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("prodcutNo")%>">
					<!-- 상품 이미지 -->
					<img src="<%=request.getContextPath()%>/<%=m.get("productImgPath")%>/<%=m.get("productImgSaveFilename")%>">
					<!-- 상품 이름 --><br>
					<%=m.get("productName")%>[<%=m.get("productStatus")%>]
				</a>
				<!-- 상품 원가와 할인가격이 같으면 -->
				<%
					if((Double)m.get("discountRate") == 0) {
				%>
						<!-- 원가 출력 -->
						<p class="font-bold">
							<%=m.get("productPrice")%>원
						</p>
				<%
					} else {
				%>
						<!-- 할인 가격 굵게 출력 -->
						<p class="font-bold">
							<%=m.get("discountedPrice")%>원
						</p>
						<!-- 원가 취소선 출력 -->
						<p class="line-through">
							<%=m.get("productPrice")%>원
						</p>
						<!-- 할인율 -->
						<p class="font-bold font-orange">
							<%=(Double)m.get("discountRate") * 100%>%
						</p>
				<%
					}
				%>
			</div>
	<%
		}
	%>
	
	<h1><%=categoryName%>의 상품 리스트</h1>
	<!-- 해당 카테고리의 상품 리스트 출력 -->
</body>
</html>