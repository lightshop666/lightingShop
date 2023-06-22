<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Navbar Toggler -->
            <div class="amado-navbar-toggler">
                <span></span><span></span><span></span>
            </div>
        </div>

        <!-- [시작] 왼쪽 메뉴바 -->
        <header class="header-area clearfix">
            <!-- Close Icon -->
            <div class="nav-close">
                <i class="fa fa-close" aria-hidden="true"></i>
            </div>
            <!-- Logo -->
            <div class="logo">
                <a href="<%=request.getContextPath()%>/home.jsp"><img src="<%=request.getContextPath()%>/resources/img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul>
                    <li ><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
                    <!-- 임시로 HOME -->
                    <li>
                    <!-- 비로그인 : 회원가입 버튼 / 로그인 : 로그아웃 버튼-->
			<%//비로그인 : 회원가입
						if(session.getAttribute("loginMemberId") == null) {//로그인 전
			%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/addCustomer.jsp">
								Join
							</a>
			<%
					//로그인시 : 로그아웃
						}else{
			%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/logoutAction.jsp">
								Logout
							</a>
			<%
						}
			%>
                    </li>
                    <li>
                    <!-- 비로그인 : 로그인 버튼 / 로그인 : 마이페이지 버튼-->
				<%	//비로그인 : 로그인
						if(session.getAttribute("loginMemberId") == null) { // 로그인전
				%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/myPage.jsp">
								Login
							</a>
				<%
						//로그인시 : 마이페이지
						}else{
				%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/myPage.jsp">
								My Page
							</a>
				<%
						}
				%>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/product/productList.jsp">Shop</a></li>
                    <li><a href="<%=request.getContextPath()%>/review/reviewList.jsp">Review</a></li>
                    <li><a href="<%=request.getContextPath()%>/board/questionBoardList.jsp">Question</a></li>
             	<%
					// 고객 - 로그인했다면 아래 내역
					if(session.getAttribute("loginIdListId") != null) {
				%>
                    <!-- 내정보 상세보기 -->
                    <li><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">내정보 상세보기</a></li>
					<!-- 배송지 관리 -->
					<li><a href="<%=request.getContextPath()%>/customer/addressList.jsp">배송지 관리</a></li>
					<!-- 포인트 내역 -->
					<li><a href="<%=request.getContextPath()%>/customer/customerPointList.jsp">포인트 내역 확인</a></li>
					<!-- 리뷰등록  -->
					<li><a href="<%=request.getContextPath()%>/review/addReview.jsp">리뷰등록</a></li>
					<!-- 문의등록 -->
					<li><a href="<%=request.getContextPath()%>/board/addQuestion.jsp">문의등록</a></li>
					<!-- 로그아웃 -->
					<li><a href="<%=request.getContextPath()%>/customer/logoutAction.jsp">로그아웃</a></li>
				<%
					}
				%>	
					<%-- 사용하지 않는 기능	
					<!-- 등급확인 - 등급에 따른 이미지 출력-->
					<%=id%>님의 등급은 <%=customerOne.get("c.cstm_rank")%>입니다. 
					--%>
					
                </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="<%=request.getContextPath()%>/product/discountProductList.jsp" class="btn amado-btn mb-15">%Discount%</a>
                <a href="#" class="btn amado-btn active">New this week</a> <!-- 할지말지고민.. -->
            </div>
            <!-- Cart Menu -->
            <div class="cart-fav-search mb-100">
                <a href="<%=request.getContextPath()%>/cart/cartList.jsp" class="cart-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/cart.png" alt=""> Cart <span>(0)</span></a>
                <a href="#" class="search-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""> Search</a>
            </div>

        </header>
        <!-- [끝] 왼쪽 메뉴바 -->