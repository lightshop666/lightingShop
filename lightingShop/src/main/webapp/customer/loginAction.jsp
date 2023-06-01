<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	CustomerDao cDao = new CustomerDao();
	int loginCustomer = cDao.customerLogin(customer);
	
%>  
