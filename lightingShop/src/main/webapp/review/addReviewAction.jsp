<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.*" %><!-- cos.jar... -->
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*"%> <!-- 타입이 맞지 않는 업로드 된 불필요한 파일을 삭제하기 위해 불러옴 -->
<%
	request.setCharacterEncoding("utf-8");

	String loginMemberId = null;
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	/*
	else{
		//review 추가는 로그인 한 사람만 하게 해준다.
		System.out.println("reviewList.jsp로 리턴<---addReviewAction.jsp");
		response.sendRedirect(request.getContextPath() + "/review/reviewList.jsp");		
		return;
	}
	*/
	//orderProductNo 유효성 검사
		//order_product_no가 review테이블 외래키이자 기본키다.
	int orderProductNo = 26;
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
	
	
	String dir = request.getServletContext().getRealPath("/reviewImg"); // 이 프로젝트 내 파일 호출
	System.out.println(dir);
	
	int max = 10 * 1024 * 1024;
	
	// request객체를 multipartRequest의 API를 사용할 수 있도록 랩핑
	// DefaultFileRenamePolicy() 파일 중복이름 방지 -- 후에 다른 방법으로 사용
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	//업로드 파일이 jpg 파일이 아니면 리턴하겠다. cos.jar에서는 이미 파일이 들어온 이후다.--> 삭제 API import="java.io.File"
	if(mRequest.getContentType("reviewFile").equals("image/jpeg") == false){
		//이미 저장된 파일 삭제
		String saveFilename = mRequest.getFilesystemName("reviewFile");
		System.out.println(saveFilename+ "<--saveFilename-- addReviewAction.jsp");

		//File을 가져온다 (경로 / saveFilename)의 이름인
		File f = new File(dir+"\\"+saveFilename);
		//파일이 진짜로 있다면
		if(f.exists()){
			//삭제한다.
			f.delete();
		}
		//파일을 삭제해줬으니 리턴시킨다.
		response.sendRedirect(request.getContextPath()+"/review/addReview.jsp?orderProductNo=" + mRequest.getParameter("orderProductNo"));
		System.out.println("업로드 파일이 jpg가 아니라 리턴합니다 <-- addReviewAction.jsp");
		return;
	}
	
	// 1) input type ="text" 반환 API
	// review 테이블에 저장
	Review review = new Review(); // 저장 (1)
	
	review.setReviewTitle(mRequest.getParameter("reviewTitle"));
	review.setReviewContent(mRequest.getParameter("reviewContent"));
	//String memberId = mRequest.getParameter("memberId");
	review.setOrderProductNo(orderProductNo);
	System.out.println(mRequest.getParameter("reviewTitle") + "<--title-- addReviewAction.jsp");
	System.out.println(mRequest.getParameter("reviewContent") + "<--content-- addReviewAction.jsp");
	System.out.println(orderProductNo + "<--orderProductNo-- addReviewAction.jsp");

	
	// 2) input type = "file" 값(파일 메타 정보)반환 API(원본 파일 이름, 저장된 파일 이름, 컨텐츠 타입) 받아옴
	// review_file 테이블에 저장
	// 파일(바이너리)은 이미 (request랩핑시 12라인)에서 저장
	String type = mRequest.getContentType("reviewFile"); // reviewFile 받아온다. api 받는 타입 다름
	String originFilename = mRequest.getOriginalFileName("reviewFile");
	String saveFilename = mRequest.getFilesystemName("reviewFile");
	
	System.out.println(type + "<--type");
	System.out.println(originFilename + "<--originFilename");
	System.out.println(saveFilename + "<--saveFilename");
	
	// reviewFile.setreviewNo(reviewNo);
	review.setReviewFiletype(type);
	review.setReviewOriFilename(originFilename);
	review.setReviewSaveFilename(saveFilename);
	
	//review 삽입 테이블 호출
	ReviewDao reviewDao = new ReviewDao();
	
	if(reviewDao.addReview(review) != 0){
		System.out.println("추가 성공 <-- addReviewAction.jsp");
		System.out.println("리스트로 돌아갑니다. <-- addReviewAction.jsp");
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");
	}else{
		System.out.println("추가 실패 추가 페이지로 돌아갑니다.. <-- addReviewAction.jsp");
		response.sendRedirect(request.getContextPath()+"/review/addReview.jsp?orderProductNo="+review.getOrderProductNo());
	}
	return;

%>