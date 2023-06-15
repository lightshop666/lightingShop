<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="vo.Product" %>
<%@ page import="vo.Discount" %>
<%@ page import="java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("UTF-8");
	
    // 할인 정보 가져오기
    int productNo = Integer.parseInt(request.getParameter("productNo"));
    String discountStart = request.getParameter("discountStart");
    String discountEnd = request.getParameter("discountEnd");
    double discountRate = Double.parseDouble(request.getParameter("discountRate"));
    
    // 할인 객체 생성
    Discount discount = new Discount();
    discount.setProductNo(productNo);
    discount.setDiscountStart(discountStart);
    discount.setDiscountEnd(discountEnd);
    discount.setDiscountRate(discountRate);
    
    EmpDao empDao = new EmpDao();
    
    int insertDiscountRow = empDao.insertDiscount(discount);
    
    String msg = null;
    if (insertDiscountRow == 1) {
        msg = URLEncoder.encode("할인 추가에 성공하였습니다.", "UTF-8");
        System.out.println("추가 성공");
    } else {
        System.out.println("추가 실패");
        msg = URLEncoder.encode("할인 추가에 실패하였습니다.", "UTF-8");
        response.sendRedirect(request.getContextPath() + "/admin/adminAddDiscount.jsp?msg=" + msg);      
        return;
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/adminDiscountList.jsp?msg=" + msg);
%>