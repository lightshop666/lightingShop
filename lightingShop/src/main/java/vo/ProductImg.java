package vo;

public class ProductImg {
	private int productNo;
	private String productOriFilename;
	private String productSaneFilename;
	private String productFiletype;
	private String createdate;
	private String updatedate;
	
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public String getProductOriFilename() {
		return productOriFilename;
	}
	public void setProductOriFilename(String productOriFilename) {
		this.productOriFilename = productOriFilename;
	}
	public String getProductSaneFilename() {
		return productSaneFilename;
	}
	public void setProductSaneFilename(String productSaneFilename) {
		this.productSaneFilename = productSaneFilename;
	}
	public String getProductFiletype() {
		return productFiletype;
	}
	public void setProductFiletype(String productFiletype) {
		this.productFiletype = productFiletype;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getUpdatedate() {
		return updatedate;
	}
	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}
}
