<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    /*세션검사
    if (!session.getAttribute("loginIdListEmpLevel").equals("3")) { // 직원레벨 3가 아니면
        response.sendRedirect(request.getContextPath() + "/admin/home.jsp");
        return;
    }
    */
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>할인 추가</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }
        
        .container {
            width: 500px;
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th {
            background-color: #f8f8f8;
            color: #333;
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }
        
        td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        
        select,
        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            border-radius: 3px;
            border: 1px solid #ccc;
            outline: none;
        }
        
        textarea {
            height: 120px;
        }
        
        button {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <!-- 본문 -->
    <div class="container">
        <h1>할인 추가</h1>
        
        <form action="<%=request.getContextPath()%>/admin/adminAddDiscountAction.jsp" method="post">
            <table>
                <tr>
                    <th>상품 번호</th>
                    <td><input type="text" name="productNo"></td>
                </tr>
                <tr>
                    <th>할인 시작일</th>
                    <td><input type="datetime-local" name="discountStart"></td>
                </tr>
                <tr>
                    <th>할인 종료일</th>
                    <td><input type="datetime-local" name="discountEnd"></td>
                </tr>
                <tr>
                    <th>할인율</th>
                    <td><input type="text" name="discountRate"></td>
                </tr>
            </table>
            
            <button id="backBtn" type="button">뒤로
            가기</button>
            <button type="submit">할인 등록</button>
            <script>
	 		// 돔객체.addEventListener('이벤트이름', 실행코드함수)
		    document.querySelector('#backBtn').addEventListener('click',function(){
				// BOM window.history객체
				history.back();
			});
		    document.querySelector('form').addEventListener('submit', function(event) {
		   	
	
		            let productNoInput = document.querySelector('input[name="productNo"]');
		            let discountRateInput = document.querySelector('input[name="discountRate"]');
		            let discountStartInput = document.querySelector('input[name="discountStart"]');
		            let discountEndInput = document.querySelector('input[name="discountEnd"]');

		    
		            if (productNoInput.value.trim() === '') {
		                event.preventDefault();
		                alert('상품번호 입력해주세요.');
		                return;
		            } else if (isNaN(productNoInput.value.trim())) {
		                event.preventDefault();
		                alert('상품번호는 숫자만 입력해주세요.');
		                return;
		            }

		            let discountRate = parseFloat(discountRateInput.value.trim());
		            //parseFloat() 함수는 문자열을 부동 소수점 숫자로 변환하는 JavaScript의 내장 함수
		            //문자열을 분석하고, 만약 가능하다면 해당 문자열을 부동 소수점 숫자로 변환

		            if (discountRateInput.value.trim() === '') {
		                event.preventDefault(); //기본동작 중지
		                alert('할인율을 입력해주세요.');
		                return;
		            } else if (isNaN(discountRate)) {
		                event.preventDefault();
		                alert('할인율은 숫자만 입력해주세요.');
		                return;
		            }
		            
		            if (discountStartInput.value.trim() === '') {
		                event.preventDefault();
		                alert('할인 시작일을 선택해주세요.');
		                return;
		            }

		            if (discountEndInput.value.trim() === '') {
		                event.preventDefault();
		                alert('할인 종료일을 선택해주세요.');
		                return;
		            }
		        });		   
		    
		</script>  
        </form>
    </div>
</body>
</html>