<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");	

	// 1. 유효성 검사
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	int searchPrice1 = 0;
	if(request.getParameter("searchPrice1") != null && !request.getParameter("searchPrice1").equals("")) {
		searchPrice1 = Integer.parseInt(request.getParameter("searchPrice1"));
	}
	int searchPrice2 = 0;
	if(request.getParameter("searchPrice2") != null && !request.getParameter("searchPrice2").equals("")) {
		searchPrice2 = Integer.parseInt(request.getParameter("searchPrice2"));
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
	CategoryDao dao2 = new CategoryDao();
	// 상품 검색
	ArrayList<HashMap<String, Object>> list = dao.searchResultListByPage(searchWord, categoryName, searchPrice1, searchPrice2, orderBy, beginRow, rowPerPage);
	// 카테고리 조회
	List<String> categoryList = dao2.getCategoryList();
	
	// 2-2. 페이지 출력부
	int pagePerPage = 5;
	int beginPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
	int endPage = beginPage + (pagePerPage - 1);
	// 검색 결과 상품 수 메서드 호출
	int totalRow = dao.searchResultCnt(searchWord, categoryName, searchPrice1, searchPrice2);
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
<title>searchResult</title>
</head>
<body>
	<h1>검색 결과 페이지</h1>
	<!-- searchWord의 검색결과 총 totalRow건 -->
	<!-- 검색어(직접 입력), 카테고리(선택), 가격(직접 입력) -->
	<form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
		<table>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" name="searchWord" value="<%=searchWord%>">
				</td>
			</tr>
			<tr>
				<th>카테고리</th>
				<td>
					<!-- CategoryDao 사용해서 버튼 출력, categoryName -->
					<%
						for(String s : categoryList) {
							if(!s.equals("관리자")) { // 관리자 카테고리는 출력하지 않는다
					%>
							<input type="radio" name="categoryName" value="<%=s%>" <%if(categoryName.equals(s)) {%> checked <%}%>><%=s%>
					<%
						
							}
						}
					%>
				</td>
			</tr>
			<tr>
				<th>가격</th>
				<td>
					<input type="number" name="searchPrice1" value="<%=searchPrice1%>">원
					~
					<input type="number" name="searchPrice2" value="<%=searchPrice2%>">원
				</td>
			</tr>
		</table>
		<button type="submit">검색</button>
	총 <%=totalRow%>개의 상품
	<!-- 정렬기능 : 신상품순, 낮은 가격순, 높은 가격순 -->
		<select name="orderBy" onchange="this.form.submit()">
			<option value="newItem" <%if(orderBy.equals("newItem")) {%> selected <%}%>>신상품순</option>
			<option value="lowPrice" <%if(orderBy.equals("lowPrice")) {%> selected <%}%>>낮은 가격순</option>
			<option value="highPrice" <%if(orderBy.equals("highPrice")) {%> selected <%}%>>높은 가격순</option>
		</select>
	</form>
	<!-- 검색 결과 상품 출력, 상품 이름 or 이미지 클릭시 해당 상품 상세로 이동 -->
	<%
		for(HashMap<String, Object> m : list) {
			if(!m.get("categoryName").equals("관리자")) { // 관리자 카테고리는 출력하지 않는다
	%>
				<div>
					<!-- 상품 이미지 or 이름 클릭시 상품 상세로 이동 -->
					<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=m.get("prodcutNo")%>">
						<!-- 상품 이미지 -->
						<img src="<%=request.getContextPath()%>/<%=m.get("productImgPath")%>/<%=m.get("productImgSaveFilename")%>">
						<!-- 상품 이름 --><br>
						<%=m.get("productName")%>[<%=m.get("productStatus")%>]
					</a>
					<!-- 할인유무에 따라 분기 -->
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
		}
	%>
	<!------------------ 페이지 출력부 ------------------>
	<%
		// 이전은 1페이지에서는 출력되면 안 된다
		if(beginPage != 1) {
	%>
			<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=beginPage - 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>">
				&laquo;
			</a>
	<%
		}
	
		for(int i = beginPage; i <= endPage; i++) {
			if(i == currentPage) { // 현재페이지에서는 a태그 없이 출력
	%>
				<span><%=i%></span>&nbsp;
	<%
			} else {
	%>
				<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>">
					<%=i%>
				</a>&nbsp;
	<%
			}
		}
		// 다음은 마지막 페이지에서는 출력되면 안 된다
		if(endPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/product/SearchResult.jsp?currentPage=<%=endPage + 1%>&rowPerPage=<%=rowPerPage%>&categoryName=<%=categoryName%>&orderBy=<%=orderBy%>&searchPrice1=<%=searchPrice1%>&searchPrice2=<%=searchPrice2%>&searchWord=<%=searchWord%>">
				&raquo;
			</a>
	<%
		}
	%>
</body>
</html>