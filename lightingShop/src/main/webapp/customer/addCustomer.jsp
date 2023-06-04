<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	//session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginIdListId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
</head>
<body>
<h1>회원 가입 페이지</h1>

	<form action="<%=request.getContextPath()%>/customer/addCustomerAction.jsp" method="post">
		<table class="table">
		<tr>
			<td><input type="hidden" name="cstmRank" value="동"></td>
		</tr>
			<tr>
				<td>아이디를 입력하세요</td>
				<td>
					<input type="text" name="id">
				</td>
			</tr>
			<tr>
				<td>비밀번호를 입력하세요</td>
				<td><input type="password" name="lastPw" placeholder="4자"></td>
			</tr>
			<tr>
				<td>사용자 이름을 입력하세요</td>
				<td><input type="text" name="cstmName"></td>
			</tr>
			<tr>
				<td>배송지명을 입력해주세요</td>
				<td><input type="text" name="addressName"></td>
			</tr>
			<tr>
				<td>주소를 입력해주세요</td>
				<td><textarea rows="3" cols="50" name="cstmAddress"></textarea></td>
			</tr>
			<tr>
				<td>이메일을 입력해주세요</td>
				<td><input type="email" name="cstmEmail" placeholder="abcb@gmail.com"></td>
			</tr>
			<tr>
				<td>생년월일을 입력해주세요</td>
				<td><input type="date" name="cstmBirth"></td>
			</tr>
			<tr>
				<td>전화번호를 입력해주세요</td>
				<td><input type="text" name="cstmPhone" placeholder="010-1234-5678"></td>
			</tr>
			<tr>
				<td>성별</td>
				<td>
					<select name="cstmGender">
					<option value="">선택하세요</option>
					<option value="남성">남성</option>
					<option value="여성">여성</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>약관에 동의하시겠습니까?</td>
				<td><input type="checkbox" name="cstmAgree" value="Y"></td>
			</tr>
		</table>
		<button type="submit">회원가입</button>
	</form>
</body>
</html>