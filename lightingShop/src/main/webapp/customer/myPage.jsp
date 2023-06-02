<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	// 세션검사
	if (session.getAttribute("loginIdListId") != null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
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
	<%
		// 로그인했다면 마이페이지
		if(session.getAttribute("loginIdListId") != null) {
	%>
		<!-- 내정보 상세보기 -->
		<a type="button" class="btn btn-dark" href="<%=request.getContextPath()%>/customer/customerOne.jsp" role="button">내정보 상세보기</a>
		
		<!-- 주문내역 -->
		
		<!-- 등급확인 -->
		
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