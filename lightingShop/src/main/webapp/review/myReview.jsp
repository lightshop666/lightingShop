<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
	//세션 로그인 확인
	String loginMemberId = "guest";
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
	int totalRow = reviewDao.selectReviewCnt();
	
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
	ArrayList<Object> reviewList  = reviewDao.selectReviewListByPage(beginRow, rowPerPage, loginMemberId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Review Page</title>
</head>
<body>
<div class="container">	
	<div>
		<table class="table table-bordered">
		<%
			for (Object row : reviewList) {
			    // row 리스트에서 Review 객체와 해시맵을 분리하여 변수에 할당
			    ArrayList<Object> rowData = (ArrayList<Object>) row;
			    Review review = (Review) rowData.get(0);
			    HashMap<String, Object> hashMap = (HashMap<String, Object>) rowData.get(1);
		%>				
				<tr>
					<!-- Review 객체의 각 필드 값을 출력합니다 -->
					<td><%= review.getOrderNo() %> </td>
					<td><%= review.getReviewTitle() %> </td>
					<td><%= review.getReviewContent() %> </td>
					<td><%= review.getCreatedate() %> </td>
					<td><%= review.getUpdatedate() %> </td>
					<td><%= review.getReviewOriFilename() %> </td>
					<td>
						<img src="/img/review/<%= review.getReviewSaveFilename() %>" alt="Review Image">
					</td>
					<td><%= review.getReviewFiletype() %> </td>
					<!-- 해시맵에서 productName과 orderDate 값을 출력합니다 -->
					<td><%= hashMap.get("productName") %> </td>
					<td><%= hashMap.get("orderDate") %> </td>
				</tr>
		<%
			}
		%>
		</table>
	</div>

</div>
</body>
</html>