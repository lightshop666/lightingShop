<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>   
<%@ page import="vo.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>

<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	
	/* // 관리자인 경우에만 접근 허용
	if(session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListEmpLevel").equals("1") 
		|| session.getAttribute("loginIdListEmpLevel").equals("3")
		|| session.getAttribute("loginIdListEmpLevel").equals("5")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}  */
	
	// 유효성
	if(request.getParameter("qNo") == null
		|| request.getParameter("qNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/adminQuestionList.jsp");
		return;
	}
	
	// 변수 받기
	int qNo = Integer.parseInt(request.getParameter("qNo")); 
	
	// Dao 호출
	EmpDao eDao = new EmpDao();
	// 문의 상세 메서드 호출
	HashMap<String, Object> selectQuestionOne = eDao.selectQuestionOne(qNo);
	Question question = (Question)selectQuestionOne.get("question");
	Product product = (Product)selectQuestionOne.get("product");
	ProductImg productImg = (ProductImg)selectQuestionOne.get("productImg");
	
	// 답변 유무 체크 메서드 호출
	boolean answerCk = eDao.answerInsertCheck(qNo);
	
	// 답변 상세 메서드 호출
	HashMap<String, Object> answerOne = eDao.answerOne(qNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- questionOne내용-->
		<div class="container">
			<h2>문의</h2>
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
										<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>" >
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
					</td>
				</tr>
			</table>
		</div>

		<!-- answer - 댓글내용 -->
		<div class="container">
			<h2>답변</h2>
			<table>
				<tr>
					<th>Question No</th>
					<td><%=answerOne.get("qNo") %></td>
				<tr>
				<tr>
					<th>Answer Content</th>
					<td><%=answerOne.get("aContent") %>	</td>
				</tr>
				<tr>
					<th>Id</th>
					<td><%=answerOne.get("id") %></td>
				</tr>
				<tr>
					<th>Createdate</th>
					<td><%=answerOne.get("createdate") %></td>
				</tr>
			</table>
		</div>
		<%
		if(answerCk) { // 해당 문의글에 답변이 있을 경우
			// 수정 버튼
		%>
			<h3>답변 수정</h3>

			<form action="<%=request.getContextPath()%>/admin/modifyAnswerAction.jsp" method="post">
				<table class="table">
					<tr>
						<td colspan="2">
							<input type="hidden" name="qNo" value = "<%=qNo%>">
						</td>
					</tr>
					<tr>
						<td>수정내용을 입력하세요</td>
						<td><textarea rows="3" cols="50" name="aContent"></textarea></td>
					</tr>

				</table>
				<button type="submit">수정</button>
			</form>
		<%	
		} else { // 답변이 안달렸을 경우
			// 답변 등록 버튼 
		%>
			<h3>답변 등록</h3>

			<form action="<%=request.getContextPath()%>/admin/addAnswerAction.jsp" method="post">
				<table class="table">
					<tr>
						<td colspan="2">
							<input type="hidden" name="qNo" value = "<%=qNo%>">
						</td>
					</tr>
					<tr>
						<td>댓글내용을 입력하세요</td>
						<td><textarea rows="3" cols="50" name="aContent"></textarea></td>
					</tr>

				</table>
				<button type="submit">추가</button>
			</form>

			<%-- <a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/admin/addAnswerAction.jsp" role="button">등록</a> --%>
		<% 
			}
		%>

</body>
</html>