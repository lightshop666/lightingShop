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
	
	System.out.println((String)session.getAttribute("loginIdListRank"));
	
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
	// id별 주문상태 출력할 모델
	ArrayList<HashMap<String, Object>> customerDelList = cDao.selectCustomerDelCnt(customer);
	// id별 문의개수 출력 모델 - 답변대기
	int myQuestionNoAnserCnt = cDao.myQuestionNoAnserCnt(customer);
	// id별 문의개수 출력 모델 - 답변완료
	int myQuestionAnserCnt = cDao.myQuestionAnserCnt(customer);
	// id별 리뷰개수 출력 모델
	int myReviewCnt = cDao.myReviewCnt(customer);
	
%>

<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

	<!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Title  -->
    <title>Amado - MyPage</title>
    
    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
   
	<!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    
    <!-- Google Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Dongle:wght@400;700&display=swap" rel="stylesheet">
<style>

	.customerlank-area {
		background-color: #ffd400;
		height: 200px;
	}
	
	.customerlank-area span.a {
		font-weight:bold; 
		font-size: 60px !important;
		color:#FFFFFF;
	}
	
	.main-content-wrapper span {
		font-family: 'Dongle', sans-serif !important;
		font-size: 25px !important;
	}
	
	.main-content-wrapper {
	  display: flex;
	  justify-content: space-between;
	}
	
	.shop_sidebar_area {
	  width: calc(20% - 30px);
	}
	
	.section-container {
	   width: calc(80% - 30px);
	}
	
	.login-content {
		margin-left: 300px;
	}
	
	.btn-container {
	    display: flex;
	    justify-content: space-between;
  	}
	
	 .btn-spacing {
	    margin-right: 10px; /* 원하는 간격(px)으로 설정 */
	  }
	  
