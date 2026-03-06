package egovframework.ncts.mngr.eduReqstMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrEdcInstrctrVO extends CommonVO{
	private int reqstSeq;
	private String tempSeq;
    private String instrctrNo;
    private String instrctrDivision;
    private String dcsnYn;
    private String eduInstNo;
    private String eduAssistInstNo;
    private String oriEduDivision;
    private String certCd;
    
    
    public int getReqstSeq() {
        return reqstSeq;
    }
    public void setReqstSeq(int reqstSeq) {
        this.reqstSeq = reqstSeq;
    }
	public String getInstrctrNo() {
		return instrctrNo;
	}
	public void setInstrctrNo(String instrctrNo) {
		this.instrctrNo = instrctrNo;
	}
	public String getDcsnYn() {
		return dcsnYn;
	}
	public void setDcsnYn(String dcsnYn) {
		this.dcsnYn = dcsnYn;
	}
	public String getInstrctrDivision() {
		return instrctrDivision;
	}
	public void setInstrctrDivision(String instrctrDivision) {
		this.instrctrDivision = instrctrDivision;
	}
	public String getEduInstNo() {
		return eduInstNo;
	}
	public void setEduInstNo(String eduInstNo) {
		this.eduInstNo = eduInstNo;
	}
	public String getEduAssistInstNo() {
		return eduAssistInstNo;
	}
	public void setEduAssistInstNo(String eduAssistInstNo) {
		this.eduAssistInstNo = eduAssistInstNo;
	}
	public String getTempSeq() {
		return tempSeq;
	}
	public void setTempSeq(String tempSeq) {
		this.tempSeq = tempSeq;
	}
	public String getOriEduDivision() {
		return oriEduDivision;
	}
	public void setOriEduDivision(String oriEduDivision) {
		this.oriEduDivision = oriEduDivision;
	}
	public String getCertCd() {
		return certCd;
	}
	public void setCertCd(String certCd) {
		this.certCd = certCd;
	}
	
    
}
