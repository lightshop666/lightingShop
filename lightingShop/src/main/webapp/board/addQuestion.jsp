<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%
	// 요청값 검사
	// id
	String id = "guest"; // 기본값 비회원
	if(session.getAttribute("loginIdloginList") != null) {
		id = (String)session.getAttribute("loginIdloginList");
	}
	// productNo
	int productNo = 1; // 상품 선택 안했을시 기본값 관리자 코드
	if(request.getParameter("productNo") != null) {
		productNo = Integer.parseInt(request.getParameter("productNo"));
	}
	// 상품 이름 + 이미지 조회 메서드 호출
	ProductDao dao = new ProductDao();
	HashMap<String, Object> map = dao.selectProductAndImg(productNo);
	Product product = (Product)map.get("product");
	ProductImg productImg = (ProductImg)map.get("productImg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addQuestion</title>
</head>
<body>
	<h1>문의글 작성</h1>
	<%
		if(productNo != 1) {
	%>
			<table>
				<th>상품</th>
				<td>
					<!-- 상품이미지 or 상품 이름 클릭 시 해당 상품 상세페이지로 이동 -->
					<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=productNo%>">
						<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>" >
						<br><%=product.getProductName()%>
					</a>
				</td>
			</table>
	<%
		}
	%>
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/addQuestionAction.jsp" method="post">
		<input type="hidden" name="id" value="<%=id%>">
		<input type="hidden" name="productNo" value="<%=productNo%>">
		<input type="hidden" name="aChk" value="N"> <!-- 답변여부 기본값 N -->
		<table>
			<tr>
				<th>작성자</th>
				<td><input type="text" name="qName"></td>
			</tr>
			<tr>
				<th>문의 유형</th>
				<td>
					<select name="qCategory">
						<option value="상품">상품</option>
						<option value="교환/환불">교환/환불</option>
						<option value="결제">결제</option>
						<option value="배송">배송</option>
						<option value="기타">기타</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="qTitle"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea rows="3" cols="30" name="qContent"></textarea></td>
			</tr>
			<tr>
				<th>공개/비공개</th>
				<td>
					<input type="radio" name="privateChk" value="N">공개
					<input type="radio" name="privateChk" value="Y">비공개
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="text" name="qPw"></td>
			</tr>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp">
					 	취소
					</a>
				</td>
				<td>
					<button type="submit">작성</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>