<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
/*세션검사
if (!session.getAttribute("loginIdListEmpLevel").equals("3")) { // 직원레벨 5가 아니면
	String msg = "접근권환이 없습니다.";
	response.sendRedirect(request.getContextPath() + "/admin/home.jsp?msg="+msg);
	return;
}
*/	
    EmpDao empdao = new EmpDao();
	
    // 요청값 분석
    // 페이지 정보 가져오기 유효성 검사 후 리디렉트
    
    int pointNo = 0;
    if (request.getParameter("pointNo") != null) {
    	pointNo = Integer.parseInt(request.getParameter("pointNo"));
    }
    
    //가져온 값들 확인하기
    System.out.println(request.getParameter("action"));
    
    //action 유효성검사(활성or비활성) 
    if(request.getParameter("action")==null){
    	response.sendRedirect(request.getContextPath()+"/admin/adminPointList.jsp");
    	return;
     }
    
    String action = request.getParameter("action");
    
  
    
    // 포인트정보 가져오기
    HashMap<String, Object> point = empdao.selectPointOne(pointNo);
    
    // 카테고리 배열 만들어주기
    String[] pointInfo = {"관리자", "상품", "리뷰"};
    
    // 포인트정보 변환해주기
    String id = (String)point.get("id");
    int orderNo = (Integer) point.get("orderNo");
    String createdate = (String) point.get("createdate");
   
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>포인트 지급/차감</title>
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
<form action="<%=request.getContextPath()%>/admin/adminModifyPointAction.jsp?" method="post">
	<%
    	if(action.equals("P")){
    %>	
  	<h1>포인트 지급</h1>
   	<%
    
    	}else if(action.equals("M")){
    %>	
    <h1>포인트 차감</h1>
    <% 
    	}
	
    %>
    
    <!-- 수정하지 않는 컬럼에 대한 기존값 전달을 위해 hidden으로 설정 -->
    <input type="hidden" name="id" value="<%=id%>">
    <input type="hidden" name="orderNo" value="<%=orderNo%>">
    <input type="hidden" name="pointNo" value="<%=pointNo%>">
    <input type="hidden" name="pointPm" value="<%=action%>">
    <input type="hidden" name="pointInfo" value="관리자">
     <table>
        <tr>
            <th>ID</th>
            <td><%=id%></td>
        </tr>
        <tr>
            <th>orderNo</th>
            <td><%=orderNo%></td>
        </tr>
        <tr>
            <th>pointPm</th>
            <td><%=action%></td>
        </tr>
        <tr>
            <th>pointInfo</th>
            <td>관리자</td>
        </tr>
        <tr>
            <th>point(적용할 포인트)</th>
            <td><input type="text" name="point" required="required"></td>
        </tr>   
    </table>
    <div>
        <button type="submit"  style = "color: #fff; border: none; cursor: pointer;">처리하기</button>
    </div>
</form>
    
</body>
</html>