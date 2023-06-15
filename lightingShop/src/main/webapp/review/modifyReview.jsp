<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//order_product_no가 테이블 외래키이자 기본키다.
	if(request.getParameter("orderProductNo") == null){
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");	
		System.out.println("orderProductNo 유효성 검사에서 튕긴다<--reviewOne.jsp");
		return;	
	}
	System.out.println(request.getParameter("orderProductNo")+"<--orderProductNo--reviewOne.jsp parm ");
	String orderProductNoStr = request.getParameter("orderProductNo");
	int orderProductNo = Integer.parseInt(orderProductNoStr.trim());
	System.out.println(orderProductNo + "<--parm-- orderProductNo modifyReview.jsp  ");

	//세션 로그인 확인
	String loginMemberId = "test2";
	if(session.getAttribute("loginMemberId") != null) {
		//현재 로그인 사용자의 아이디
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}

	//리뷰사진 출력, 글 클릭시 상품 페이지로 이동
	//리뷰사진출력을 위한 dao 호출
	ReviewDao reviewDao = new ReviewDao();
	HashMap<String, Object> customerReview = reviewDao.customerReview(loginMemberId);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 상세</title>
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
	
	/*이미지 사이즈, 클릭시 풀스크린*/
	.thumbnail {
    max-width: 200px;
    cursor: pointer;
  	}
	.fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
  	}
	.fullscreen img {
    max-width: 80%;
    max-height: 80%;
	}
</style>
</head>
<body>
<div class="container">	
<h1>리뷰 상세 페이지</h1>
	<div>
	<form action="<%=request.getContextPath()%>/review/modifyReviewAction.jsp" method="post"  enctype="multipart/form-data">
		<table class="table table-bordered ">
			<tr>			
				<th>기존 리뷰 사진</th>
				<th>리뷰 제목</th>
				<th>리뷰 내용</th>
				<th>등록일</th>
				<th>수정일</th>
			</tr>		
			<tr>	
				<td>
					<img class="thumbnail" src="<%= request.getContextPath()%>/<%=(String)customerReview.get("reviewPath")%>/<%=(String)customerReview.get("reviewSaveFilename")%>" alt="Review Image">
					<script>
						// 이미지 클릭 시 확대/축소
						document.querySelector('.thumbnail').addEventListener('click', function() {
							var img = document.createElement('img');
							img.src = this.src;
							img.classList.add('fullscreen');
							img.addEventListener('click', function() {
								document.body.removeChild(this);
							});
							document.body.appendChild(img);
						});
					</script>
					<input type="file" name="reviewFile">
				</td>
				<td>
					<input type="text" name="reviewTitle" value="<%=customerReview.get("reviewTitle")%>">
				</td>
				<td>
					<textarea rows="3" cols="70" name="reviewContent">
						<%=customerReview.get("reviewContent")%>
					</textarea>
				</td>
				<td><%=customerReview.get("createdate")%></td>
				<td><%=customerReview.get("updatedate")%></td>
			</tr>
		</table>
		<input type="hidden" name="pastSaveFilename" value="<%=customerReview.get("reviewSaveFilename")%>">
		<input type="hidden" name="orderProductNo" value="<%=String.valueOf(orderProductNo).trim()%>">
		<button type="submit">수정</button>
	</form>		
	</div>
</div>
</body>
</html>