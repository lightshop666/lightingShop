<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//세션검사
	if (session.getAttribute("loginIdListId") == null
		|| session.getAttribute("loginIdListActive").equals("N")) { // 비회원 || 탈퇴회원이면
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	System.out.println("[customerOne컨트롤러 진입]");
	String sessionId = session.getAttribute("loginIdListId").toString(); // 현재 세션에 저장되어있는 회원 ID정보
	
	// 회원정보 불러오기
	Customer customer = new Customer();
	customer.setId(sessionId);
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	// 주소정보 불러오기
	Address address = new Address();
	address.setId(sessionId);
	ArrayList<Address> list = cDao.myAddressList(address);
	
	String DefaultAddress = (String)customerOne.get("a.default_address");
	System.out.println(DefaultAddress + "[customerOne컨트롤러 DefaultAddress]");
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

<!-- Search Wrapper Area Start -->
<div class="search-wrapper section-padding-100">
	<div class="search-close">
		<i class="fa fa-close" aria-hidden="true"></i>
	</div>
	<div class="container">
		<div class="row">
			<div class="col-12">
				<div class="search-content">
					<form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
						<input type="search" name="searchWord" id="search" placeholder="키워드를 입력하세요">
						<button type="submit"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""></button>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

	<!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">
    
    	<!-- menu 좌측 bar -->
	    <div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

				 <!-- [시작] 고객상세정보 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-8">
			                	<div class="login-content">
			                  
								<h3>개인정보 관리</h3>
								
								<div class="font-bold mb-5">
									<%=customerOne.get("c.cstm_name")%>(<%=customerOne.get("c.id")%>)님 반갑습니다.
								</div>
								
								<div class="row">
						    		<div class="col">
							    		<div>
											보유 포인트 : <%=customerOne.get("c.cstm_point")%>
										</div>
										<div>
											등급 : <%=customerOne.get("c.cstm_rank")%>
										</div>
										<div class="mt-3">
											가입날짜 : <%=customerOne.get("c.createdate").toString().substring(0, 10)%>
										</div>
										<div>
											전화번호 : <%=customerOne.get("c.cstm_phone")%>
										</div>
										<div>
											생년월일 : <%=customerOne.get("c.cstm_birth")%>
										</div>
										<div>
											이메일 : <%=customerOne.get("c.cstm_email")%>
										</div>
										<div>
											마지막 로그인 시간 : <br> <%=customerOne.get("c.cstm_last_login")%>
										</div>
							    	</div>
							    	<div class="col text-right">
							    		<div>
											<a class="btn btn-sm btn-outline-dark" href='<%=request.getContextPath()%>/customer/modifyCustomer.jsp'">회원정보수정</a>
										</div>
										<div class="mt-3">
											<a class="btn btn-sm btn-outline-dark" href='<%=request.getContextPath() %>/customer/removeCustomer.jsp'">회원탈퇴</a>
										</div>
							    	</div>
							    </div>       
								
								<hr>
								
								<!-- 기본배송지는 1개만 설정가능 기본배송지만 출력 -->
								<div class="font-bold pb-3" >
									기본배송지
								</div>
								
								<%
									for(Address a : list) {
										if(a.getDefaultAddress().equals("Y")) {
								%>
									<div>
										배송지명 : <%=customerOne.get("a.address_name")%>
									</div>
									<div>
										주소 : <%=customerOne.get("c.cstm_address")%>
									</div>
								<%
										} 
									}
								%>
								
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 고객상세정보 출력 -->	
            </div>
        </div>
        <!-- Product Catagories Area End -->
    </div>
    <!-- ##### Main Content Wrapper End ##### -->
    
    <!-- footer 하단 bar -->
    <div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
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

</body>
</html>								