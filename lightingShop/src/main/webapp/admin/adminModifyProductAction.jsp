<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>

<%
	//enctype 에 대해 request하기위해
	String dir = request.getServletContext().getRealPath("/productImg"); 
	System.out.println(dir+"<--dir"); // commit 되기전 값이 저장되지만 war 파일로 만들면 위치가 고정된다.
	int maxFileSize = 1024*1024*10;
	DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy(); //rename cos API
	
	
	//MultipartRequest 클래스를 사용하여 원본 타입의 객체를 cos API로 래핑
	//MultipartRequest 생성자의 매개변수로는 원본 타입, 업로드 폴더 경로, 최대 파일 크기(byte), 인코딩 방식 등을 전달
	
	MultipartRequest mRequest = new MultipartRequest(request, dir, maxFileSize,"utf-8", fp);
	
	request.setCharacterEncoding("UTF-8");
	//유효성 검사	
	
	 System.out.println("productNo: " + mRequest.getParameter("productNo"));
	
    if (mRequest.getParameter("productNo") == null) {
       	response.sendRedirect(request.getContextPath()+"/admin/adminProductList.jsp");
       	
       	return;
    }
	
	//요청값 변환
	String categoryName = mRequest.getParameter("categoryName");
	String productName = mRequest.getParameter("productName");
	double productPrice = Double.parseDouble(mRequest.getParameter("productPrice"));
	String productStatus = mRequest.getParameter("productStatus");
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	String productInfo = mRequest.getParameter("productInfo");
	String productFile = mRequest.getFilesystemName("productFile"); // getFilesystemName() 메서드로 파일 시스템 이름 가져오기
	
	// 변환값 디버깅 
    System.out.println("categoryName: " + categoryName);
    System.out.println("productName: " + productName);
    System.out.println("productPrice: " + productPrice);
    System.out.println("productStatus: " + productStatus);
    System.out.println("productStock: " + productStock);
    System.out.println("productInfo: " + productInfo);
    System.out.println("productFile: " + productFile);
	
    int productNo = Integer.parseInt(mRequest.getParameter("productNo"));    
    
	HashMap<String, Object> product = new HashMap<>();
	product.put("categoryName", categoryName);
	product.put("productName", productName);
	product.put("productPrice", productPrice);
	product.put("productStatus", productStatus);
	product.put("productStock", productStock);
	product.put("productInfo", productInfo);
	product.put("productNo", productNo);
	
	EmpDao empDao = new EmpDao();
	
	int updateProductRow = empDao.updateProduct(request, product, productFile);
	
	
	
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