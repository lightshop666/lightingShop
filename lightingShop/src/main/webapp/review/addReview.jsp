<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//memberId 선언과 세션 로그인 ID가 널이 아니면 넣어준다.
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	/*
	else{
		//review 추가는 로그인 한 사람만 하게 해준다.
		System.out.println("reviewList.jsp로 리턴<---addreview.jsp");
		response.sendRedirect(request.getContextPath() + "/review/reviewList.jsp");		
		return;
	}
	*/
	//order_product_no가 review테이블 외래키이자 기본키다.
	int orderProductNo = 27;
	//orderProductNo null이면 리턴, 아니면 그 값을 넣어준다.
	/*
	if(request.getParameter("orderProductNo") == null){
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");	
		System.out.println("reviewList.jsp로 리턴");
		return;	
	}else{
		//orderProductNo 파라미터값 확인
		System.out.println(request.getParameter("orderProductNo")+"<--orderProductNo--reviewOne parm ");
		orderProductNo = Integer.parseInt(request.getParameter("orderProductNo"));
	}
	*/
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
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
<h1>리뷰 작성 페이지</h1>
		<div class="p2">
		<!-- enctype = multipart/form-data & post방식 -->
		<form action="<%=request.getContextPath()%>/review/addReviewAction.jsp" method="post" enctype="multipart/form-data">
			<table class="table table-bordered ">
		<!---------------------  리뷰 title -->
				<tr>
					<th>제목</th>
					<td><!-- required : 폼 공백일 시 submit(X) -->
						<input type="text" name="reviewTitle" required="required">
					</td>
				</tr>
				
		<!---------------------  리뷰 content -->
				<tr>
					<th>내용</th>
					<td><!-- required : 폼 공백일 시 submit(X) -->
						<textarea rows="3" cols="50" name="reviewContent" required="required"></textarea>
					</td>
				</tr>
				
		<!---------------------  
				<tr>
					<th>사용자 아이디</th>
					<td>
						<input type="text" name="memberId" value="<%=loginMemberId%>" readonly="readonly">
					</td>
				</tr>
		로그인 사용자 아이디 -->
				
		<!--------------------- 파일 업로드 -->
				<tr>
					<th>리뷰사진</th><!-- vo -->
					<td>
						<input type="file" name="reviewFile" required="required">
					</td>
				</tr>
			</table>
			<input type="hidden" name="orderProductNo" value="<%=orderProductNo%>">
			<div align="center">
				<button class="button" type="submit">리뷰 쓰기</button>			
			</div>
		</form>
	</div>
</div>
</body>
</html>