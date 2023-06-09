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
        response.sendRedirect(request.getContextPath() + "/admin/adminEmpList.jsp");
        return;
    }

    String id = request.getParameter("id");

    System.out.println(id);

    Employees employee = empDao.selectEmpOne(id);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원 상세보기</title>
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

        select, input[type="text"] {
            padding: 5px;
            width: 100px;
        }

        button[type="submit"] {
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        .table-info {
            background-color: #f2f2f2;
            color: #333;
            font-weight: bold;
        }
    </style>
</head>
<body>
	<!--관리자 메인메뉴 -->
	<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
	<br>
	<!-- 본문 -->
	<h1>직원 상세보기</h1>

	<form action="<%=request.getContextPath()%>/admin/adminModifyEmpAction.jsp?" method="post">

    <!-- 수정하지 않는 컬럼에 경우 기존값으로 전달하기 위해 hidden으로 -->
    <input type="hidden" name="id" value="<%=employee.getId()%>">
    <input type="hidden" name="createdate" value="<%=employee.getCreatedate()%>">
    <input type="hidden" name="updatedate" value="<%=employee.getUpdatedate()%>">

    <table>
        <tr>
            <th class="table-info">ID</th>
            <td><%=employee.getId()%></td>
        </tr>
        <tr>
            <th class="table-info">이름</th>
            <td><input type="text" name="empName" value="<%=employee.getEmpName()%>"></td>
        </tr>
        <tr>
            <th class="table-info">등급</th>
            <td>
                <select name="empLevel">
                    <option value="1" <%=employee.getEmpLevel().equals("1") ? "selected" : ""%>>1</option>
                    <option value="3" <%=employee.getEmpLevel().equals("3") ? "selected" : ""%>>3</option>
                    <option value="5" <%=employee.getEmpLevel().equals("5") ? "selected" : ""%>>5</option>
                </select>
            </td>
        </tr>
        <tr>
            <th class="table-info">번호</th>
            <td><input type="text" name="empPhone" value="<%=employee.getEmpPhone()%>"></td>
        </tr>
        <tr>
            <th class="table-info">생성날짜</th>
            <td><%=employee.getCreatedate()%></td>
        </tr>
        <tr>
            <th class="table-info">업데이트날짜</th>
            <td><%=employee.getUpdatedate()%></td>
        </tr>
    </table>
    <div style="text-align: left;">
        <button type="submit">수정하기</button>
    </div>
</form>
</body>
</html>