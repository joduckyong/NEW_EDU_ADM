package egovframework.ncts.mngr.homeMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrBbsManageVO extends CommonVO{
    private int bbsNo;
    private String bbsTypeCd;
    private String title;
    private String contents;
    private String hitCnt;
    private String atchFileId;
    private String orignlFileNm;
    private String frstUserNo;
    private String frstRegistPnttm;
    private String lastUserNo;
    private String lastUpdtPnttm;
    private String contentsSnapshot;
    private String bbsNm;
    private String frstUserNm;
    private String lastUserNm;
    private String centerCd;
    
    public int getBbsNo() {
        return bbsNo;
    }
    public void setBbsNo(int bbsNo) {
        this.bbsNo = bbsNo;
    }
    public String getBbsTypeCd() {
        return bbsTypeCd;
    }
    public void setBbsTypeCd(String bbsTypeCd) {
        this.bbsTypeCd = bbsTypeCd;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContents() {
        return contents;
    }
    public void setContents(String contents) {
        this.contents = contents;
    }
    public String getHitCnt() {
        return hitCnt;
    }
    public void setHitCnt(String hitCnt) {
        this.hitCnt = hitCnt;
    }
    public String getAtchFileId() {
        return atchFileId;
    }
    public void setAtchFileId(String atchFileId) {
        this.atchFileId = atchFileId;
    }
    public String getFrstUserNo() {
        return frstUserNo;
    }
    public void setFrstUserNo(String frstUserNo) {
        this.frstUserNo = frstUserNo;
    }
    public String getFrstRegistPnttm() {
        return frstRegistPnttm;
    }
    public void setFrstRegistPnttm(String frstRegistPnttm) {
        this.frstRegistPnttm = frstRegistPnttm;
    }
    public String getLastUserNo() {
        return lastUserNo;
    }
    public void setLastUserNo(String lastUserNo) {
        this.lastUserNo = lastUserNo;
    }
    public String getLastUpdtPnttm() {
        return lastUpdtPnttm;
    }
    public void setLastUpdtPnttm(String lastUpdtPnttm) {
        this.lastUpdtPnttm = lastUpdtPnttm;
    }
    public String getOrignlFileNm() {
        return orignlFileNm;
    }
    public void setOrignlFileNm(String orignlFileNm) {
        this.orignlFileNm = orignlFileNm;
    }
    public String getContentsSnapshot() {
        return contentsSnapshot;
    }
    public void setContentsSnapshot(String contentsSnapshot) {
        this.contentsSnapshot = contentsSnapshot;
    }
    public String getBbsNm() {
        return bbsNm;
    }
    public void setBbsNm(String bbsNm) {
        this.bbsNm = bbsNm;
    }
    public String getFrstUserNm() {
        return frstUserNm;
    }
    public void setFrstUserNm(String frstUserNm) {
        this.frstUserNm = frstUserNm;
    }
    public String getLastUserNm() {
        return lastUserNm;
    }
    public void setLastUserNm(String lastUserNm) {
        this.lastUserNm = lastUserNm;
    }
	public String getCenterCd() {
		return centerCd;
	}
	public void setCenterCd(String centerCd) {
		this.centerCd = centerCd;
	}
    
}
