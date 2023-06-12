<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 나의배송지 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	CustomerDao cDao = new CustomerDao();
	Address address = new Address();
	address.setId(sessionId);
	// 배송지리스트 불러옴
	ArrayList<Address> list = cDao.myAddressList(address);
%>   

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
          
    <!-- 주소목록 -->
    <h3><%=address.getId()%>님의 배송지목록</h3>
    <div><a href="<%=request.getContextPath()%>/customer/addAddress.jsp" >배송지 추가</a></div>
      <form action="<%=request.getContextPath()%>/customer/myPage.jsp">
	      <table>
	      	<tr>
	      		<th>배송지명</th>
	      		<th>받는사람</th>
	      		<th>주소</th>
	      		<th>수정</th>
	      		<th>삭제</th>
	      	</tr>
			<%
				/* 리스트 3개까지 출력 - {0, 1, 2} */
				int maxCount = 3; // 최대 3개까지만 표시
			    for (int i = 0; i < list.size() && i < maxCount; i++) {
			        Address a = list.get(i);
			%>
			<tr>
				<td><%=a.getAddressName() %></td>
				<td><%=a.getId()%></td>
				<td><%=a.getAddress() %></td>
				<td>
					<a href="<%=request.getContextPath()%>/customer/modifyAddress.jsp?addressNo=<%=a.getAddressNo()%>">수정</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/customer/removeAddressAction.jsp?addressNo=<%=a.getAddressNo()%>">삭제</a>
				</td>
			</tr>
			<%
				}
			%>
	      </table>
	      	<div>	
		        <button type="submit" class="btn btn-default" onclick="<%=request.getContextPath()%>/customer/myPage.jsp">취소</button>
			</div>	 
      </form> 
    
</body>
</html>