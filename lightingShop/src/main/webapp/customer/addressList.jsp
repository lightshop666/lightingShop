<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 나의배송지 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	CustomerDao cDao = new CustomerDao();
	Address address = new Address();
	address.setId(sessionId);
	// 배송지리스트 불러옴
	ArrayList<Address> list = cDao.myAddressList(address);
%>   

<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Amado - MyPage</title>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
    <!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	
</head>
<body>

	<!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">
    
    	<!-- menu 좌측 bar -->
	    <div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

			<!-- Modal -->
			<div id="myModal" class="modal fade" role="dialog">
			  <div class="modal-dialog">
			
			    <!-- Modal content-->
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title">배송지 목록</h4>
			      </div>
			      <div class="modal-body">
			        	<c:forEach var="a" items="${list}">
							<p>
								<span><input type="radio" name="addressCode" class="addressCode" value="${a.addressCode}"></span>
								${a.address}
								<span><a href="${pageContext.request.contextPath}/AddressRemoveOrder?customerId=${a.customerId}&address=${a.address}">삭제</a></span>
							</p>
						</c:forEach>
			      </div>
			      <div class="modal-footer">
			      	<button type="button" class="btn btn-default" data-dismiss="modal">선택</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			      </div>
			    </div>
			
			  </div>
			</div>

				 <!-- [시작] 주소목록 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-10">
			                	<div class="login-content">
			                  
							    <h3><%=address.getId()%>님의 배송지목록</h3>
							      <form action="<%=request.getContextPath()%>/customer/myPage.jsp">
								      <table class = "table" style="table-layout: auto; width: 100%; table-layout: fixed;">
							      		<thead>
									      	<tr>
									      		<th>기본배송지</th>
									      		<th>배송지</th>
									      		<th>받는사람</th>
									      		<th>주소</th>
									      		<th>수정</th>
									      		<th>삭제</th>
									      	</tr>
								      	</thead>
										<%
											/* 리스트 4개까지 출력 - {0, 1, 2, 3} */
											int maxCount = 4; // 최대 4개까지만 표시
										    for (int i = 0; i < list.size() && i < maxCount; i++) {
										        Address a = list.get(i);
										%>
										<tr>
											<td><%=a.getDefaultAddress() %></td>
											<td><%=a.getAddressName() %></td>
											<td><%=a.getId()%></td>
											<td><%=a.getAddress() %></td>
											<td>
												<a class="btn btn-sm btn-outline-warning" href="<%=request.getContextPath()%>/customer/modifyAddress.jsp?addressNo=<%=a.getAddressNo()%>">수정</a>
											</td>
											<td>
												<a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/customer/removeAddressAction.jsp?addressNo=<%=a.getAddressNo()%>">삭제</a>
											</td>
										</tr>
										<%
											}
										%>
								      </table>
								      	<div class="row">
									      	<div class="col-auto mr-auto">	
										        <a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/customer/myPage.jsp">취소</a>
											</div>
											<div class="col-auto ml-auto">
												<a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/customer/addAddress.jsp" >배송지 추가</a>
											</div>
										</div>
							      </form> 
								
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 주소목록 출력 -->	
            </div>
        </div>
        <!-- Product Catagories Area End -->
    </div>
    <!-- ##### Main Content Wrapper End ##### -->
    
    <!-- footer 하단 bar -->
    <div>
		<jsp:include page="/inc/footer.jsp"></jsp:include>
	</div>

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="js/plugins.js"></script>
    <!-- Active js -->
    <script src="js/active.js"></script>

	<!-- js 유효성 검사 - DOM API 사용 -->
	<script>
	
	// 주소 추가 버튼 클릭 이벤트 핸들러
    document.getElementById("addressAddBtn").addEventListener("click", function() {
        // 주소 값 가져오기
        var postcode = document.getElementById("sample3_postcode").value;
        var address = document.getElementById("sample3_address").value;
        var detailAddress = document.getElementById("sample3_detailAddress").value;

        if (postcode.value.trim() === '') {
            event.preventDefault();
            alert('우편번호를 입력해주세요.');
            return;
        } 
        
        if (address.value.trim() === '') {
            event.preventDefault();
            alert('주소를 입력해주세요.');
            return;
        } 
        
        if (detailAddress.value.trim() === '') {
            event.preventDefault();
            alert('상세주소를 입력해주세요.');
            return;
        } 
        
        // 주소 값 조합하여 addressInput의 값을 설정
        var fullAddress = postcode +" "+ address + " " + detailAddress;
        document.getElementById("addressInput").value = fullAddress;
    });
	
	<!-- 오류 메세지 출력 -->
	<%
		String noAddress = request.getParameter("noAddress");
		if(noAddress != null) {
	%>
		alert('우편번호, 주소, 상세주소를 입력해주세요.');
	<%
		}
	%>
	
	<%
		String overLapAddress = request.getParameter("overLapAddress");
		if(overLapAddress != null) {
	%>
		alert('기본 배송지가 중복됩니다.');
	<%
		}
	%>
	
	document.querySelector('form').addEventListener('submit', function(event) {
      
       let addressNameInput = document.querySelector('input[name="addressName"]');
	   let defaultAddressInput = document.querySelector('select[name="defaultAddress"]');
       
       if (addressNameInput.value.trim() === '') {
           event.preventDefault();
           alert('배송지명를 입력해주세요.');
           return;
       } 
       
       if (defaultAddressInput.value.trim() === '') {
           event.preventDefault();
           alert('기본배송지를 선택해주세요.');
           return;
       } 
       
    });  
    
    </script>

</body>
</html>								
