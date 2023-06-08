<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="dao.EmpDao" %>
<%@ page import="vo.Product" %>
<%
    request.setCharacterEncoding("UTF-8");
	

    // 상품 정보 가져오기
    String categoryName = request.getParameter("categoryName");
    String productName = request.getParameter("productName");
    double productPrice = Double.parseDouble(request.getParameter("productPrice"));
    String productStatus = request.getParameter("productStatus");
    int productStock = Integer.parseInt(request.getParameter("productStock"));
    String productInfo = request.getParameter("productInfo");
    
    // 상품 객체 생성
    Product product = new Product();
    product.setCategoryName(categoryName);
    product.setProductName(productName);
    product.setProductPrice(productPrice);
    product.setProductStatus(productStatus);
    product.setProductStock(productStock);
    product.setProductInfo(productInfo);
    
  	
    EmpDao empDao = new EmpDao();
    
    int insertProductRow = empDao.insertProduct(product);
    
    if (insertProductRow == 1) {
        System.out.println("추가성공");
    } else {
        System.out.println("추가실패");
        response.sendRedirect(request.getContextPath() + "/admin/adminAddProduct.jsp");
        return;
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/adminProductList.jsp");
%>
%>