package egovframework.ncts.mngr.userMngr.vo;

import java.util.ArrayList;
import java.util.List;

import egovframework.com.vo.CommonVO;

public class MngrMemberVO extends CommonVO{
    private int userNo;
    private String userEmail;
    private String userPw;
    private String gradeCd;
    private String detailGradeCd;
    private String instrctrDetailGradeCd;
    private String gradeLockAt;
    private String pdsAuthAt;
    private String mpdsAuthAt;
    private String userNm;
    private String userBirthYmd;
    private String jobCd;
    private String jobEtcNm;
    private String activeAreaCd1;
    private String activeAreaCd2;
    private String userHpNo;
    private String academicDegreeCd;
    private String schoolNm;
    private String departmentNm;
    private String majorNm;
    private String graduationCd;
    private String graduationYmd;
    private String currentJobNm;
    private String accidentYm;
    private String accidentNm;
    private String privacyAgreeAt;
    private String authKey;
    private String authSt;
    private String delAt;
    private String userIp;
    private String frstRegisterId;
    private String frstRegistPnttm;
    private String lastUpdUsrId;
    private String lastUpdPnttm;
    private String PFA1;
    private String PFA2;
    private String PFA3;
    private String SPR;
    private String PM;
    private String Co;
    private String TT;
    private String TL;
    private String PE;
    private String CGT;
    private String PFAMG;
    private String STAIR;
    private String PFA4;
    private String PFA5;
    
    private String certCd;
    private String certComplCd;
    private String certCdList;
    private String certComplCdList;
    
    private String courseCd;
    private String[] lectureList;

    private String courses;
    
    private String fileConfirmAt;
    private String fileConfirmId;
    private String userId;
    
    private List<MngrMemberVO> memberList;
    private String[] userNoArr;    
    
    private String note;
    private String noteSeq;
    private String noteCn;
    private String pfatGradeCd;
    private String sprtGradeCd;
    private String pmptGradeCd;
    private String packageAuthAt;
    private String mpgtGradeCd;
    
    private String pfatInstrctrEntrstDe;
    private String sprtInstrctrEntrstDe;
    private String mpgtInstrctrEntrstDe;
    private String pmptInstrctrEntrstDe;
    
