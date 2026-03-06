package egovframework.ncts.cmm.sys.ipauth.vo;

import egovframework.com.vo.CommonVO;

public class ipAuthVO extends CommonVO{
	private String ipSeq;
	private String ipAdress    ; 
	private String ipUseAgency ; 
	private String ipUseReason ; 
	private String ipUseable   ; 
	private String useYn       ; 
	
	
	public String getIpSeq() {
		return ipSeq;
	}
	public void setIpSeq(String ipSeq) {
		this.ipSeq = ipSeq;
	}
	public String getIpAdress() {
		return ipAdress;
	}
	public void setIpAdress(String ipAdress) {
		this.ipAdress = ipAdress;
	}
	public String getIpUseAgency() {
		return ipUseAgency;
	}
	public void setIpUseAgency(String ipUseAgency) {
		this.ipUseAgency = ipUseAgency;
	}
	public String getIpUseReason() {
		return ipUseReason;
	}
	public void setIpUseReason(String ipUseReason) {
		this.ipUseReason = ipUseReason;
	}
	public String getIpUseable() {
		return ipUseable;
	}
	public void setIpUseable(String ipUseable) {
		this.ipUseable = ipUseable;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
}
