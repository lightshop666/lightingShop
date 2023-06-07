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
<title>modifyQuestion</title>
</head>
<body>
	<h1>문의 수정</h1>
	<!-- msg 발생시 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	<form action="<%=request.getContextPath()%>/board/modifyQuestionAction.jsp" method="post">
	<input type="hidden" name="qNo" value="<%=qNo%>"> <!-- pNo는 수정불가 -->	
	<input type="hidden" name="qId" value="<%=question.getId()%>"> <!-- pId는 수정불가 -->	
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
								<img src="<%=request.getContextPath()%>/<%=productImg.getProductPath()%>/<%=productImg.getProductSaveFilename()%>" >
								<br><%=product.getProductName()%>
							</td>
						</tr>
				<%
					}
				%>
			<tr>
				<!-- 수정 가능 -->
				<th>문의 유형</th>
				<td>
					<select name="qCategory">
						<option value="상품" <%if(question.getqCategory().equals("상품")) {%> selected <%}%>>
							상품
						</option>
						<option value="교환/환불" <%if(question.getqCategory().equals("교환/환불")) {%> selected <%}%>>
							교환/환불
						</option>
						<option value="결제" <%if(question.getqCategory().equals("결제")) {%> selected <%}%>>
							결제
						</option>
						<option value="배송" <%if(question.getqCategory().equals("배송")) {%> selected <%}%>>
							배송
						</option>
						<option value="기타" <%if(question.getqCategory().equals("기타")) {%> selected <%}%>>
							기타
						</option>
					</select>
				</td>
			</tr>
			<tr>
				<!-- 수정 가능 -->
				<th>제목</th>
				<td>
					<input type="text" name="qTitle" value="<%=question.getqTitle()%>">
				</td>
			</tr>
			<tr>
				<!-- 수정 가능 -->
				<th>내용</th>
				<td>
					<textarea rows="3" cols="30" name="qContent"><%=question.getqContent()%></textarea>
				</td>
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
				<!-- 수정 가능 -->
				<th>공개/비공개</th>
				<td>
					<input type="radio" name="privateChk" value="N" <%if(question.getPrivateChk().equals("N")) { %> checked <% } %>>공개
					<input type="radio" name="privateChk" value="Y" <%if(question.getPrivateChk().equals("Y")) { %> checked <% } %>>비공개
				</td>
			</tr>
			<!-- 작성자 아이디와 현재 로그인 아이디가 일치하는 경우 비밀번호 입력란 출력X -->
			<%
				if(session.getAttribute("loginIdListId") == null
						|| !session.getAttribute("loginIdListId").equals(question.getId())) {
			%>
					<tr>
						<th>비밀번호</th>
						<td><input type="text" name="inputPw"></td>
					</tr>
			<%
				}
			%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/board/questionOne.jsp?qNo=<%=qNo%>">
					 	취소
					</a>
				</td>
				<td>
					<button type="submit">수정</button>
				</td>
			<tr>
		</table>
	</form>
	<!-- 답변 내용 단순 출력 -->
	<h1>답변 내용</h1>
	<%
		if(answer.getaContent() != null) {
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
		} else {
	%>
			<h4>관리자가 확인 후 답변 드리겠습니다</h4>
	<%
		}
	%>
</body>
</html>