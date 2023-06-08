<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
    EmpDao empdao = new EmpDao();
	
    // 요청값 분석
    // 페이지 정보 가져오기 유효성 검사 후 리디렉트
    if (request.getParameter("productNo") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminProductList.jsp");
        return;
    }
    
    int productNo = Integer.parseInt(request.getParameter("productNo"));
    
    // 상품 상세 정보 가져오기
    HashMap<String, Object> product = empdao.selectProductOne(productNo);
    
    // 카테고리 배열 만들어주기
    String[] categoryNames = {"관리자", "무드등", "스탠드", "실내조명", "실외조명", "파격세일", "포인트조명"};
    
    // 상품 정보 가져오기
    String categoryName = (String) product.get("categoryName");
    String productName = (String) product.get("productName");
    double productPrice = (double) product.get("productPrice");
    String productStatus = (String) product.get("productStatus");
    String productStock = (String) product.get("productStock");
    String productInfo = (String) product.get("productInfo");
    String originFilename = (String) product.get("originFilename");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>상품 상세보기</title>
</head>
<body>
    <h1>상품 상세보기</h1>
    
    <form action="<%=request.getContextPath()%>/admin/adminModifyProductAction.jsp" method="post"  enctype="multipart/form-data">
        <!-- 수정하지 않는 컬럼에 대한 기존값 전달을 위해 hidden으로 설정 -->
        <h3>상품 이미지</h3> 
        <table>   
        <%   
        	if( product.get("originFilename")==null){
        %>
        		<tr>
	                <th class="table-info">새로운 이미지</th>
	                <td><input type="file" name="productFile"></td>
	                <td><input type="hidden" name="newFile"></td>
	            </tr>	
        <%
        	}else{        
        %>	
	        	<tr>
	                <th class="table-info">기존 이미지</th>
	                <td><%=originFilename%></td>
	            </tr>	
	            <tr>
	                <th class="table-info">새로운 이미지</th>
	                <td><input type="file" name="productFile"></td>
	            </tr>	
        <%
        	}    
        %> 
        </table>  
        
        <h3>상품 정보</h3> 
        <table class="table table-hover">
			        
            <tr>
                <th class="table-info">상품 번호</th>
                <td><%=productNo%><input type="hidden" name="productNo" value="<%=productNo%>"></td>              
            </tr>
            <tr>
                <th class="table-info">카테고리</th>
                <td>
                    <select name="categoryName">
                        <% 
                        	for (String category : categoryNames) { 
            
                        %>
                            <option value="<%=category%>" <%=category.equals(categoryName) ? "selected" : ""%>><%=category%></option>
                        <% 
   
                        	} 
                       	
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="table-info">상품명</th>
                <td><input type="text" name="productName" value="<%=productName%>"></td>
            </tr>
            <tr>
                <th class="table-info">가격</th>
                <td><input type="text" name="productPrice" value="<%=productPrice%>"></td>
            </tr>
            <tr>
                <th class="table-info">상태</th>
                <td>
                    <select name="productStatus">
                        <option value="판매중" <%=productStatus.equals("판매중") ? "selected" : ""%>>판매중</option>
                        <option value="예약판매" <%=productStatus.equals("예약판매") ? "selected" : ""%>>예약판매</option>
                        <option value="품절" <%=productStatus.equals("품절") ? "selected" : ""%>>품절</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="table-info">재고</th>
                <td><input type="text" name="productStock" value="<%=productStock%>"></td>
            </tr>
            <tr>
                <th class="table-info">상세정보</th>
                <td><textarea name="productInfo"><%=productInfo%></textarea></td>
            </tr>

        </table>
        
         <button type="submit" class="btn btn-dark">수정하기</button>
    </form>
</body>
</html>