<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="vo.*" %>

<%
    
    EmpDao empDao = new EmpDao();

    // 선택된 할인 목록을 배열로 가져옴
    String[] selectedDiscounts = request.getParameterValues("selectedDiscount");

    // 선택된 할인 목록이 존재할 경우 삭제 수행
    if (selectedDiscounts != null) {
        for (String discountNo : selectedDiscounts) {
            // 할인 정보 삭제
            int deleteDiscountRow = empDao.deleteDiscount(Integer.parseInt(discountNo));
            
        }
    }

    // 삭제 후 할인 목록 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/admin/adminDiscountList.jsp");
%>