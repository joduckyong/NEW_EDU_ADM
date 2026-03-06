package egovframework.ncts.mngr.simsaMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrSimsaManageVO extends CommonVO{
	
	private String simsaSeq;
	private String simsaNum;
	private String simsaTitle;
	private String simsaDe;
	private String simsaEndDe;
	private String actCnt;
	private String searchCondition2;
	private String searchCondition3;

	public String getActCnt() {
		return actCnt;
	}
	public void setActCnt(String actCnt) {
		this.actCnt = actCnt;
	}
	public String getSimsaSeq() {
		return simsaSeq;
	}
	public void setSimsaSeq(String simsaSeq) {
		this.simsaSeq = simsaSeq;
	}
	public String getSimsaNum() {
		return simsaNum;
	}
	public void setSimsaNum(String simsaNum) {
		this.simsaNum = simsaNum;
	}
	public String getSimsaTitle() {
		return simsaTitle;
	}
	public void setSimsaTitle(String simsaTitle) {
		this.simsaTitle = simsaTitle;
	}
	public String getSimsaDe() {
		return simsaDe;
	}
	public void setSimsaDe(String simsaDe) {
		this.simsaDe = simsaDe;
	}
	public String getSimsaEndDe() {
		return simsaEndDe;
	}
	public void setSimsaEndDe(String simsaEndDe) {
		this.simsaEndDe = simsaEndDe;
	}
	public String getSearchCondition2() {
		return searchCondition2;
	}
	public void setSearchCondition2(String searchCondition2) {
		this.searchCondition2 = searchCondition2;
	}
	public String getSearchCondition3() {
		return searchCondition3;
	}
	public void setSearchCondition3(String searchCondition3) {
		this.searchCondition3 = searchCondition3;
	}
	
}
