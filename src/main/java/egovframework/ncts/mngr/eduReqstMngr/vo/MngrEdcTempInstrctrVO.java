package egovframework.ncts.mngr.eduReqstMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrEdcTempInstrctrVO extends CommonVO{
	private String tempSeq;
    private String instrctrNo;
    private String instrctrDivision;
    private String certCd;
    
	public String getTempSeq() {
		return tempSeq;
	}
	public void setTempSeq(String tempSeq) {
		this.tempSeq = tempSeq;
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
	
    
}
