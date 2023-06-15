<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.Discount" %>
<%
    EmpDao empDao = new EmpDao();

    // 요청값 분석
    // 할인 번호 가져오기 유효성 검사 후 리디렉트
    if (request.getParameter("discountNo") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminDiscountList.jsp");
        return;
    }

    int discountNo = Integer.parseInt(request.getParameter("discountNo"));

    // 할인 상세 정보 가져오기
    Discount discount = empDao.selectDiscountOne(discountNo);

    // 할인 정보를 제외한 모든 항목 가져오기
    int productNo = discount.getProductNo();
    String discountStart = discount.getDiscountStart();
    String discountEnd = discount.getDiscountEnd();
    double discountRate = discount.getDiscountRate();
    String createdate = discount.getCreatedate();
    String updatedate = discount.getUpdatedate();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>할인 상세보기</title>
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
    <!-- 관리자 메인메뉴 -->
    <jsp:include page="/admin/adminMenu.jsp"></jsp:include>
    <br>
    <!-- 본문 -->
    <h1>할인 상세보기</h1>

    <form action="<%=request.getContextPath()%>/admin/adminModifyDiscountAction.jsp" method="post">
        <!-- 수정하지 않는 컬럼에 대한 기존값 전달을 위해 hidden으로 설정 -->
        <input type="hidden" name="discountNo" value="<%=discountNo%>">
        <input type="hidden" name="productNo" value="<%=productNo%>">
        <input type="hidden" name="createdate" value="<%=createdate%>">
        <input type="hidden" name="updatedate" value="<%=updatedate%>">

        <table>
            <tr>
                <th class="table-info">할인 시작일</th>
                <td><input type="datetime-local" name="discountStart" value="<%=discountStart%>"></td>
            </tr>
            <tr>
                <th class="table-info">할인 종료일</th>
                <td><input type="datetime-local" name="discountEnd" value="<%=discountEnd%>"></td>
            </tr>
            <tr>
                <th class="table-info">할인율</th>
                <td><input type="text" name="discountRate" value="<%=discountRate%>"></td>
            </tr>
        </table>

        <div style="text-align: left;">
            <button type="submit" class="btn btn-dark">수정하기</button>
        </div>
    </form>
</body>
</html>