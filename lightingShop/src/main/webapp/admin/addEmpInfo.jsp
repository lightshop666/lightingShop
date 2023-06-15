<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//id 유효성 검사 및 디버깅
	System.out.println(request.getParameter("id")+"<--addEmp id");
	if (request.getParameter("id") == null) {
	   	response.sendRedirect(request.getContextPath()+"/admin/addEmp.jsp");
	   	
	   	return;
	}	
	
	String msg = null;
	if (request.getParameter("msg") != null) {
	 	msg = request.getParameter("msg");
	}
	
	String id = request.getParameter("id");
	
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원정보 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        
        h1 {
            text-align: center;
            margin-top: 30px;
        }
        
        form {
            margin: 20px auto;
            max-width: 500px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }
        
        table {
            width: 100%;
        }
        
        th {
            background-color: #eee;
            padding: 10px;
            text-align: left;
        }
        
        td {
            padding: 10px;
        }
        
        select {
            width: 100%;
            padding: 5px;
            border-radius: 3px;
            border: 1px solid #ccc;
        }
        
        button {
            background-color: #343a40;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #23272b;
        }
    </style>
       <script>
        <% 
        	if (msg != null) { 
        %>
            	alert('<%= msg %>');
        <% 
        	}         
        %>
    </script>
</head>
<body>
	<!--관리자 메인메뉴 -->
	<jsp:include page ="/admin/adminMenu.jsp"></jsp:include>
	<br>
	<!-- 본문 -->
    <h1>직원정보 등록</h1>
    
    <form action="<%=request.getContextPath()%>/admin/addEmpInfoAction.jsp" method="post">
       	
	    <table>
	        <tr>
	            <th>ID</th>
	            <td><input type="text" name="id" value="<%=id%>" readonly="readonly"></td>
	        </tr>
	        <tr>
	            <th>이름</th>
	            <td><input type="text" name="empName"></td>
	        </tr>
	        <tr>
	            <th>등급</th>
	            <td>
	                <select name="empLevel">
	                    <option value="1">1</option>
	                    <option value="3">3</option>
	                    <option value="5">5</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th>번호</th>
	            <td><input type="text" name="empPhone"></td>
	            
	        </tr> 
	    </table>
	     <div style="text-align:center">
	     	   <button id="backBtn" type="button">뒤로가기</button>
	           <button type="submit">추가하기</button>
	    </div>
	    <script>
	 		// 돔객체.addEventListener('이벤트이름', 실행코드함수)
		    document.querySelector('#backBtn').addEventListener('click',function(){
				// BOM window.history객체
				history.back();
			});
	 		
		    document.querySelector('form').addEventListener('submit', function(event) {
	
	            let empInput = document.querySelector('input[name="empName"]');
	            let phoneInput = document.querySelector('input[name="empPhone"]');

	            if (empInput.value.trim() === '') { //trim 앞뒤 공백 제거
	                event.preventDefault();
	                alert('이름를 입력해주세요.');
	                return;
	            }

	            if (phoneInput.value.trim() === '') { //trim 앞뒤 공백 제거
	                event.preventDefault();
	                alert('번호를 입력해주세요.');
	                return;
	            }
		    });
		    
		</script>  
    </form>
</body>
</html>