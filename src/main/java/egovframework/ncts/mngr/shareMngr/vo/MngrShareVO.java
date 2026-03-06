package egovframework.ncts.mngr.shareMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrShareVO extends CommonVO{
	
	private String shareSeq;
	private String shareTitle;
	private String shareCn;
	private String shareCnSnapshot;

	
	public String getShareSeq() {
		return shareSeq;
	}
	public void setShareSeq(String shareSeq) {
		this.shareSeq = shareSeq;
	}
	public String getShareTitle() {
		return shareTitle;
	}
	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}
	public String getShareCn() {
		return shareCn;
	}
	public void setShareCn(String shareCn) {
		this.shareCn = shareCn;
	}
	public String getShareCnSnapshot() {
		return shareCnSnapshot;
	}
	public void setShareCnSnapshot(String shareCnSnapshot) {
		this.shareCnSnapshot = shareCnSnapshot;
	}


}
