package egovframework.com.vo;

import java.util.HashMap;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class CommonVO{
	private ProcType[] baseType = ProcType.values(); 
	private String procType        ;        
	private String useYn           ;
	private String useAt           ;
	private String delAt           ;
	private String frstRegisterId  ;
	private String frstRegistPnttm ;
	private String lastUpdusrId    ;
	private String lastUpdtPnttm   ;
	private String atchFileId      ;
	private String noTag           ;
	private int currentPageNo      ;
	private String menuCd          ;
	private String errorMsg        ;
	private String tmeSeq;
	private String pageType;
	private String homepageAt;
	private String holdYn           ;
	private String centerCd           ;
	private String eduDivision;
	private HashMap<String, Object> foreachData;
	private String bbsPw;
	private String pwSeq;
	private String typeCd;
	

	public String getPageType() {
		return pageType;
	}
	public void setPageType(String pageType) {
		this.pageType = pageType;
	}
	private Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	
	
	
	public String getTmeSeq() {
		return tmeSeq;
	}
	public void setTmeSeq(String tmeSeq) {
		this.tmeSeq = tmeSeq;
	}
	public Authentication getAuthentication() {
		return authentication;
	}
	public void setAuthentication(Authentication authentication) {
		this.authentication = authentication;
	}
	public ProcType[] getBaseType() {
		return baseType;
	}
	public void setBaseType(ProcType[] baseType) {
		this.baseType = baseType;
	}
	public String getProcType() {
		return procType;
	}

	public void setProcType(String procType) {
		this.procType = procType;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getUseAt() {
		return useAt;
	}

	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}

	public String getDelAt() {
		return delAt;
	}

	public void setDelAt(String delAt) {
		this.delAt = delAt;
	}

	public String getFrstRegisterId() {
		frstRegisterId = authentication.getName();
		return frstRegisterId;
	}

	public void setFrstRegisterId(String frstRegisterId) {
		this.frstRegisterId = frstRegisterId;
	}

	public String getFrstRegistPnttm() {
		return frstRegistPnttm;
	}

	public void setFrstRegistPnttm(String frstRegistPnttm) {
		this.frstRegistPnttm = frstRegistPnttm;
	}

	public String getLastUpdusrId() {
		lastUpdusrId = authentication.getName();
		return lastUpdusrId;
	}

	public void setLastUpdusrId(String lastUpdusrId) {
		this.lastUpdusrId = lastUpdusrId;
	}

	public String getLastUpdtPnttm() {
		return lastUpdtPnttm;
	}

	public void setLastUpdtPnttm(String lastUpdtPnttm) {
		this.lastUpdtPnttm = lastUpdtPnttm;
	}

	public String getAtchFileId() {
		return atchFileId;
	}

	public void setAtchFileId(String atchFileId) {
		this.atchFileId = atchFileId;
	}

	public String getNoTag() {
		return noTag;
	}

	public void setNoTag(String noTag) {
		this.noTag = noTag;
	}

	public int getCurrentPageNo() {
		return currentPageNo;
	}

	public void setCurrentPageNo(int currentPageNo) {
		this.currentPageNo = currentPageNo;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public String getErrorMsg() {
		return errorMsg;
	}
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
	public String getHomepageAt() {
		return homepageAt;
	}
	public void setHomepageAt(String homepageAt) {
		this.homepageAt = homepageAt;
	}
	public String getHoldYn() {
		return holdYn;
	}
	public void setHoldYn(String holdYn) {
		this.holdYn = holdYn;
	}
	public String getCenterCd() {
		return centerCd;
	}
	public void setCenterCd(String centerCd) {
		this.centerCd = centerCd;
	}
	public String getEduDivision() {
		return eduDivision;
	}
	public void setEduDivision(String eduDivision) {
		this.eduDivision = eduDivision;
	}
	public HashMap<String, Object> getForeachData() {
		return foreachData;
	}
	public void setForeachData(HashMap<String, Object> foreachData) {
		this.foreachData = foreachData;
	}
	public String getBbsPw() {
		return bbsPw;
	}
	public void setBbsPw(String bbsPw) {
		this.bbsPw = bbsPw;
	}
	public String getPwSeq() {
		return pwSeq;
	}
	public void setPwSeq(String pwSeq) {
		this.pwSeq = pwSeq;
	}
	public String getTypeCd() {
		return typeCd;
	}
	public void setTypeCd(String typeCd) {
		this.typeCd = typeCd;
	}
	
	
}
