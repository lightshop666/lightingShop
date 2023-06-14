<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	
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
	<form action="<%=request.getContextPath()%>/product/searchResult.jsp" method="post">
		<table>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" name="searchWord">
				</td>
			</tr>
			<tr>
				<th>카테고리</th>
				<td>
					<!-- CategoryDao 사용해서 버튼 출력, categoryName -->
				</td>
			</tr>
			<tr>
				<th>가격</th>
				<td>
					<input type="number" name="searchPrice1">원
					~
					<input type="number" name="searchPrice2">원
				</td>
			</tr>
		</table>
	</form>
	<!-- 정렬기능 : 신상품순, 낮은 가격순, 높은 가격순 -->
	<!-- 검색 결과 상품 출력, 상품 이름 or 이미지 클릭시 해당 상품 상세로 이동 -->
</body>
</html>