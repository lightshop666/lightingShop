<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="vo.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>

<%
	EmpDao empDao = new EmpDao();

	//enctype 에 대해 request하기위해
	String dir = request.getSession().getServletContext().getRealPath("/productImg");
	System.out.println(dir+"<--dir"); // commit 되기전 값이 저장되지만 war 파일로 만들면 위치가 고정된다.
	int maxFileSize = 1024*1024*10;
	DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy(); //rename cos API
	
	
	//MultipartRequest 클래스를 사용하여 원본 타입의 객체를 cos API로 래핑
	//MultipartRequest 생성자의 매개변수로는 원본 타입, 업로드 폴더 경로, 최대 파일 크기(byte), 인코딩 방식 등을 전달
	
	MultipartRequest mRequest = new MultipartRequest(request, dir, maxFileSize,"utf-8", fp);
	
	request.setCharacterEncoding("UTF-8");
	
 
	
	//요청값 변환
	String categoryName = mRequest.getParameter("categoryName");
	String productName = mRequest.getParameter("productName");
	double productPrice = Double.parseDouble(mRequest.getParameter("productPrice"));
	String productStatus = mRequest.getParameter("productStatus");
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	String productInfo = mRequest.getParameter("productInfo");
	
	//요청 파일 정보값 변환
	String productFile = mRequest.getFilesystemName("productFile"); // getFilesystemName() 메서드로 파일 시스템 이름 가져오기
	String originalFileName = mRequest.getOriginalFileName("productFile");
	String contentType = mRequest.getContentType("productFile"); 
	String saveFilename = mRequest.getFilesystemName("productFile");
	
	// 변환값 디버깅 
    System.out.println("categoryName: " + categoryName);
    System.out.println("productName: " + productName);
    System.out.println("productPrice: " + productPrice);
    System.out.println("productStatus: " + productStatus);
    System.out.println("productStock: " + productStock);
    System.out.println("productInfo: " + productInfo);
    System.out.println("productFile: " + productFile);
	
	int productNo = Integer.parseInt(mRequest.getParameter("productNo")); 
	  
	//기존 이미지 파일이 없으면 새로운 이미지파일 정보 가져오기
	if(mRequest.getFilesystemName("newProductFile")!=null){
		originalFileName = mRequest.getOriginalFileName("newProductFile");
		contentType = mRequest.getContentType("newProductFile"); 
		saveFilename = mRequest.getFilesystemName("newProductFile");
	
		ProductImg productImg = new ProductImg();
		productImg.setProductNo(productNo);
		productImg.setProductOriFilename(originalFileName);
		productImg.setProductSaveFilename(saveFilename);
		productImg.setProductFiletype(contentType);
		
		//기존 이미지 파일이 없는 경우엔 새로운 이미지 파일 추가 매소드 실행
		int updateProductImgRow = empDao.insertProductImg(productImg,dir);

		if (updateProductImgRow == 1) {
			System.out.println("이미지 등록성공");
		    response.sendRedirect(request.getContextPath() + "/admin/adminProductOne.jsp?productNo=" + productNo);
		    
		    return;
		} else {
			System.out.println("이미지 등록실패");
		    response.sendRedirect(request.getContextPath() + "/admin/adminProductOne.jsp?productNo=" + productNo);
		    
		    return;
		}
	}
	
    
	HashMap<String, Object> product = new HashMap<>();
	product.put("categoryName", categoryName);
	product.put("productName", productName);
	product.put("productPrice", productPrice);
	product.put("productStatus", productStatus);
	product.put("productStock", productStock);
	product.put("productInfo", productInfo);
	product.put("productNo", productNo);
	product.put("productFile", productFile);
	product.put("originalFileName", originalFileName); //요청 파일 정보값 변환
	product.put("contentType", contentType); 
	product.put("saveFilename", saveFilename);
	product.put("dir", dir);
	
	//기존파일이 있고 update 할 새로운 파일이 있는 경우엔 update실행
	int updateProductRow = empDao.updateProduct(product);
	
	if (updateProductRow == 1) {
		System.out.println("수정성공");
	    response.sendRedirect(request.getContextPath() + "/admin/adminProductOne.jsp?productNo=" + productNo);
	    
	    return;
	} else {
		System.out.println("수정실패");
	    response.sendRedirect(request.getContextPath() + "/admin/adminProductOne.jsp?productNo=" + productNo);
	    
	    return;
	}
%>