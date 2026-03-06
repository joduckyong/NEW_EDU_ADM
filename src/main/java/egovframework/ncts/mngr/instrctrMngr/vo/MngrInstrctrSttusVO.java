package egovframework.ncts.mngr.instrctrMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrInstrctrSttusVO extends CommonVO{
    private String reqstSeq;
    private String instrctrNo;
    private String instrctrDivision;
    private String certCd;
    private String searchKeyword2;
    private String rank;
    
    
	public String getReqstSeq() {
		return reqstSeq;
	}
	public void setReqstSeq(String reqstSeq) {
		this.reqstSeq = reqstSeq;
	}
	public String getInstrctrNo() {
		return instrctrNo;
	}
	public void setInstrctrNo(String instrctrNo) {
		this.instrctrNo = instrctrNo;
	}
	public String getInstrctrDivision() {
		return instrctrDivision;
	}
	public void setInstrctrDivision(String instrctrDivision) {
		this.instrctrDivision = instrctrDivision;
	}
	public String getCertCd() {
		return certCd;
	}
	public void setCertCd(String certCd) {
		this.certCd = certCd;
	}
	public String getSearchKeyword2() {
		return searchKeyword2;
	}
	public void setSearchKeyword2(String searchKeyword2) {
		this.searchKeyword2 = searchKeyword2;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
    
    
}
