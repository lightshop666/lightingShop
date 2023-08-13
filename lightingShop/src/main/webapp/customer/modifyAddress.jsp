<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>
<%@page import="vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//로그인되지 않은경우, 회원정보수정 폼 진입 불가 -> 홈화면으로 이동
	if(session.getAttribute("loginIdListId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 개별주소 불러오는 메서드
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	CustomerDao cDao = new CustomerDao();
	Address myAddress = cDao.myAddress(addressNo);
%>   
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Amado - MyPage</title>
    
     <!-- BootStrap5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Favicon  -->
    <link rel="icon" href="<%=request.getContextPath()%>/resources/img/core-img/favicon.ico">

    <!-- Core Style CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/core-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/style.css">
   
</head>
<body>

<!-- Search Wrapper Area Start -->
<div class="search-wrapper section-padding-100">
	<div class="search-close">
		<i class="fa fa-close" aria-hidden="true"></i>
	</div>
	<div class="container">
		<div class="row">
			<div class="col-12">
				<div class="search-content">
					<form action="<%=request.getContextPath()%>/product/SearchResult.jsp" method="post">
						<input type="search" name="searchWord" id="search" placeholder="키워드를 입력하세요">
						<button type="submit"><img src="<%=request.getContextPath()%>/resources/img/core-img/search.png" alt=""></button>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

	<!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">
    
    	<!-- menu 좌측 bar -->
	    <div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix">

				 <!-- [시작] 주소목록 출력 -->
				 <section class=" login-area section-padding-100-0">
			        <div class="container">
			            <div class="row justify-content-center">
			                <div class="col-12 col-lg-10">
			                	<div class="login-content">
			                  
				                  <form id="addressModifyForm" action="<%=request.getContextPath()%>/customer/modifyAddressAction.jsp?addressNo=<%=addressNo%>" method="post">
				                  
				                  	<div class="font-bold pb-3">
										배송지
									</div>
				                    <div>
				                 		<input type="text" name="addressName" value="<%=myAddress.getAddressName()%>">
				                    </div>
				                    
				                    <hr>
				                    
				                    <div class="font-bold pb-3">
										기본배송지
									</div>
				                    <div class="select-style">
				                 		<select name="defaultAddress">
											<option value="<%=myAddress.getDefaultAddress() %>"><%=myAddress.getDefaultAddress() %></option>
											<option value="Y">기본배송지로 선택</option>
											<option value="N">기본배송지 미선택</option>
										</select>
				                    </div>
				                    
				                  	<hr>
				                  	
									<div class="font-bold pb-3">
										주소추가
									</div>
									
								    <div>
										<!-- 카카오 다음 우편번호 서비스 JS API -->
											<div class="ml-4 text-left text-center">
											<input class="mr-3 mb-1" style="width:272px;" type="text" name ="sample3Postcode" id="sample3_postcode" placeholder="우편번호" readonly="readonly">
											<input class="ml-2 mb-1" type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기"><br>
											<input class="mb-1" style="width:405px;" type="text" name ="sample3Address" id="sample3_address" placeholder="주소"><br>
											<input class="mb-1" style="width:260px;" type="text" name ="sample3DetailAddress" id="sample3_detailAddress" placeholder="상세주소">
											<input class="mb-1" style="width:140px;" type="text" id="sample3_extraAddress" placeholder="참고항목">
											</div>
											<div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
											<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
											</div>
											
											<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
											<script>
											    // 우편번호 찾기 찾기 화면을 넣을 element
											    var element_wrap = document.getElementById('wrap');
											
											    function foldDaumPostcode() {
											        // iframe을 넣은 element를 안보이게 한다.
											        element_wrap.style.display = 'none';
											    }
											
											    function sample3_execDaumPostcode() {
											        // 현재 scroll 위치를 저장해놓는다.
											        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
											        new daum.Postcode({
											            oncomplete: function(data) {
											                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
											
											                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
											                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
											                var addr = ''; // 주소 변수
											                var extraAddr = ''; // 참고항목 변수
											
											                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
											                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
											                    addr = data.roadAddress;
											                } else { // 사용자가 지번 주소를 선택했을 경우(J)
											                    addr = data.jibunAddress;
											                }
											
											                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
											                if(data.userSelectedType === 'R'){
											                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
											                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
											                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
											                        extraAddr += data.bname;
											                    }
											                    // 건물명이 있고, 공동주택일 경우 추가한다.
											                    if(data.buildingName !== '' && data.apartment === 'Y'){
											                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
											                    }
											                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
											                    if(extraAddr !== ''){
											                        extraAddr = ' (' + extraAddr + ')';
											                    }
											                    // 조합된 참고항목을 해당 필드에 넣는다.
											                    document.getElementById("sample3_extraAddress").value = extraAddr;
											                
											                } else {
											                    document.getElementById("sample3_extraAddress").value = '';
											                }
											
											                // 우편번호와 주소 정보를 해당 필드에 넣는다.
											                document.getElementById('sample3_postcode').value = data.zonecode;
											                document.getElementById("sample3_address").value = addr;
											                
											                // 커서를 상세주소 필드로 이동한다.
											                document.getElementById("sample3_detailAddress").focus();
											
											                // iframe을 넣은 element를 안보이게 한다.
											                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
											                element_wrap.style.display = 'none';
											
											                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
											                document.body.scrollTop = currentScroll;
											            },
											            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
											            onresize : function(size) {
											                element_wrap.style.height = size.height+'px';
											            },
											            width : '100%',
											            height : '100%'
											        }).embed(element_wrap);
											
											        // iframe을 넣은 element를 보이게 한다.
											        element_wrap.style.display = 'block';
											    }
											</script>
											<input type="hidden" name="address" id="addressInput">
										</div>
										<div>
											<a class="btn btn-sm btn-outline-dark mt-3" href="<%=request.getContextPath()%>/customer/addressList.jsp">취소</a>
											<button id="addressAddBtn" type="submit" class="btn btn-sm btn-outline-danger mt-3">변경</button>
										</div>
									</form>	
								
								</div>
		                	</div>
						</div>
					</div>
				</section>	<!-- [끝] 주소목록 출력 -->	
            </div>
        </div>
        <!-- Product Catagories Area End -->
    </div>
    <!-- ##### Main Content Wrapper End ##### -->
    
    <!-- footer 하단 bar -->
    <div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="<%=request.getContextPath()%>/resources/js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="<%=request.getContextPath()%>/resources/js/plugins.js"></script>
    <!-- Active js -->
    <script src="<%=request.getContextPath()%>/resources/js/active.js"></script>
    
    <script type="text/javascript">
    document.getElementById("addressAddBtn").addEventListener("click", function() {
        // 주소 값 가져오기
        var postcode = document.getElementById("sample3_postcode").value;
        var address = document.getElementById("sample3_address").value;
        var detailAddress = document.getElementById("sample3_detailAddress").value;
        
     	// 주소 값 조합하여 addressInput의 값을 설정
        var fullAddress = postcode +" "+ address + " " + detailAddress;
        document.getElementById("addressInput").value = fullAddress;
    });
    </script>

</body>
</html>
