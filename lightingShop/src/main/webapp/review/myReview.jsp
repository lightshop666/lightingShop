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
		System.out.println(currentPage + "<--crt-- ReviewList.jsp 새로 들어간 페이지 넘버");
	}
	//페이지에 보여주고 싶은 행의 개수
	int rowPerPage = 4;
	if(request.getParameter("rowPerPage")!=null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		System.out.println(rowPerPage + "<--crt-- ReviewList.jsp 새로 들어간 페이지 당 행의 수");
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
	 ArrayList<HashMap<String, Object>> reviewList  = reviewDao.selectReviewListByPage(beginRow, rowPerPage, loginMemberId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Review Page</title>
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
	<div>
		<table class="table table-bordered">
		<!-- 
			템플릿 적용 후
			상품명
			주문일자
			리뷰타이틀
			리뷰콘텐츠
			리뷰사진
			작성일자
			수정삭제버튼		
		 -->
			<tr>
			    <th>Order Product No</th>
			    <th>Review Title</th>
			    <th>Review Content</th>
			    <th>Create Date</th>
			    <th>Update Date</th>
			    <th>Review Original Filename</th>
			    <th>Review Save Filename</th>
			    <th>Review File Type</th>
			    <th>Product Name</th>
			    <th>Order Date</th>
			</tr>
		<%
		    for (HashMap<String, Object> m : reviewList) {
		%>				
		    <tr>				
		        <td><%= m.get("orderProductNo") %> </td>
		        <td><%= m.get("reviewTitle") %> </td>
		        <td><%= m.get("reviewContent") %> </td>
		        <td><%= m.get("createdate") %> </td>
		        <td><%= m.get("updatedate") %> </td>
		        <td><%= m.get("reviewOriFilename") %> </td>
		        <td>
		            <img src="/img/review/<%= m.get("reviewSaveFilename") %>" alt="Review Image">
		        </td>
		        <td><%= m.get("reviewFiletype") %> </td>
		        <td><%= m.get("productName") %> </td>
		        <td><%= m.get("orderDate") %> </td>
		    </tr>
		<%
		    }
		%>

		</table>
	</div>
	<div class="center" >
	<%
		//1번 페이지보다 작은데 나오면 음수로 가버린다
		if (minPage > 1) {
	%>
			<a href="<%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=minPage-pageRange%>">이전</a>
	
	<%	
		}
		for(int i=minPage; i <= maxPage; i=i+1){
			if ( i == currentPage){		
	%>
				<span><%=i %></span>
	<%
			}else{
	%>
				<a href="<%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=i%>"><%=i %></a>
	<%
			}
		}
	
		//maxPage와 lastPage가 같지 않으면 여분임으로 마지막 페이지목록일거다.
		if(maxPage != lastPage ){
	%>
			<!-- maxPage+1해도 동일하다 -->
			<a href="<%=request.getContextPath()%>/review/myReview.jsp?currentPage=<%=minPage+pageRange%>">다음</a>
	<%
		}
	%>
	
	</div>
</div>
</body>
</html>