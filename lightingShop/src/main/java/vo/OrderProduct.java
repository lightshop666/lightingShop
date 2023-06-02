package vo;

public class OrderProduct {
	private int orderProductNo;
	private int orderNo;
	private int productNo;
	private int productCnt;
	private String deliveryStatus;
	public int getOrderProductNo() {
		return orderProductNo;
	}
	public void setOrderProductNo(int orderProductNo) {
		this.orderProductNo = orderProductNo;
	}
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public int getProductCnt() {
		return productCnt;
	}
	public void setProductCnt(int productCnt) {
		this.productCnt = productCnt;
	}
	public String getDeliveryStatus() {
		return deliveryStatus;
	}
	public void setDeliveryStatus(String deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}

}