</style>
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
		<!-- Header Area Start -->  
	    <div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>       
		<!-- Header Area End -->  

		<div class="shop_sidebar_area">
			<!-- ##### Single Widget ##### -->
	        <div class="widget catagory mb-50">
	            <!-- Widget Title -->
	            <h6 class="widget-title mb-30">myPage</h6>
	
	            <!--  Catagories  -->
	            <div class="catagories-menu">
	                <ul>
	                    <!-- 내정보 상세보기 -->
	                    <li><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">Profile</a></li>
	                    <!-- 배송지 관리 -->
	                    <li><a href="<%=request.getContextPath()%>/customer/addressList.jsp">Your Addresses</a></li>
	                    <!-- 포인트 내역 -->
	                    <li><a href="<%=request.getContextPath()%>/customer/customerPointList.jsp">point</a></li>
	                    <!-- 내리뷰 확인  -->
	                    <li><a href="<%=request.getContextPath()%>/review/myReview.jsp">Your Review</a></li>
	                    <!-- 내문의 확인 -->
	                    <li><a href="<%=request.getContextPath()%>/board/myQuestionList.jsp">Your Question</a></li>
	                    <!-- 주문내역 확인 -->
	                    <li><a href="<%=request.getContextPath()%>/orders/orderProductList.jsp">Your Orders</a></li>
	                </ul>
	            </div>
	        </div>
        </div>

				<%
					// 로그인했다면 마이페이지
					if(session.getAttribute("loginIdListId") != null) {
				%>
		<div class="amado_product_area section-padding-100">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
			 
							<!-- [시작] 고객등급확인 및 이미지 출력 -->
						    <section class="customerlank-area section-padding-100-0 border" style='margin-bottom: 50px; width: 100%; margin-left: auto; margin-right: auto; color:#000000;'>
						        <div class="container-fluid">
						            <div class="row align-items-center">
						                <!-- Newsletter Text -->
						                <div class="col-12 col-lg-6 col-xl-9">
						                    <div class="newsletter-text mb-100" style='margin-left: 50px; position:relative; top:-75px;' >
						                        <span class="a"><%=customerOne.get("c.cstm_name") %></span>님의 등급은 <span class="a"><%=customerOne.get("c.cstm_rank") %></span>등급&nbsp;입니다.
						                    </div>
						                </div>
						                <!-- Newsletter Form -->
						                <div class="col-12 col-lg-6 col-xl-3">
						                    <div class="newsletter-form mb-100" style='margin-left: 0px; position:relative; top:-75px;'>
					                        	<!-- 아이콘 or 이미지 -->
					                           <a href="<%=request.getContextPath()%>/customer/addressList.jsp"><div style='font-size: 30px;'><i class="fa fa-address-book-o" aria-hidden="true">&nbsp;<span>배송지</span></i></div></a>
					                           <a href="<%=request.getContextPath()%>/customer/customerPointList.jsp"><div style='font-size: 30px;'> <i class="fa fa-money" aria-hidden="true">&nbsp;<span>포인트</span></i></div></a>
					                           <a href="<%=request.getContextPath()%>/cart/cartList.jsp"><div style='font-size: 30px;'> <i class="fa fa-heart-o" aria-hidden="true">&nbsp;<span>찜리스트</span></i></div></a>
						                    </div>
						                </div>
						            </div>
						        </div>
						    </section>
						    <!-- [끝] 고객등급확인 및 이미지 출력 -->
							 
							
							<!-- [시작] 진행중인 주문 확인 -->
							<div style='position:relative; right: 0px; font: bold; font-size: 25px;'><span style='font-size: 40px !important;'>내 주문현황</span></div>
							 <section class="section border" style='margin-bottom: 50px; width: 100%; margin-left: auto; margin-right: auto; padding-top: 50px; padding-bottom: 50px;'>
						        <div class="container-fluid">
						            <div class="row align-items-center">
						                <!-- Newsletter Text -->
						                <div class="col-12 col-lg-6 col-xl-9">
						                    <div class="newsletter-text " style='margin-left: 100px; border-right:1px solid #ccc'>
						                        <% for(String status : Arrays.asList("주문확인중", "배송중", "배송시작", "배송완료" ,"구매확정")) { %>
										          <% boolean found = false;
										             int count = 0;
										
										             for(HashMap<String, Object> m : customerDelList) {
										                 if(m.get("op.delivery_status").equals(status)) { 
										                     found = true;
										                     count += (int)m.get("cnt");
										                 }
										             }
										
										          %>
										          	
										          	<div style="width: 18%; position: relative; display:inline-block; vertical-align: top; font-size: 15px;">
										            <span><%=status%></span> <br>
											            <div style="display: inline-block; font-size: 20px !important;">
											            <% if(found) { %>
											              <span ><%=count %> 건</span>
											            <% } else { %>
											              <span >0 건</span>
											            <% } %> 
											            </div>
													</div>
													
										        <% } %> 
						                    </div>
						                </div>
						                <!-- Newsletter Form -->
						                <div class="col-12 col-lg-6 col-xl-3">
						                    <div class="newsletter-text " >
								                    	
							                    	<%
							                    		int totalCancelledOrExchanged = 0;
							                    		for(HashMap<String, Object> m : customerDelList) {
							                    			 if(m.get("op.delivery_status").equals("취소완료") 
							                    					 || m.get("op.delivery_status").equals("교환중")) { 
							                    				 		totalCancelledOrExchanged += (int)m.get("cnt");
							                    			 }
							                    		}
													%>
													<div style="font-size: 15px; position: relative;">
													<span>취소완료/교환중</span> <br>
							                    	<div style="display: inline-block; font-size: 20px !important;"><span><%=totalCancelledOrExchanged %> 건</span></div>
							                    	</div>
						                    </div>
						                </div>
						            </div>
						        </div>
						    </section>
							<!-- [끝] 진행중인 주문 확인 -->
							
							
						    <!-- [시작] 1:1 문의 and myRiview -->
						    <section class="section border" style='margin-bottom: 50px; width: 100%; margin-left: auto; margin-right: auto; padding-top: 0px; padding-bottom: 0px;'> 
							    <div class="container-fluid"> 
							
							            <!-- 첫 번째 섹션 --> 
							            <div class="row align-items-center">
								            <div class="col-md-6 border p-3">
								               <div><span>1:1 문의</span></div>
								               <hr style="border-top: 2px solid black;">
								               <div><span>답변대기</span> <span style="float: right;"><%=myQuestionNoAnserCnt%>&nbsp;&nbsp;건</span></div>
								               <br>
								               <div><span>답변완료</span> <span style="float: right;"><%=myQuestionAnserCnt%>&nbsp;&nbsp;건</span></div>		
								            </div>
							
							            <!-- 두 번째 섹션 -->  
								            <div class="col-md-6 border p-3">
								               <div><span>상품후기</span></div>
								               <hr style="border-top: 2px solid black;">
								               <div><span>작성한 후기</span><span style="float: right;"><%=myReviewCnt%>&nbsp;&nbsp;건</span></div>
								               <br>
								               <div><span>&nbsp;</span></div>
								            </div> 
										</div>
							
							     </div>
							</section>
							 <!-- [끝] 1:1 문의 and myRiview -->
			
				</div>
			</div>
		</div>		
	</div>		 
								<%
									} else { // 로그인 전이라면 로그인 폼
								%>
								
		<!--[시작] 로그인 폼 출력 -->
		<div class="amado_product_area section-padding-100">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
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
								        <input type ='text' class = 'form-control my-input-field' id ='id' name = 'id' value="user1" required placeholder="아이디">
								        <span id="idMsg" class="msg"></span>
								        <input type ='password' class = 'form-control my-input-field' id ='lastPw' name = 'lastPw' value="1234" required placeholder="비밀번호는 4자"><br>
								        <span id="lastPwMsg" class="msg"></span>
										<button type="submit" class="btn btn-warning btn-lg mt-6" id="signBtn">로그인</button>
									</form>
									<a href="<%=request.getContextPath()%>/customer/addCustomer.jsp">회원가입</a>
										<ul class="btn-container">
											<li onclick="kakaoLogin();">
										      <a href="javascript:void(0)">
										          <span class="btn btn-warning btn-lg mt-6 btn-spacing">카카오 로그인</span>
										      </a>
											</li>
											<!-- <li onclick="kakaoLogout();">
										      <a href="javascript:void(0)">
										          <span class="btn btn-warning btn-lg mt-6">카카오 로그아웃</span>
										      </a>
											</li> -->
										</ul>
									<!-- 카카오 스크립트 -->
									<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
									<script>
									Kakao.init('6963af56f898547112634b293994fc5e'); //발급받은 키 중 javascript키를 사용해준다.
									console.log(Kakao.isInitialized()); // sdk초기화여부판단
									//카카오로그인
									function kakaoLogin() {
									    Kakao.Auth.login({
									    scope: 'account_email, gender, age_range, birthday',
									    success: function(authObj) {
							                console.log(authObj)
									        Kakao.API.request({
									          url: '/v2/user/me',
									          success: function (response) {
									        	  const kakao_account = response.kakao_account;
							                        console.log(kakao_account);
							                        const userEmail = kakao_account.email;
							                        createHiddenFormAndSubmit(userEmail);
									          },
									          fail: function (error) {
									            console.log(error)
									          },
									        })
									      },
									      fail: function (error) {
									        console.log(error)
									      },
									    })
									  }
									
									function createHiddenFormAndSubmit(userEmail) {
								        const form = $('<form>', {
								            action: '<%=request.getContextPath()%>/customer/kakaoLoginAction.jsp',
								            method: 'post'
								        });

								        $('<input>').attr({
								            type: 'hidden',
								            name: 'id',
								            value: userEmail
								        }).appendTo(form);

								        form.appendTo('body').submit();
								    }
									
									//카카오로그아웃  
									function kakaoLogout() {
									    if (Kakao.Auth.getAccessToken()) {
									      Kakao.API.request({
									        url: '/v1/user/unlink',
									        success: function (response) {
									        	console.log(response)
									        },
									        fail: function (error) {
									          console.log(error)
									        },
									      })
									      Kakao.Auth.setAccessToken(undefined)
									    }
									  }  
									</script>
									
								</div>
	                        </div>
	                	</div>
					</div>
				</div> 
			</div>
		</div> <!--[끝] 로그인 폼 출력 -->
								<%
										}
								%>
    </div>
    <!-- ##### Main Content Wrapper End ##### -->
    
    <!-- footer 하단 bar -->
    <div>
		<jsp:include page="/inc/footer.jsp"></jsp:include>
	</div>

	<!--KAKAO LOGIN API -->
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>

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