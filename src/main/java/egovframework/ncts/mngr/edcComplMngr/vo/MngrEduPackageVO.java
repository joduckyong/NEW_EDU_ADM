package egovframework.ncts.mngr.edcComplMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrEduPackageVO extends CommonVO{
    private String packageNo;
    private String packageNm;
    private String packageGubun;
    private String lectureId;
    private String lectureNm;
    private String courses;
    
	public String getPackageNo() {
		return packageNo;
	}
	public void setPackageNo(String packageNo) {
		this.packageNo = packageNo;
	}
	public String getPackageNm() {
		return packageNm;
	}
	public void setPackageNm(String packageNm) {
		this.packageNm = packageNm;
	}
	public String getPackageGubun() {
		return packageGubun;
	}
	public void setPackageGubun(String packageGubun) {
		this.packageGubun = packageGubun;
	}
	public String getLectureId() {
		return lectureId;
	}
	public void setLectureId(String lectureId) {
		this.lectureId = lectureId;
	}
	public String getLectureNm() {
		return lectureNm;
	}
	public void setLectureNm(String lectureNm) {
		this.lectureNm = lectureNm;
	}
	public String getCourses() {
		return courses;
	}
	public void setCourses(String courses) {
		this.courses = courses;
	}
	
}
