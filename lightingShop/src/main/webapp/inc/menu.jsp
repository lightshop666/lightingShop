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
               
                    <!-- 내정보 상세보기 -->
                    <li><a class="nav-link" href="<%=request.getContextPath()%>/customer/customerOne.jsp">Customer</a></li>
					<!-- 배송지 관리 -->
					<li><a class="nav-link" href="<%=request.getContextPath()%>/customer/addressList.jsp">addressList</a></li>
					<!-- 포인트 내역 -->
					<li><a class="nav-link" href="<%=request.getContextPath()%>/customer/customerPointList.jsp">PointList</a></li>
					<!-- 리뷰등록  -->
					<li><a class="nav-link" href="<%=request.getContextPath()%>/review/myReview.jsp">MyReview</a></li>
					<!-- 문의등록 -->
					<li><a class="nav-link" href="<%=request.getContextPath()%>/board/myQuestionList.jsp">1:1 Question</a></li>
					<!-- 로그아웃 -->
					<li><a class="nav-link" href="<%=request.getContextPath()%>/customer/logoutAction.jsp">Logout</a></li>
					
                </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="#" class="btn amado-btn mb-15">%Discount%</a>
                <a href="#" class="btn amado-btn active">New this week</a>
            </div>
            <!-- Cart Menu -->
            <div class="cart-fav-search mb-100">
                <a href="<%=request.getContextPath()%>/cart/cartList.jsp" class="cart-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/cart.png" alt=""> Cart <span>(0)</span></a>
                <a href="#" class="search-nav"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""> Search</a>
            </div>
        </header>
        <!-- [끝] 왼쪽 메뉴바 -->