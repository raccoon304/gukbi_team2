package map.domain;

public class StoreDTO {
    private int storeId;
    private String storeCode;
    private String storeName;
    private String address;
    private double lat;
    private double lng;
    private String description;
    private String kakaoUrl;
    private String phone;
    private int isActive;
    private String businessHours;
    private int sortNo;

    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }

    public String getStoreCode() { return storeCode; }
    public void setStoreCode(String storeCode) { this.storeCode = storeCode; }

    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public double getLat() { return lat; }
    public void setLat(double lat) { this.lat = lat; }

    public double getLng() { return lng; }
    public void setLng(double lng) { this.lng = lng; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getKakaoUrl() { return kakaoUrl; }
    public void setKakaoUrl(String kakaoUrl) { this.kakaoUrl = kakaoUrl; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }

    public String getBusinessHours() { return businessHours; }
    public void setBusinessHours(String businessHours) { this.businessHours = businessHours; }

    public int getSortNo() { return sortNo; }
    public void setSortNo(int sortNo) { this.sortNo = sortNo; }
}
