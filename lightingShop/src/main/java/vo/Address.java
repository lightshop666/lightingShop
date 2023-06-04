package vo;

public class Address {
	private int addressNo;
	private String id;
	private String addressName;
	private String address;
	private String addressLastDate;
	private String DefaultAddress;
	private String createdate;
	private String updatedate;
	
	public int getAddressNo() {
		return addressNo;
	}
	public void setAddressNo(int addressNo) {
		this.addressNo = addressNo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getAddressName() {
		return addressName;
	}
	public void setAddressName(String addressName) {
		this.addressName = addressName;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getAddressLastDate() {
		return addressLastDate;
	}
	public void setAddressLastDate(String addressLastDate) {
		this.addressLastDate = addressLastDate;
	}
	public String getDefaultAddress() {
		return DefaultAddress;
	}
	public void setDefaultAddress(String defaultAddress) {
		DefaultAddress = defaultAddress;
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
