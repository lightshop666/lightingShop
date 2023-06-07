<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empDao = new EmpDao();
	//요청값 분석
    // 페이지 정보 가져오기 유효성 검사후 redirect
    System.out.println(request.getParameter("id"));
    
    if (request.getParameter("id") == null) {
       	response.sendRedirect(request.getContextPath()+"/admin/adminCustomerList.jsp");
       	
       	return;
    }
    
	
    String id = request.getParameter("id");
    
    System.out.println(id);
    
    Customer customer = empDao.selectCustomerOne(id);
    System.out.println(customer.getCstmRank());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>회원 상세보기</title>
</head>
<body>
    <h1>회원 상세보기</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminModifyCustomerAction.jsp?" method="post">
    	
    	<!--  수정하지 않는 컬럼에 경우 기존값으로 전달하기 위해 hidden으로  -->
	    <input type="hidden" name="id" value="<%=customer.getId()%>">
	    <input type="hidden" name="cstmName" value="<%=customer.getCstmName()%>">
	    <input type="hidden" name="cstmAddress" value="<%=customer.getCstmAddress()%>">
	    <input type="hidden" name="cstmEmail" value="<%=customer.getCstmEmail()%>">
	    <input type="hidden" name="cstmBirth" value="<%=customer.getCstmBirth()%>">
	    <input type="hidden" name="cstmPhone" value="<%=customer.getCstmPhone()%>">
	    <input type="hidden" name="cstmGender" value="<%=customer.getCstmGender()%>">
	    <input type="hidden" name="cstmLastLogin" value="<%=customer.getCstmLastLogin()%>">
	    <input type="hidden" name="cstmAgree" value="<%=customer.getCstmAgree()%>">
	    
	    <table class="table table-hover">
	        <tr>
	            <th class="table-info">ID</th>
	            <td><%=customer.getId()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">이름</th>
	            <td><%=customer.getCstmName()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">주소</th>
	            <td><%=customer.getCstmAddress()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">이메일</th>
	            <td><%=customer.getCstmEmail()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">생년월일</th>
	            <td><%=customer.getCstmBirth()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">전화번호</th>
	            <td><%=customer.getCstmPhone()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">성별</th>
	            <td><%=customer.getCstmGender()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">등급</th>
	            <td>
	                <select name="rank">
	                    <option value="금" <%=customer.getCstmRank().equals("금") ? "selected" : ""%>>금</option>
	                    <option value="은" <%=customer.getCstmRank().equals("은") ? "selected" : ""%>>은</option>
	                    <option value="동" <%=customer.getCstmRank().equals("동") ? "selected" : ""%>>동</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th class="table-info">포인트</th>
	            <td>현재: <%=customer.getCstmPoint()%> 변경: <input type="text" name="cstmPoint"></td>
	        </tr>
	        <tr>
	            <th class="table-info">최종 로그인</th>
	            <td><%=customer.getCstmLastLogin()%></td>
	        </tr>
	        <tr>
	            <th class="table-info">약관 동의</th>
	            <td><%=customer.getCstmAgree()%></td>
	        </tr>
	    </table>
	     <div style="text-align:left;">
	        <button type="submit" class="btn btn-dark">수정하기</button>
	    </div>
    </form>
</body>
</html>