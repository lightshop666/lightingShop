<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*"%>
<%
//유효성 검사
	//세션 유효성 검사 --> 비회원은 주문할 수 없다 게스트 걸러내기
	
	
	//상품번호,수량 검사
	String[] productNo = request.getParameterValues("productNo");
	String[] productCnt = request.getParameterValues("productCnt");
	
	if (productNo == null || productNo.length == 0 || productCnt == null || productCnt.length == 0) {
	    // 선택된 상품이 없거나 수량이 입력되지 않은 경우 처리
	    System.out.println("상품번호 또는 수량이 유효하지 않습니다. <--orderProduct.jsp");
	    //-----------------------------------------------------------------------어디로 보낼지 고민--//
   		if (productNo.length > 1) {
			// 카트에서 넘어온 경우
			response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
		} else {
			// 단일 주문인 경우
			int singleProductNo = Integer.parseInt(productNo[0]);
			response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + singleProductNo);
		}
	    return;
	}
	
	 
// 선택된 상품 번호 유효성 검사
	//상품 정보 (product, product_img, discount 테이블 조회) 모델 호출
	ProductDao productDao = new ProductDao();
	List<Product> selectedProducts = new ArrayList<>();
	List<ProductImg> selectedProductImgs = new ArrayList<>();
	
	//할인된 가격 모델 호출
	OrderProductDao orderProductDao = new OrderProductDao();
	List<Integer> discountedPrices = new ArrayList<>();

	for (int i = 0; i < productNo.length; i++) {
	    int intProductNo = Integer.parseInt(productNo[i]);
	    int intProductCnt = Integer.parseInt(productCnt[i]);
	  
	    // 상품 번호의 유효성을 검사하고 상품 상세 저장
	    HashMap<String, Object> map = productDao.selectProductAndImgOne(intProductNo);
	    Product product = (Product) map.get("product");
	    ProductImg productImg = (ProductImg) map.get("productImg");
	    Discount discount = (Discount) map.get("discount");
	    
	    //상품 번호 유효성 검사
	    if (map ==null ||
	    	product.getProductNo() == 0) {
	   	    System.out.println("상품번호 유효성 getProductNo() 검사에서 튕긴다 <--orderProduct.jsp");
	        // 유효하지 않은 상품 번호인 경우 처리
			//-----------------------------------------------------------------------어디로 보낼지 고민--//
	    	response.sendRedirect(request.getContextPath() + "/ .jsp");
	        return;
	        
	    //상품이 품절인 경우    
	    }else if(product.getProductStatus().equals("품절")){
	   	    System.out.println("상품 상태가 품절입니다.<--orderProduct.jsp");
			if (productNo.length > 1) {
				// 카트에서 넘어온 경우
				response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
			} else {
				// 단일 주문인 경우
				int singleProductNo = Integer.parseInt(productNo[0]);
				response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + product.getProductNo());
			}
			
		//상품의 재고보다 많이 주문한 경우 
	    }else if(intProductCnt > product.getProductStock()){
	   	    System.out.println("재고보다 많이 주문했습니다.<--orderProduct.jsp");
			if (productNo.length > 1) {
				// 카트에서 넘어온 경우
				response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
			} else {
				// 단일 주문인 경우
				int singleProductNo = Integer.parseInt(productNo[0]);
				response.sendRedirect(request.getContextPath() + "/product/productOne.jsp?productNo=" + product.getProductNo());
			}
	    }
//-----------------------------------------------------------------유효성 검사 종료--//	    

	    // 할인된 가격 조회
	    int discountedPrice = orderProductDao.discountedPrice(intProductNo);
	    
		// 상품 정보와 이미지를 리스트에 추가
		selectedProducts.add(product);
		selectedProductImgs.add(productImg);
	    discountedPrices.add(discountedPrice);
	}
	
	//


	/*
	딜리버리 테이블 추가
	INSERT INTO discount
	(product_no, discount_start, discount_end, discount_rate, createdate, updatedate)
VALUES
	(4, '2023-05-30 00:00:00', '2023-06-11 00:00:00', 0.03, '2023-05-29 00:00:00', '2023-05-29 00:00:00');
	*/
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문하기</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	
	/*이미지 사이즈, 클릭시 풀스크린*/
	.thumbnail {
    max-width: 200px;
    cursor: pointer;
  	}
	.fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
  	}
	.fullscreen img {
    max-width: 80%;
    max-height: 80%;
	}
</style>
</head>
<body>
<div class="container">	

	<!-- 주문 상품 출력
	이름	연락처			변경(누르면 배송지 변경 --배송지 리스트 출력)
	주소
	배송시 요청사항을 선택해주세요(셀렉트)
	--
	주문상품
	상품이미지	상품정보
	상품원래 가격 /  할인된 가격
	--
	결제 방법(어떻게할지 고민)
	3-1) 상품 총액
	3-2) 포인트 적용 여부(JS로 가능하면)  
	3-3)전액 사용+항상 전액 사용 버튼(JS로 가능하면) 
	3-4)결제금액- : 상품금액 / 
	3-5)배송비(상품금액 일정 이상이면 배송비 0원으로) / 
	3-6)총 결제 금액 / 
	3-7) 결제 방법(??? 도움) 
	--
	최종 결제 금액
	(상품 금액, 포인트 금액, 배송비)
	--
	적립예정 포인트
	--
	총 할인된 가격 / ~~~원 결제 (최종금액)
	 -->
	<!-- 넘겨줄 것 : productNo배열, productCnt배열, 최종금액 -->
	<!-- 주문인 정보 -->
	<div>
	</div>

	<!-- 주문상품 -->
	<div>		
	</div>
	
	<!-- 결제 -->
	<div>		
	</div>
	
	<!-- 최종 결제 금액 -->
	<div>		
	</div>
	
	<!-- 적립예정 포인트 -->
	<div>		
	</div>

</div>
</body>
</html>