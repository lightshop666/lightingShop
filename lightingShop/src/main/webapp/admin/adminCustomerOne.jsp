<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empDao = new EmpDao();
    // 요청값 분석
    // 페이지 정보 가져오기 유효성 검사후 redirect
    System.out.println(request.getParameter("id"));

    if (request.getParameter("id") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminCustomerList.jsp");

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
<style>
<style>
    body {
        font-family: Arial, sans-serif;
        padding: 20px;
        background-color: #f2f2f2;
    }

    h1 {
        margin-bottom: 20px;
        color: #333;
    }

    table {
        width: 50%;
        margin-bottom: 20px;
        background-color: #ffffff;
        border-collapse: separate;
        border-spacing: 0;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    th, td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ccc;
    }

    th {
        background-color: #f2f2f2;
        color: #333;
        font-weight: bold;
    }

    select {
        padding: 5px;
        width: 100px;
    }

    input[type="text"] {
        padding: 5px;
        width: 100px;
    }

    button[type="submit"] {
        padding: 10px 20px;
        background-color: #333;
        color: #fff;
        border: none;
        cursor: pointer;
</style>
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

    <table>
        <tr>
            <th>ID</th>
            <td><%=customer.getId()%></td>
        </tr>
        <tr>
            <th>이름</th>
            <td><%=customer.getCstmName()%></td>
        </tr>
        <tr>
            <th>주소</th>
            <td><%=customer.getCstmAddress()%></td>
        </tr>
        <tr>
            <th>이메일</th>
            <td><%=customer.getCstmEmail()%></td>
        </tr>
        <tr>
            <th>생년월일</th>
            <td><%=customer.getCstmBirth()%></td>
        </tr>
        <tr>
            <th>전화번호</th>
            <td><%=customer.getCstmPhone()%></td>
        </tr>
        <tr>
            <th>성별</th>
            <td><%=customer.getCstmGender()%></td>
        </tr>
        <tr>
            <th>등급</th>
            <td>
                <select name="rank">
                    <option value="금" <%=customer.getCstmRank().equals("금") ? "selected" : ""%>>금</option>
                    <option value="은" <%=customer.getCstmRank().equals("은") ? "selected" : ""%>>은</option>
                    <option value="동" <%=customer.getCstmRank().equals("동") ? "selected" : ""%>>동</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>포인트</th>
            <td>현재: <%=customer.getCstmPoint()%> 변경: <input type="text" name="cstmPoint"></td>
        </tr>
        <tr>
            <th>최종 로그인</th>
            <td><%=customer.getCstmLastLogin()%></td>
        </tr>
        <tr>
            <th>약관 동의</th>
            <td><%=customer.getCstmAgree()%></td>
        </tr>
    </table>
    <div>
        <button type="submit"  style = "color: #fff; border: none; cursor: pointer;">수정하기</button>
    </div>
</form>
</body>
</html>