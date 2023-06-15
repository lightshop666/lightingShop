<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//session 유효성 검사 -> 비로그인인 경우 홈으로 리디렉션
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>배송지 추가</h1>
	<form action="<%=request.getContextPath()%>/customer/addAddressAction.jsp" method="post">
		<table class="table">
			<tr>
				<td>배송지명을 입력하세요</td>
				<td>
					<input type="text" name="addressName">
				</td>
			</tr>
			<tr>
				<td>배송지를 입력하세요</td>
				<td><textarea rows="3" cols="50" name="address"></textarea></td>
			</tr>
			<tr>
				<td>기본 배송지</td>
				<td>
					<select name="defaultAddress">
						<option value="">선택하세요</option>
						<option value="Y">기본배송지로 선택</option>
						<option value="N">기본배송지 미선택</option>
					</select>
				</td>
			</tr>
		</table>
		<button type="submit">추가</button>
	</form>
	
	<!-- js 유효성 검사 - DOM API 사용 -->
	<script>
	
    document.querySelector('form').addEventListener('submit', function(event) {
      
       let addressNameInput = document.querySelector('input[name="addressName"]');
       let addressInput = document.querySelector('textarea[name="address"]');
	   let defaultAddressInput = document.querySelector('select[name="defaultAddress"]');
       
       if (addressNameInput.value.trim() === '') {
           event.preventDefault();
           alert('배송지명를 입력해주세요.');
           return;
       } 
	
       if (addressInput.value.trim() === '') {
           event.preventDefault();
           alert('주소를 입력해주세요.');
           return;
       } 
       
       if (defaultAddressInput.value.trim() === '') {
           event.preventDefault();
           alert('기본배송지를 선택해주세요.');
           return;
       } 
       
    });  
    
    </script>
</body>
</html>