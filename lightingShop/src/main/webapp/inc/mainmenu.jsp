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
						if(session.getAttribute("loginIdListId") == null) {//로그인 전
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
                    <!-- 비로그인 : 로그인 버튼 / 로그인 : 마이페이지 버튼 /-->
				<%		//비로그인 : 로그인
						if(session.getAttribute("loginIdListId") == null) { // 로그인전
				%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/myPage.jsp">
								Login
							</a>
				<%
						//로그인시 : 마이페이지
						}else if(session.getAttribute("loginIdListEmpLevel") == null && session.getAttribute("loginIdListId") != null){
				%>
							<a class="nav-link" href="<%=request.getContextPath()%>/customer/myPage.jsp">
								My Page
							</a>
				<%		//관리자로그인 : 관리자페이지
						}else{
				%>
							<a class="nav-link" href="<%=request.getContextPath()%>/admin/adminQuestionList.jsp">
								My Page
							</a>
				<% 
						}
				%>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/product/productList.jsp">Shop</a></li>
                    <li><a href="<%=request.getContextPath()%>/review/reviewList.jsp">Review</a></li>
                    <li><a href="<%=request.getContextPath()%>/board/questionBoardList.jsp">Question</a></li>
                </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="<%=request.getContextPath()%>/product/discountProductList.jsp" class="btn amado-btn mb-15">%Discount%</a>
            </div>
            <!-- Cart Menu -->
            <div class="cart-fav-search mb-100">
                <a href="<%=request.getContextPath()%>/cart/cartList.jsp" class="cart-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/cart.png" alt=""> Cart</a>
                <a href="#" class="search-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""> Search</a>
            </div>

        </header>
        <!-- [끝] 왼쪽 메뉴바 -->