<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//order_product_no가 review테이블 외래키이자 기본키다.
	if(request.getParameter("orderProductNo") == null){
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");	
		System.out.println("reviewList.jsp로 리턴");
		return;	
	}
	//파라미터 값 확인
	//orderProductNo 파라미터값 확인
	System.out.println(request.getParameter("orderProductNo")+"<--orderProductNo--reviewOne parm ");
	int orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
	
	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		//현재 로그인 사용자의 아이디
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}

	//리뷰사진 출력, 글 클릭시 상품 페이지로 이동
	//리뷰사진출력을 위한 dao 호출
	ReviewDao reviewdao = new ReviewDao();
	Review reviewImg = reviewdao.reviewImg(orderProductNo);
	//리뷰 텍스트 호출
	Review reviewtext = reviewdao.reviewText(orderProductNo);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Review One</title>
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
<h1>리뷰 상세 페이지</h1>
		<div>
		<table class="table table-bordered ">
			<tr>			
				<th>리뷰 사진</th>
				<th>리뷰 제목</th>
				<th>리뷰 내용</th>
				<th>등록일</th>
				<th>수정일</th>
			</tr>		
			<tr>	
				<td>
					<img src="<%=reviewImg.getReviewSaveFilename()%>" alt="Review Image">
					
				</td>
				<td><%=reviewtext.getReviewTitle()%></td>
				<td><%=reviewtext.getUpdatedate()%></td>
				<td><%=reviewtext.getCreatedate()%></td>
			</tr>
		</table>
		<div class="row">
			
			<div class="col-5 text-center">
				<form action="<%=request.getContextPath()%>/teacher/modifyTeacher.jsp" method="post">
					<input type="hidden" name="teacherNo" value="<%=teacher.getTeacherNo()%>">
					<button class="btn btn-warning btn-lg" type="submit">수정</button>
				</form>
			</div>
			<div class="col-6 text-center">
				
				<form action="<%=request.getContextPath()%>/teacher/removeTeacherActrion.jsp" method="post">
					<input type="hidden" name="teacherNo" value="<%=teacher.getTeacherNo()%>">
					<button class="btn btn-warning btn-lg" type="submit">삭제</button>
				</form>
			</div>
		</div>
	</div>
</div>
</body>
</html>