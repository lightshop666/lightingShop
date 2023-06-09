<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.*" %><!-- cos.jar... -->
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*"%> <!-- 타입이 맞지 않는 업로드 된 불필요한 파일을 삭제하기 위해 불러옴 -->
<%
	request.setCharacterEncoding("utf-8");

	//세션 로그인 확인
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 addReviewAction.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- addReviewAction.jsp");
		return;
	}
	//모델 호출
	ReviewDao reviewDao = new ReviewDao();

	String dir = request.getServletContext().getRealPath("/reviewImg"); // 이 프로젝트 내 파일 호출
	System.out.println(dir);
	
	int max = 10 * 1024 * 1024;
	
	// request객체를 multipartRequest의 API를 사용할 수 있도록 랩핑
	// DefaultFileRenamePolicy() 파일 중복이름 방지 -- 후에 다른 방법으로 사용
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	

	//orderProductNo 유효성 검사
	//order_product_no가 review테이블 외래키이자 기본키다.
	int orderProductNo = 0;
	//orderProductNo null이면 리턴, 아니면 그 값을 넣어준다.

	if(mRequest.getParameter("orderProductNo") == null){
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");	
		System.out.println("reviewList.jsp로 리턴");
		return;	
	}else{
		//orderProductNo 파라미터값 확인
		System.out.println(mRequest.getParameter("orderProductNo")+"<--orderProductNo-- addReviewAction.jsp ");
		orderProductNo = Integer.parseInt(mRequest.getParameter("orderProductNo"));
	}

	//업로드 파일이 jpg 파일이 아니면 리턴하겠다. cos.jar에서는 이미 파일이 들어온 이후다.--> 삭제 API import="java.io.File"
	if(!mRequest.getContentType("reviewFile").equals("image/jpeg")
			&&!mRequest.getContentType("reviewFile").equals("image/png")
			){
		//이미 저장된 파일 삭제
		String saveFilename = mRequest.getFilesystemName("reviewFile");
		System.out.println(saveFilename+ "<--saveFilename-- addReviewAction.jsp");

	    // DAO 메서드 호출하여 파일 삭제
	    reviewDao.deleteInvalidFile(saveFilename, dir);

		//파일을 삭제해줬으니 리턴시킨다.
		response.sendRedirect(request.getContextPath()+"/review/addReview.jsp?orderProductNo=" + mRequest.getParameter("orderProductNo"));
		System.out.println("업로드 파일이 jpg, png가 아니라 리턴합니다 <-- addReviewAction.jsp");
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