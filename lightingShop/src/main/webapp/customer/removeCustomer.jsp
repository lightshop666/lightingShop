<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션검사
	if (session.getAttribute("loginIdListId") == null) { // 비회원이면 홈으로
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//인코딩은 UTF-8로
	request.setCharacterEncoding("UTF-8");
	
%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 브라우저 방문기록 기준으로 이전 페이지로 돌아감 -->
	<script>
		function goBack() {
		  window.history.back();
		}
	</script>
	<button onclick="goBack()">뒤로 가기</button>
		
	<div style="margin-top: 35px;"></div>
	
	<div class="container">
		<h3>회원탈퇴</h3>
		
		<br>
		
		<div class="text-left mb-5">
				<div>사용하고 계신 아이디는 탈퇴할 경우 <span style="font-weight:bold; color:red;">재사용 및 복구가 불가능</span>합니다.</div>
				<br>
				<div>탈퇴 후 회원정보 및 개인형 서비스 이용기록은 모두 삭제됩니다.</div>
				<br>
				<div>모든 내용을 확인하셨으면 동의에 체크 후 비밀번호를 입력해주세요.</div>
				<hr>
				<small>
					<input type="checkbox" class="removeCk" name="cstmAgree" checked="checked">&nbsp;&nbsp;안내사항을 모두 확인하였으며, 이에 동의합니다
				</small>
		</div>
		<form method="post" action="<%=request.getContextPath() %>/customer/removeCustomerAction.jsp">
			<table class="table table-hover" style="text-align: center">
				<tr>
					<td>비밀번호</td>
					<td><input type="password" class="form-control" name="lastPw"></td>
				</tr>
				<tr>
					<td>탈퇴사유를 선택해주세요</td>
					<td>
						<select name="cstmGender">
						<option value="">선택하세요</option>
						<option value="">디자인이 별로임</option>
						<option value="">물건이 부족함</option>
						<option value="">기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2"><button type="submit" class="btn btn-danger btn-sm">회원탈퇴</button></td>
				</tr>
			</table>
		</form>
	</div>
		
	<div style="margin-top: 60px;"></div>
		
</body>
</html>