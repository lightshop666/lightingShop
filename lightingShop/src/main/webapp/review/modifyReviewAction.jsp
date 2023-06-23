<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.*" %><!-- cos.jar... -->
<%@ page import = "com.oreilly.servlet.multipart.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "java.io.*"%> <!-- 타입이 맞지 않는 업로드 된 불필요한 파일을 삭제하기 위해 불러옴 -->

<%
	request.setCharacterEncoding("utf-8");
	
	//세션 로그인 확인
	String loginIdListId = null;	
	if(session.getAttribute("loginIdListId") != null) {
		loginIdListId = (String)session.getAttribute("loginIdListId");
		System.out.println(loginIdListId+"<--새로 들어온 아이디 modifyReviewAction.jsp");
	}else{
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인에서 리턴 <-- modifyReviewAction.jsp");
		return;
	}
	
	//모델 호출
	ReviewDao reviewDao = new ReviewDao();
	/*
	else{
		//review 추가는 로그인 한 사람만 하게 해준다.
		System.out.println("reviewList.jsp로 리턴<---addReviewAction.jsp");
		response.sendRedirect(request.getContextPath() + "/review/reviewList.jsp");		
		return;
	}
	*/

	String dir = request.getServletContext().getRealPath("/reviewImg"); // 이 프로젝트 내 파일 호출
	System.out.println(dir);
	int max = 10 * 1024 * 1024;

	// request객체를 multipartRequest의 API를 사용할 수 있도록 랩핑
	// DefaultFileRenamePolicy() 파일 중복이름 방지 -- 후에 다른 방법으로 사용
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	
	//orderProductNo 유효성 검사
	int orderProductNo = 0;
	//orderProductNo null이면 리턴, 아니면 그 값을 넣어준다.
	if(mRequest.getParameter("orderProductNo") == null){
		response.sendRedirect(request.getContextPath()+"/review/reviewList.jsp");	
		System.out.println("orderProductNo 유효성 검사에서 리턴 modifyReviewAction.jsp  ");
		return;	
	}else{
		//orderProductNo 파라미터값 확인
		System.out.println(mRequest.getParameter("orderProductNo")+"<--orderProductNo--modifyReviewAction.jsp parm ");
		orderProductNo = Integer.parseInt(mRequest.getParameter("orderProductNo").trim());
	}
	
	
	
	// review 테이블에 파라미터값 저장
	Review review = new Review();
	
	review.setOrderProductNo(orderProductNo);
	review.setReviewTitle(mRequest.getParameter("reviewTitle"));
	review.setReviewContent(mRequest.getParameter("reviewContent"));

	// 파일 첨부를 하지 않았을 때 처리
	if (mRequest.getFile("reviewFile") == null) {
	    // 파일 첨부가 없는 경우
	    // 리뷰 업데이트 (파일명은 그대로 유지)
	    reviewDao.updateReviewWithoutFile(review);
	    
		response.sendRedirect(request.getContextPath()+"/review/reviewOne.jsp?orderProductNo=" + orderProductNo);
		System.out.println("파일 첨부 X, 수정O <-- modifyReviewAction.jsp");
	    return;
	}

	
	
	// 파일 첨부를 했을 때 처리
	if (mRequest.getFile("reviewFile") != null) {
		//업로드 파일이 jpg 파일이 아니면 리턴하겠다. cos.jar에서는 이미 파일이 들어온 이후다.--> 삭제 API import="java.io.File"
			if(!mRequest.getContentType("reviewFile").equals("image/jpeg")
			&&!mRequest.getContentType("reviewFile").equals("image/png")){
			//이미 저장된 파일 삭제
			String saveFilename = mRequest.getFilesystemName("reviewFile");
			System.out.println(saveFilename+ "<--saveFilename-- modifyReviewAction.jsp");

			//File을 가져온다 (경로 / saveFilename)의 이름인
			File f = new File(dir+"/"+saveFilename);
			//파일이 진짜로 있다면
			if(f.exists()){
				//삭제한다.
				f.delete();
			}

			//파일을 삭제해줬으니 리턴시킨다.
			response.sendRedirect(request.getContextPath()+"/review/modifyReview.jsp?orderProductNo=" + orderProductNo);
			System.out.println("업로드 파일이 jpg, png가 아니라 리턴합니다 <-- addReviewAction.jsp");
			return;
		}
		
		
	    // 파일 첨부가 있는 경우
	    // 1. 기존 파일 삭제
		String pastSaveFilename = mRequest.getParameter("pastSaveFilename");
		System.out.println(pastSaveFilename+ "<--pastSaveFilename--파일첨부 O, 기존 세이브파일 경로  modifyReviewAction.jsp");
		//File을 가져온다 (경로 / saveFilename)의 이름인
		File f = new File(dir+"\\"+pastSaveFilename);
		//파일이 진짜로 있다면
		if(f.exists()){
			//삭제한다.
			f.delete();
		}

	    // 2. 새로운 파일 업로드 처리
		
		// reviewFile.setreviewNo(reviewNo);
		review.setReviewFiletype(mRequest.getContentType("reviewFile"));
		review.setReviewOriFilename(mRequest.getOriginalFileName("reviewFile"));
		review.setReviewSaveFilename(mRequest.getFilesystemName("reviewFile"));

	    // 3. 리뷰 업데이트
	    reviewDao.updateReviewWithFile(review); // 새로운 파일명을 이용하여 리뷰 업데이트 작업 수행
	    
		response.sendRedirect(request.getContextPath()+"/review/reviewOne.jsp?orderProductNo=" + orderProductNo);
		System.out.println("파일 첨부 O, 수정O <-- modifyReviewAction.jsp");
	    return;
	}

	
	
	
	


%>