<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.EmpDao" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("UTF-8");
    EmpDao empDao = new EmpDao();
    
    // 요청값 분석
    
    // 가져온 값들 확인하기
    System.out.println(request.getParameter("point"));
    
    // action 유효성검사(활성or비활성) 
    if (request.getParameter("point") == null) {
    	response.sendRedirect(request.getContextPath()+"/admin/adminModifyPoint.jsp");
    	return;
    }
    
    String id = request.getParameter("id");
    int orderNo = Integer.parseInt(request.getParameter("orderNo"));			
    String pointPm = request.getParameter("pointPm");
    String pointInfo = request.getParameter("pointInfo");
    int point = Integer.parseInt(request.getParameter("point"));
    int pointNo = Integer.parseInt(request.getParameter("pointNo"));
    

    // 디버깅 코드: HashMap에서 null 값을 가져오는 부분 체크
    System.out.println("Debugging - pointOne HashMap values:");
    System.out.println("id: " + id);
    System.out.println("orderNo: " + orderNo);
    System.out.println("pointPm: " + pointPm);
    System.out.println("pointInfo: " + pointInfo);
    System.out.println("point: " + point);
    System.out.println("pointNo: " + pointNo);
    
    //point history에 등록 후 , 등록한 후 cstmPoint도 업데이트 해주는 매소드
    HashMap<String,Object> pointOne = new HashMap<>();
    pointOne.put("id", id);
    pointOne.put("orderNo", orderNo);
    pointOne.put("pointPm", pointPm);
    pointOne.put("pointInfo", pointInfo);
    pointOne.put("point", point);
	
    int insertPointRow = empDao.insertPoint(pointOne);
	
    if (insertPointRow == 1) {
        System.out.println("입력성공");
        response.sendRedirect(request.getContextPath() + "/admin/adminPointList.jsp");
    } else {
        System.out.println("입력실패");
        response.sendRedirect(request.getContextPath() + "/admin/adminModifyPoint.jsp?pointNo="+pointNo+"&pointPm="+pointPm);
    }
%>