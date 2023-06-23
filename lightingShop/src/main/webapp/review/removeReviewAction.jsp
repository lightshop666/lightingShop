<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.*" %><!-- cos.jar... -->
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.io.*"%> <!-- 타입이 맞지 않는 업로드 된 불필요한 파일을 삭제하기 위해 불러옴 -->
<%
	//세션 로그인 확인
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 removeReviewAction.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- removeReviewAction.jsp");
		return;
	}
	/*
	else{//세션아이디가 없으면 리턴
		System.out.println("ReviewList.jsp로 리턴<---removeReviewAction.jsp");
		response.sendRedirect(request.getContextPath() + "/ReviewList.jsp");		
		return;
	}
	*/
	
	// 이 프로젝트 내 upload 파일 호출
	String dir = request.getServletContext().getRealPath("/reviewImg"); 
	System.out.println(dir + "<--dir-- removeReviewAction.jsp");
	
	//form에서 보내준 값들 받아온다
	int orderProductNo = Integer.parseInt(request.getParameter("orderProductNo").trim());
	String saveFilename = request.getParameter("saveFilename");
	System.out.println(orderProductNo+"<--prmt-- removeReviewAction.jsp orderProductNo");
	System.out.println(saveFilename+"<--prmt--removeReviewAction.jsp saveFilename");
	
	//삭제 모델 호출
	ReviewDao reviewDao = new ReviewDao();
	int rowsDeleted = reviewDao.deleteReview(orderProductNo);
	
	
	if (rowsDeleted > 0) {
		//행이 삭제 됐다면 파일도 지운다.
		//File을 가져온다 (경로 / saveFilename)의 이름인
		File f = new File(dir+"/"+saveFilename);
		
		//이미 파일은 업데이트가 됐기 때문에 파일이 진짜로 있다면
		if(f.exists()){
			//파일삭제
			f.delete();
			System.out.println(rowsDeleted + "행이 삭제되었으니, 파일도 삭제합니다.");
		}
	    response.sendRedirect(request.getContextPath() + "/review/reviewList.jsp");
	    System.out.println( " 모두 삭제 성공 후 reviewList로 리턴. removeReviewAction");
	    return;
	} else {
	    System.out.println( "삭제된 row가 없습니다.");
	}

%>