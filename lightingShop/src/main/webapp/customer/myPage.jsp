<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	//변수저장
	String id = (String)session.getAttribute("loginIdListId");
	String lastPw = (String)session.getAttribute("loginIdListLastPw");
	String loginMemberId = id;
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage= 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 3;
	
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 3;
	
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	// 객체생성 -> 로그인으로 사용
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(lastPw);
	
	// 객체생성 -> selectCustomerOne 메서드에서 사용
	Customer customer = new Customer();
	customer.setId(id);
	// Customer(로그인, 고객정보) 모델호출
	CustomerDao cDao = new CustomerDao();
	HashMap<String, Object> loginIdList = cDao.loginMethod(idList);
	HashMap<String, Object> customerOne = cDao.selectCustomerOne(customer);
	
	//모델 호출
	OrderDao orderDao = new OrderDao();
	OrderProductDao orderProductDao = new OrderProductDao();
	ProductDao productDao = new ProductDao();
	
	//총 행을 구하기 위한 메소드
	int totalRow = orderProductDao.customerOrderListCnt(loginMemberId);
	
	//마지막 페이지
	int lastPage = totalRow / rowPerPage;
	//마지막 페이지는 딱 나누어 떨어지지 않으니까 몫이 0이 아니다 -> +1
	if(totalRow % rowPerPage != 0){
		lastPage += 1;
	}
	//페이지 목록 중 가장 작은 숫자의 페이지
	int minPage = ((currentPage - 1) / pageRange ) * pageRange + 1;
	//페이지 목록 중 가장 큰 숫자의 페이지
	int maxPage = minPage + (pageRange - 1 );
	//maxPage 가 last Page보다 커버리면 안되니까 lastPage를 넣어준다
	if (maxPage > lastPage){
		maxPage = lastPage;
	}
	
	//order모델 소환
	ArrayList<Orders> orderList  = orderDao.justOrders(beginRow, rowPerPage, loginMemberId);   
	ArrayList<HashMap<String, Object>> orderByOrderProduct = new ArrayList<HashMap<String, Object>>();
	
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

				<%
					// 로그인했다면 마이페이지
					if(session.getAttribute("loginIdListId") != null) {
				%>
			 
			 <!-- [시작] 주문정보 표시 -->
			 <section class="section-padding-100-0">
		        <div class="container">
		            <div class="row align-items-center">
		                <div class="col-12">
		                    <table class = "table table-hover w-100 rounded" style="table-layout: auto; width: 100%; table-layout: fixed;">
					           <thead>
					              <tr>
					                  <th>주문번호</th>
					                  <th>상품이름</th>
					                  <th>이미지</th>
					                  <th>주문일자</th>
					                  <th>주문상태</th>
					                  <th>주문가격</th>
					             </tr>
					           </thead>
					           <tbody>
									
								</tbody>
					        </table>
					        <div class="oneMusic-pagination-area" >
								<ul class="pagination">
									<%
										//1번 페이지보다 작은데 나오면 음수로 가버린다
										if (minPage > 1) {
									%>
											<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage-pageRange%>">이전</a>
											</li>
									
									<%	
										}
										for(int i=minPage; i <= maxPage; i=i+1){
											if ( i == currentPage){		
									%>
												<li class="page-item"><span class="page-link"><%=i %></span></li>
									<%
											}else{
									%>
												<li class="page-item">
												<a class="page-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=i%>"><%=i %></a>
												</li>
									<%
											}
										}
									
										//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
										if(maxPage != lastPage ){
									%>
											<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/orders/orderProductList.jsp?currentPage=<%=minPage+pageRange%>">다음</a>
											</li>
									<%
										}
									%>
								</ul>
							</div>
	                	</div>
					</div>
				</div>
			</section>	<!-- [끝] 주문정보 표시 -->
		                    
			 
								<%
									} else { // 로그인 전이라면 로그인 폼
								%>
								
			<!--[시작] 로그인 폼 출력 -->
			<section class="login-area section-padding-100">
		        <div class="container">
		             <div class="row justify-content-center">
		                 <div class="col-12 col-lg-6">
		                    <div class="login-content">
		                    	<div class="logo">
					                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
					            </div>
					            <br>
		                    	<div class="login-form">
									<form action="<%=request.getContextPath()%>/customer/loginAction.jsp" method="post" id="signinForm">
										<!-- 세션에 저장할 active값과 emp_level 값 -->
										<input type="hidden" name="active" value="<%=loginIdList.get("active")%>">
										<input type="hidden" name="empLevel" value="<%=loginIdList.get("empLevel")%>">
										<!-- Input Fields for ID and Password-->
								        <input type ='text' class = 'form-control my-input-field' id ='id' name = 'id' required placeholder="아이디">
								        <span id="idMsg" class="msg"></span>
								        <input type ='password' class = 'form-control my-input-field' id ='lastPw' name = 'lastPw' required placeholder="비밀번호는 4자"><br>
								        <span id="lastPwMsg" class="msg"></span>
										<button type="submit" class="btn btn-warning btn-lg mt-6" id="signBtn">로그인</button>
									</form>
									<a href="<%=request.getContextPath()%>/customer/addCustomer.jsp">회원가입</a>
								</div>
	                        </div>
	                	</div>
					</div>
				</div>
			</section> <!--[끝] 로그인 폼 출력 -->
			
								<%
										}
								%>
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

	<!-- js 유효성 검사  -->
	<script>
		<%
			String loginMsg =  request.getParameter("loginMsg");
    		if(loginMsg != null) {
	   	%>
			alert('아이디와 비밀번호가 일치하지 않습니다.');
		<%
			}
		%>
	</script>	
</body>
</html>								