<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 유효성 검사 // qNo
	if(request.getParameter("qNo") == null
			|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/questionBoardList.jsp");
		return;
	}
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	// 메서드 호출
	BoardDao dao = new BoardDao();
	// 객체에 값 넣기
	HashMap<String, Object> map = dao.selectQuestionOne(qNo);
	Question question = (Question)map.get("question");
	Answer answer = (Answer)map.get("answer");
	Product product = (Product)map.get("product");
	ProductImg productImg = (ProductImg)map.get("productImg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>questionOne</title>
</head>
<body>
	<h1>
		문의
		<%
			if(question.getPrivateChk().equals("Y")) {
		%>
				(잠긴 자물쇠 아이콘)
		<%
			} else {
		%>
				(열린 자물쇠 아이콘)
		<%
			}
		%>
	</h1>
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<table>
		<tr>
			<th>글번호</th>
			<td><%=question.getqNo()%></td>
		</tr>
		<tr>
			<th>아이디</th>
			<td><%=question.getId()%></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><%=question.getqName()%></td>
		</tr>
			<%
				// 상품 선택시 (qNo가 1이 아니면) 해당 상품의 이미지와 이름 출력
				if(question.getProductNo() != 1) {
			%>
					<tr>
						<th>상품</th>
						<td>
							<!-- 상품이미지 or 상품 이름 클릭 시 해당 상품 상세페이지로 이동 -->
							<a href="<%=request.getContextPath()%>/product/productOne.jsp?productNo=<%=question.getProductNo()%>">
								<%
									// 상품 이미지가 아직 등록되지 않았으면 no_image 파일 출력
									if(productImg.getProductSaveFilename() == null) {
								%>
										<img src="<%=request.getContextPath()%>/productImg/no_image.jpg">
								<%
									} else {
								%>
										<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>">
								<%	
									}
								%>
								<br><%=product.getProductName()%>
							</a>
						</td>
					</tr>
			<%
				}
			%>
		<tr>
			<th>문의 유형</th>
			<td><%=question.getqCategory()%></td>
		</tr>
		<tr>
			<th>제목</th>
			<td><%=question.getqTitle()%></td>
		</tr>
		<tr>
			<th>내용</th>
			<td><%=question.getqContent()%></td>
		</tr>
		<tr>
			<th>작성일자</th>
			<td><%=question.getCreatedate()%></td>
		</tr>
		<tr>
			<th>수정일자</th>
			<td><%=question.getUpdatedate()%></td>
		</tr>
		<tr>
			<td>
				<a href="<%=request.getContextPath()%>/board/questionBoardList.jsp">
				 	목록으로
				</a>
				<a href="<%=request.getContextPath()%>/board/modifyQuestion.jsp?qNo=<%=qNo%>">
				 	수정
				</a>
				<a href="<%=request.getContextPath()%>/board/removeQuestion.jsp?qNo=<%=qNo%>&qId=<%=question.getId()%>">
					삭제
				</a>
			</td>
		<tr>
	</table>
	<h1>답변</h1>
	<%
		if(answer.getaContent() != null) { // 답변이 있으면
	%>
		<table>
			<tr>
				<th>작성자</th>
				<td>관리자</td>
			</tr>
			<tr>
				<th>답변내용</th>
				<td><%=answer.getaContent()%></td>
			</tr>
			<tr>
				<th>작성일자</th>
				<td><%=answer.getCreatedate()%></td>
			</tr>
			<tr>
				<th>수정일자</th>
				<td><%=answer.getUpdatedate()%></td>
			</tr>
		</table>
	<%
		} else { // 답변이 없으면
	%>
			<h4>관리자가 확인 후 답변을 남겨드리겠습니다</h4>
	<%
		}
	%>
</body>
</html>