package egovframework.ncts.mngr.edcComplMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrPackageRuleVO extends CommonVO{
    private String packageRuleNo;
    private String detailNo;
    private String packageRuleNm;
    private String packageNo;
    private String courses;
	public String getPackageRuleNo() {
		return packageRuleNo;
	}
	public void setPackageRuleNo(String packageRuleNo) {
		this.packageRuleNo = packageRuleNo;
	}
	public String getDetailNo() {
		return detailNo;
	}
	public void setDetailNo(String detailNo) {
		this.detailNo = detailNo;
	}
	public String getPackageRuleNm() {
		return packageRuleNm;
	}
	public void setPackageRuleNm(String packageRuleNm) {
		this.packageRuleNm = packageRuleNm;
	}
	public String getCourses() {
		return courses;
	}
	public void setCourses(String courses) {
		this.courses = courses;
	}
	public String getPackageNo() {
		return packageNo;
	}
	public void setPackageNo(String packageNo) {
		this.packageNo = packageNo;
	}
    
}