    public String getPfatInstrctrEntrstDe() {
		return pfatInstrctrEntrstDe;
	}
	public void setPfatInstrctrEntrstDe(String pfatInstrctrEntrstDe) {
		this.pfatInstrctrEntrstDe = pfatInstrctrEntrstDe;
	}
	public String getSprtInstrctrEntrstDe() {
		return sprtInstrctrEntrstDe;
	}
	public void setSprtInstrctrEntrstDe(String sprtInstrctrEntrstDe) {
		this.sprtInstrctrEntrstDe = sprtInstrctrEntrstDe;
	}
	public String getMpgtInstrctrEntrstDe() {
		return mpgtInstrctrEntrstDe;
	}
	public void setMpgtInstrctrEntrstDe(String mpgtInstrctrEntrstDe) {
		this.mpgtInstrctrEntrstDe = mpgtInstrctrEntrstDe;
	}
	public String getPmptInstrctrEntrstDe() {
		return pmptInstrctrEntrstDe;
	}
	public void setPmptInstrctrEntrstDe(String pmptInstrctrEntrstDe) {
		this.pmptInstrctrEntrstDe = pmptInstrctrEntrstDe;
	}
	public String getCertCd() {
		return certCd;
	}
	public void setCertCd(String certCd) {
		this.certCd = certCd;
	}
	public String getCertComplCd() {
		return certComplCd;
	}
	public void setCertComplCd(String certComplCd) {
		this.certComplCd = certComplCd;
	}
	public String getPFA1() {
        return PFA1;
    }
    public void setPFA1(String pFA1) {
        PFA1 = pFA1;
    }
    public String getPFA2() {
        return PFA2;
    }
    public void setPFA2(String pFA2) {
        PFA2 = pFA2;
    }
    public String getPFA3() {
        return PFA3;
    }
    public void setPFA3(String pFA3) {
        PFA3 = pFA3;
    }
    public String getSPR() {
        return SPR;
    }
    public void setSPR(String sPR) {
        SPR = sPR;
    }
    public String getPM() {
        return PM;
    }
    public void setPM(String pM) {
        PM = pM;
    }
    public String getCo() {
        return Co;
    }
    public void setCo(String co) {
        Co = co;
    }
    public String getTT() {
        return TT;
    }
    public void setTT(String tT) {
        TT = tT;
    }
    public String getTL() {
        return TL;
    }
    public void setTL(String tL) {
        TL = tL;
    }
    public String getPE() {
        return PE;
    }
    public void setPE(String pE) {
        PE = pE;
    }
    public String getCGT() {
        return CGT;
    }
    public void setCGT(String cGT) {
        CGT = cGT;
    }
    public String getPFAMG() {
        return PFAMG;
    }
    public void setPFAMG(String pFAMG) {
        PFAMG = pFAMG;
    }
    public String getSTAIR() {
        return STAIR;
    }
    public void setSTAIR(String sTAIR) {
        STAIR = sTAIR;
    }
    public String getPFA4() {
        return PFA4;
    }
    public void setPFA4(String pFA4) {
        PFA4 = pFA4;
    }
    public String getPFA5() {
        return PFA5;
    }
    public void setPFA5(String pFA5) {
        PFA5 = pFA5;
    }
    public int getUserNo() {
        return userNo;
    }
    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }
    public String getUserEmail() {
        return userEmail;
    }
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    public String getUserPw() {
        return userPw;
    }
    public void setUserPw(String userPw) {
        this.userPw = userPw;
    }
    public String getGradeCd() {
        return gradeCd;
    }
    public void setGradeCd(String gradeCd) {
        this.gradeCd = gradeCd;
    }
    public String getDetailGradeCd() {
        return detailGradeCd;
    }
    public void setDetailGradeCd(String detailGradeCd) {
        this.detailGradeCd = detailGradeCd;
    }
    public String getPdsAuthAt() {
        return pdsAuthAt;
    }
    public void setPdsAuthAt(String pdsAuthAt) {
        this.pdsAuthAt = pdsAuthAt;
    }
    public String getMpdsAuthAt() {
        return mpdsAuthAt;
    }
    public void setMpdsAuthAt(String mpdsAuthAt) {
        this.mpdsAuthAt = mpdsAuthAt;
    }
    public String getUserNm() {
        return userNm;
    }
    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    public String getUserBirthYmd() {
        return userBirthYmd;
    }
    public void setUserBirthYmd(String userBirthYmd) {
        this.userBirthYmd = userBirthYmd;
    }
    public String getJobCd() {
        return jobCd;
    }
    public void setJobCd(String jobCd) {
        this.jobCd = jobCd;
    }
    public String getJobEtcNm() {
        return jobEtcNm;
    }
    public void setJobEtcNm(String jobEtcNm) {
        this.jobEtcNm = jobEtcNm;
    }
    public String getActiveAreaCd1() {
		return activeAreaCd1;
	}
	public void setActiveAreaCd1(String activeAreaCd1) {
		this.activeAreaCd1 = activeAreaCd1;
	}
	public String getActiveAreaCd2() {
		return activeAreaCd2;
	}
	public void setActiveAreaCd2(String activeAreaCd2) {
		this.activeAreaCd2 = activeAreaCd2;
	}
	public String getUserHpNo() {
        return userHpNo;
    }
    public void setUserHpNo(String userHpNo) {
        this.userHpNo = userHpNo;
    }
    public String getAcademicDegreeCd() {
        return academicDegreeCd;
    }
    public void setAcademicDegreeCd(String academicDegreeCd) {
        this.academicDegreeCd = academicDegreeCd;
    }
    public String getSchoolNm() {
        return schoolNm;
    }
    public void setSchoolNm(String schoolNm) {
        this.schoolNm = schoolNm;
    }
    public String getDepartmentNm() {
        return departmentNm;
    }
    public void setDepartmentNm(String departmentNm) {
        this.departmentNm = departmentNm;
    }
    public String getMajorNm() {
        return majorNm;
    }
    public void setMajorNm(String majorNm) {
        this.majorNm = majorNm;
    }
    public String getGraduationCd() {
        return graduationCd;
    }
    public void setGraduationCd(String graduationCd) {
        this.graduationCd = graduationCd;
    }
    public String getGraduationYmd() {
        return graduationYmd;
    }
    public void setGraduationYmd(String graduationYmd) {
        this.graduationYmd = graduationYmd;
    }
    public String getCurrentJobNm() {
        return currentJobNm;
    }
    public void setCurrentJobNm(String currentJobNm) {
        this.currentJobNm = currentJobNm;
    }
    public String getAccidentYm() {
        return accidentYm;
    }
    public void setAccidentYm(String accidentYm) {
        this.accidentYm = accidentYm;
    }
    public String getAccidentNm() {
        return accidentNm;
    }
    public void setAccidentNm(String accidentNm) {
        this.accidentNm = accidentNm;
    }
    public String getPrivacyAgreeAt() {
        return privacyAgreeAt;
    }
    public void setPrivacyAgreeAt(String privacyAgreeAt) {
        this.privacyAgreeAt = privacyAgreeAt;
    }
    public String getAuthKey() {
        return authKey;
    }
    public void setAuthKey(String authKey) {
        this.authKey = authKey;
    }
    public String getAuthSt() {
        return authSt;
    }
    public void setAuthSt(String authSt) {
        this.authSt = authSt;
    }
    public String getDelAt() {
        return delAt;
    }
    public void setDelAt(String delAt) {
        this.delAt = delAt;
    }
    public String getUserIp() {
        return userIp;
    }
    public void setUserIp(String userIp) {
        this.userIp = userIp;
    }
    public String getFrstRegisterId() {
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
    public String getLastUpdUsrId() {
        return lastUpdUsrId;
    }
    public void setLastUpdUsrId(String lastUpdUsrId) {
        this.lastUpdUsrId = lastUpdUsrId;
    }
    public String getLastUpdPnttm() {
        return lastUpdPnttm;
    }
    public void setLastUpdPnttm(String lastUpdPnttm) {
        this.lastUpdPnttm = lastUpdPnttm;
    }
    public String getGradeLockAt() {
        return gradeLockAt;
    }
    public void setGradeLockAt(String gradeLockAt) {
        this.gradeLockAt = gradeLockAt;
    }
	/*public int getCertCount() {
		return certCount;
	}
	public void setCertCount(int certCount) {
		this.certCount = certCount;
	}*/
    public String getCourseCd() {
        return courseCd;
    }
    public void setCourseCd(String courseCd) {
        this.courseCd = courseCd;
    }
    public String[] getLectureList() {
        return lectureList;
    }
    public void setLectureList(String[] lectureList) {
        this.lectureList = lectureList;
    }
	public String getCourses() {
		return courses;
	}
	public void setCourses(String courses) {
		this.courses = courses;
	}
	public String getFileConfirmAt() {
		return fileConfirmAt;
	}
	public void setFileConfirmAt(String fileConfirmAt) {
		this.fileConfirmAt = fileConfirmAt;
	}
	public String getFileConfirmId() {
		return fileConfirmId;
	}
	public void setFileConfirmId(String fileConfirmId) {
		this.fileConfirmId = fileConfirmId;
	}
	public String getInstrctrDetailGradeCd() {
		return instrctrDetailGradeCd;
	}
	public void setInstrctrDetailGradeCd(String instrctrDetailGradeCd) {
		this.instrctrDetailGradeCd = instrctrDetailGradeCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public List<MngrMemberVO> getMemberList() {
		return memberList;
	}
	public void setMemberList(List<MngrMemberVO> memberList) {
		this.memberList = memberList;
	}
	public String[] getUserNoArr() {
		return userNoArr;
	}
	public void setUserNoArr(String[] userNoArr) {
		this.userNoArr = userNoArr;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getPfatGradeCd() {
		return pfatGradeCd;
	}
	public void setPfatGradeCd(String pfatGradeCd) {
		this.pfatGradeCd = pfatGradeCd;
	}
	public String getSprtGradeCd() {
		return sprtGradeCd;
	}
	public void setSprtGradeCd(String sprtGradeCd) {
		this.sprtGradeCd = sprtGradeCd;
	}
	public String getPmptGradeCd() {
		return pmptGradeCd;
	}
	public void setPmptGradeCd(String pmptGradeCd) {
		this.pmptGradeCd = pmptGradeCd;
	}
	public String getCertCdList() {
		return certCdList;
	}
	public void setCertCdList(String certCdList) {
		this.certCdList = certCdList;
	}
	public String getCertComplCdList() {
		return certComplCdList;
	}
	public void setCertComplCdList(String certComplCdList) {
		this.certComplCdList = certComplCdList;
	}
	public String getPackageAuthAt() {
		return packageAuthAt;
	}
	public void setPackageAuthAt(String packageAuthAt) {
		this.packageAuthAt = packageAuthAt;
	}
	public String getMpgtGradeCd() {
		return mpgtGradeCd;
	}
	public void setMpgtGradeCd(String mpgtGradeCd) {
		this.mpgtGradeCd = mpgtGradeCd;
	}
	public String getNoteSeq() {
		return noteSeq;
	}
	public void setNoteSeq(String noteSeq) {
		this.noteSeq = noteSeq;
	}
	public String getNoteCn() {
		return noteCn;
	}
	public void setNoteCn(String noteCn) {
		this.noteCn = noteCn;
	}
	
    
}
