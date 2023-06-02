<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	//모델 호출
	ReviewDao reviewDao = new ReviewDao();
	
	//페이징 리스트를 위한 변수 선언
	//현재 페이지
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 4;
	if(request.getParameter("rowPerPage")!=null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	//페이지 주변부에 보여주고싶은 리스트의 개수
	int pageRange = 2;
	//시작 행
	int beginRow = (currentPage-1) * rowPerPage + 1;
	
	//총 행을 구하기 위한 메소드
	int totalRow = reviewDao.selectUserReviewCnt(loginMemberId);
	
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
	
	//Review 출력
	 ArrayList<HashMap<String, Object>> AllReviewList  = reviewDao.allReviewListByPage(beginRow, rowPerPage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Review List</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}

</style>

</head>
<body>
<div class="container">	
<h1>나의 리뷰</h1>
	<div>	<!-- 
			템플릿 적용 후 수정 사항
			모든 리뷰 출력, 글 누르면 상품페이지로
			사진 누르면 사진 확대
		 -->
	<%
		for (HashMap<String, Object> m : AllReviewList) {
	%>
			<p>Order Product No: <%= m.get("orderProductNo") %></p>
			<p>Review Title: <%= m.get("reviewTitle") %></p>
			<p>Review Content: <%= m.get("reviewContent") %></p>
			<p>Create Date: <%= m.get("createdate") %></p>
			<p>Update Date: <%= m.get("updatedate") %></p>
			<p>Review Save Filename: <%= m.get("reviewSaveFilename") %></p>
			<p>Review File Type: <%= m.get("reviewFiletype") %></p>
			<p>Product No: <%= m.get("productNo") %></p>
			<p>Product Name: <%= m.get("productName") %></p>
			<p>Product Info: <%= m.get("productInfo") %></p>
			<p>Product Status: <%= m.get("productStatus") %></p>
			<p>Order No: <%= m.get("orderNo") %></p>
			<p>Delivery: <%= m.get("delivery") %></p>
			<p>Order Date: <%= m.get("orderDate") %></p>
			<p>Product Save Filename: <%= m.get("productSaveFilename") %></p>
			<p>Product File Type: <%= m.get("productFileType") %></p>
			<hr>
	<%
	    }
	%>


	</div>
	<div class="center" >
	<%
		//1번 페이지보다 작은데 나오면 음수로 가버린다
		if (minPage > 1) {
	%>
			<a href="<%=request.getContextPath()%>/review/reviwList.jsp?currentPage=<%=minPage-pageRange%>">이전</a>
	
	<%	
		}
		for(int i=minPage; i <= maxPage; i=i+1){
			if ( i == currentPage){		
	%>
				<span><%=i %></span>
	<%
			}else{
	%>
				<a href="<%=request.getContextPath()%>/review/reviwList.jsp?currentPage=<%=i%>"><%=i %></a>
	<%
			}
		}
	
		//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
		if(maxPage != lastPage ){
	%>
			<!-- maxPage+1해도 동일하다 -->
			<a href="<%=request.getContextPath()%>/review/reviwList.jsp?currentPage=<%=minPage+pageRange%>">다음</a>
	<%
		}
	%>
	
	</div>
</div>
</body>
</html>