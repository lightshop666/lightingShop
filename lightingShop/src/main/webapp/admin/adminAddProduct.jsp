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
	// 카테고리 배열 만들어주기
	String[] categoryNames = {"관리자", "무드등", "스탠드", "실내조명", "실외조명", "파격세일", "포인트조명"};
	
	String msg = null;
	if (request.getParameter("msg") != null) {
	 	msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
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
    <div class="container">
        <h1>상품 등록</h1>
        
        <form action="<%=request.getContextPath()%>/admin/adminAddProductAction.jsp" method="post">
            <table>
                <tr>
                    <th>카테고리</th>
                    <td>
                        <select name="categoryName">
                            <% 
                            	for (String category : categoryNames) { 
                            %>
                                <option value="<%=category%>"> <%=category%></option>
                            <% 
                            	} 
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>상품명</th>
                    <td><input type="text" name="productName"></td>
                </tr>
                <tr>
                    <th>가격</th>
                    <td><input type="text" name="productPrice"></td>
                </tr>
                <tr>
                    <th>상태</th>
                    <td>
                        <select name="productStatus">
                            <option value="판매중">판매중</option>
                            <option value="예약판매">예약판매</option>
                            <option value="품절">품절</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>재고</th>
                    <td><input type="text" name="productStock"></td>
                </tr>
                <tr>
                    <th>상세정보</th>
                    <td><textarea name="productInfo"></textarea></td>
                </tr>
            </table>
            <button id="backBtn" type="button">뒤로가기</button>
            <button type="submit">상품 등록</button>
            <script>
	 		// 돔객체.addEventListener('이벤트이름', 실행코드함수)
		    document.querySelector('#backBtn').addEventListener('click',function(){
				// BOM window.history객체
				history.back();
			});
		    document.querySelector('form').addEventListener('submit', function(event) {
		   	
	
		            let productNameInput = document.querySelector('input[name="productName"]');
		            //가격은 ,형태로 입력되기 떄문에 해당 사항 고려!
		            // 가격 입력 필드에 접근
		            let productPriceInput = document.querySelector('input[name="productPrice"]');
		            
		          // 사용자가 입력한 가격 값에서 쉼표(,) 제거하여 숫자만 남도록 처리
		            let enteredPrice = productPriceInput.value.split(',').join(''); //replace는 정규식 활용 가능..
		            
		            // 처리된 숫자를 가격 필드에 다시 설정
		            productPriceInput.value = enteredPrice;
		            
		            let productStockInput = document.querySelector('input[name="productStock"]');
		            

		            if (productNameInput.value.trim() === '') {
		                event.preventDefault();
		                alert('이름을 입력해주세요.');
		                return;
		            }
		            if (productPriceInput.value.trim() === '') {
		                event.preventDefault();
		                alert('가격을 입력해주세요.');
		                return;
		            } else if (isNaN(productPriceInput.value.trim())) {
		                event.preventDefault();
		                alert('가격은 숫자만 입력해주세요.');
		                return;
		            }

		            if (productStockInput.value.trim() === '') {
		                event.preventDefault();
		                alert('재고를 입력해주세요.');
		                return;
		            } else if (isNaN(productStockInput.value.trim())) {
		                event.preventDefault();
		                alert('재고는 숫자만 입력해주세요.');
		                return;
		            }
		        });		   
		    
		</script>  
        </form>
    </div>
</body>
</html>