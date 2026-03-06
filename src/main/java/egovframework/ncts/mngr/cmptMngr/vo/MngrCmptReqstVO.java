package egovframework.ncts.mngr.cmptMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrCmptReqstVO extends CommonVO{
    private String cmptSeq               ;
    private String cmptReqstYmd        ;
    private String cmptReqstHH        ;
    private String cmptReqstMM        ;
    private String cmptReqstTitle    ;
    private String cmptReqstContents ;
    private String cmptReqstContentsSnapshot ;
    private String reflctYn           ;
    private String reflctDate         ;
    private String reflctYmd         ;
    private String reflctHH          ;
    private String reflctMM          ;
    private String contentsSnapshot;
    private String contents;
    private String centerCd;
    private String answerConfirmAt;
    
    public String getContentsSnapshot() {
        return contentsSnapshot;
    }
    public void setContentsSnapshot(String contentsSnapshot) {
        this.contentsSnapshot = contentsSnapshot;
    }
    public String getContents() {
        return contents;
    }
    public void setContents(String contents) {
        this.contents = contents;
    }
    public String getCmptSeq() {
		return cmptSeq;
	}
	public void setCmptSeq(String cmptSeq) {
		this.cmptSeq = cmptSeq;
	}
	public String getCmptReqstYmd() {
		return cmptReqstYmd;
	}
	public void setCmptReqstYmd(String cmptReqstYmd) {
		this.cmptReqstYmd = cmptReqstYmd;
	}
	public String getCmptReqstHH() {
		return cmptReqstHH;
	}
	public void setCmptReqstHH(String cmptReqstHH) {
		this.cmptReqstHH = cmptReqstHH;
	}
	public String getCmptReqstMM() {
		return cmptReqstMM;
	}
	public void setCmptReqstMM(String cmptReqstMM) {
		this.cmptReqstMM = cmptReqstMM;
	}
	public String getCmptReqstTitle() {
		return cmptReqstTitle;
	}
	public void setCmptReqstTitle(String cmptReqstTitle) {
		this.cmptReqstTitle = cmptReqstTitle;
	}
	public String getCmptReqstContents() {
		return cmptReqstContents;
	}
	public void setCmptReqstContents(String cmptReqstContents) {
		this.cmptReqstContents = cmptReqstContents;
	}
	public String getCmptReqstContentsSnapshot() {
		return cmptReqstContentsSnapshot;
	}
	public void setCmptReqstContentsSnapshot(String cmptReqstContentsSnapshot) {
		this.cmptReqstContentsSnapshot = cmptReqstContentsSnapshot;
	}
	public String getReflctYn() {
		return reflctYn;
	}
	public void setReflctYn(String reflctYn) {
		this.reflctYn = reflctYn;
	}
	public String getReflctDate() {
		return reflctDate;
	}
	public void setReflctDate(String reflctDate) {
		this.reflctDate = reflctDate;
	}
	public String getReflctYmd() {
		return reflctYmd;
	}
	public void setReflctYmd(String reflctYmd) {
		this.reflctYmd = reflctYmd;
	}
	public String getReflctHH() {
		return reflctHH;
	}
	public void setReflctHH(String reflctHH) {
		this.reflctHH = reflctHH;
	}
	public String getReflctMM() {
		return reflctMM;
	}
	public void setReflctMM(String reflctMM) {
		this.reflctMM = reflctMM;
	}
	public String getCenterCd() {
		return centerCd;
	}
	public void setCenterCd(String centerCd) {
		this.centerCd = centerCd;
	}
	public String getAnswerConfirmAt() {
		return answerConfirmAt;
	}
	public void setAnswerConfirmAt(String answerConfirmAt) {
		this.answerConfirmAt = answerConfirmAt;
	}
	
}
