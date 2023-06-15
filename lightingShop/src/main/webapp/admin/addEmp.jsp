<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	/*세션검사
	if (!session.getAttribute("loginIdListEmpLevel").equals("5")) { // 직원레벨 5가 아니면
		response.sendRedirect(request.getContextPath() + "/admin/home.jsp");
		return;
	}
	*/
	
	String msg = null;
	if (request.getParameter("msg") != null) {
	 	msg = request.getParameter("msg");
	}

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원 추가</title>
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
    <h1>직원 추가</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminAddEmpAction.jsp" method="post">  		
	    <table>
	        <tr>
	            <th>ID</th>
	            <td><input type="text" name="id"></td>
	        </tr>
	        <tr>
	            <th>Pw</th>
	            <td><input type="text" name="lastPw"></td>
	        </tr>
	        <tr>
	            <th>ID Active</th>
	         	<td>   
		            <select name="active">
		                    <option value="Y">Y</option>
		                    <option value="N">N</option>
		            </select>
	 			</td>	       
	        </tr>
	    </table>   
	    <br> 
	     <div style="text-align:left;">
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
		   	
		        // 이전 에러 텍스트 제거
		        let previousErrorText = document.querySelector('.error-message');
		        if (previousErrorText) {
		            previousErrorText.parentNode.removeChild(previousErrorText);
		        }
		        	
		            let idInput = document.querySelector('input[name="id"]');
		            let passwordInput = document.querySelector('input[name="lastPw"]');

		            if (idInput.value.trim() === '') { //trim 앞뒤 공백 제거
		                event.preventDefault();
		                alert('아이디를 입력해주세요.');
		                return;
		            }

		            if (passwordInput.value.trim() === '') { //trim 앞뒤 공백 제거
		                event.preventDefault();
		                alert('비밀번호를 입력해주세요.');
		                return;
		            }

		            let password = passwordInput.value.trim();
		        	
		        	if (isNaN(password) { //productStockInput 요소의 값이 숫자로만 구성되어 있지 않을 때 실행
		            event.preventDefault();
		            document.querySelector('input[name="lastPw"]').value = '';
		            document.querySelector('input[name="lastPw"]').style.borderColor = 'red';
		            let errorText = document.createElement('span');
		            errorText.className = 'error-message';
		            errorText.style.color = 'red';
		            errorText.textContent = '비밀번호는 숫자만 입력가능.';
		            document.querySelector('input[name="lastPw"]').parentNode.insertBefore(errorText, document.querySelector('input[name="lastPw"]').nextSibling);
		        }
		    });
		    
		</script>  
    </form>
</body>
</html>