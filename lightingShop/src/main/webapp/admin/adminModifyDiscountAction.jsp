<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.Discount" %>
<%
    request.setCharacterEncoding("UTF-8");
    EmpDao empDao = new EmpDao();

    // 유효성 검사
        // 유효성 검사
    if (request.getParameter("discountNo") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminDiscountList.jsp");
        return;
    }
    
 	// 요청값 가져오기
    int discountNo = Integer.parseInt(request.getParameter("discountNo"));
    
    if (
        request.getParameter("productNo") == null ||
        request.getParameter("discountStart") == null ||
        request.getParameter("discountEnd") == null ||
        request.getParameter("discountRate") == null) {
    	//msg처리
        response.sendRedirect(request.getContextPath() + "/admin/adminDiscountOne.jsp?discountNo="+discountNo);
        return;
    }

    
    int productNo = Integer.parseInt(request.getParameter("productNo"));
    String discountStart = request.getParameter("discountStart");
    String discountEnd = request.getParameter("discountEnd");
    double discountRate = Double.parseDouble(request.getParameter("discountRate"));

    // 할인 정보 업데이트
    Discount discount = new Discount();
    discount.setDiscountNo(discountNo);
    discount.setProductNo(productNo);
    discount.setDiscountStart(discountStart);
    discount.setDiscountEnd(discountEnd);
    discount.setDiscountRate(discountRate);

    int row = empDao.updateDiscount(discount);

    // 업데이트 결과에 따라 분기하여 처리
    if (row == 1) {
        System.out.println("할인 정보 수정 성공");
    } else {
        System.out.println("할인 정보 수정 실패");
    }

    response.sendRedirect(request.getContextPath() + "/admin/adminDiscountOne.jsp?discountNo="+discountNo);
%>