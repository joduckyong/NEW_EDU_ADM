package egovframework.ncts.mngr.eduReqstMngr.vo;

import egovframework.com.vo.CommonVO;

public class MngrEduVO extends CommonVO{
	private String eduSeq             ;
	private String eduNm              ;
	private String eduDe              ;
	private String eduEndDe              ;
	private String eduBeginTimeHour   ;
	private String eduBeginTimeMin    ;
	private String eduEndTimeHour     ;
	private String eduEndTimeMin      ;
	private String calendarYn         ;
	private String eduPlace           ;
	private String eduNmpr            ;
	private String eduCn              ;
	private String eduCnSnapshot      ;
	private String eduCnHtml          ;
	private String eduProcess         ;
	private String eduSubjectvity     ;
	private String eduInstNm          ;
	private String eduInstDept        ;
	private String eduTargetType    ;
	private String homepageAt           ;
	private String weAcceptAt           ;
	private String startDe           ;
	private String startHH           ;
	private String startMM           ;
	private String endDe           ;
	private String endHH           ;
	private String endMM           ;
	private String instrctrStartDe           ;
	private String instrctrStartHH           ;
	private String instrctrStartMM           ;
	private String instrctrEndDe           ;
	private String instrctrEndHH           ;
	private String instrctrEndMM           ;
	private String centerCd           ;
	private String deptCd             ;
	private String teamCd             ;
	private int ruleNo;
	private String lectureId;
	private int eduYear;
	private int eduYearOld;
	private int jan;
	private int feb;
	private int mar;
	private int apr;
	private int may;
	private int jun;
	private int jul;
	private int aug;
	private int sept;
	private int oct;
	private int nov;
	private int dec;
	private String userId;
	private String instrctrOthbcYn;
	private String instrctrOthbcYn1;
	
	
	public int getEduYear() {
        return eduYear;
    }
    public void setEduYear(int eduYear) {
        this.eduYear = eduYear;
    }
    public int getJan() {
        return jan;
    }
    public void setJan(int jan) {
        this.jan = jan;
    }
    public int getFeb() {
        return feb;
    }
    public void setFeb(int feb) {
        this.feb = feb;
    }
    public int getMar() {
        return mar;
    }
    public void setMar(int mar) {
        this.mar = mar;
    }
    public int getApr() {
        return apr;
    }
    public void setApr(int apr) {
        this.apr = apr;
    }
    public int getMay() {
        return may;
    }
    public void setMay(int may) {
        this.may = may;
    }
    public int getJun() {
        return jun;
    }
    public void setJun(int jun) {
        this.jun = jun;
    }
    public int getJul() {
        return jul;
    }
    public void setJul(int jul) {
        this.jul = jul;
    }
    public int getAug() {
        return aug;
    }
    public void setAug(int aug) {
        this.aug = aug;
    }
    public int getSept() {
        return sept;
    }
    public void setSept(int sept) {
        this.sept = sept;
    }
    public int getOct() {
        return oct;
    }
    public void setOct(int oct) {
        this.oct = oct;
    }
    public int getNov() {
        return nov;
    }
    public void setNov(int nov) {
        this.nov = nov;
    }
    public int getDec() {
        return dec;
    }
    public void setDec(int dec) {
        this.dec = dec;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getEduEndDe() {
		return eduEndDe;
	}
	public void setEduEndDe(String eduEndDe) {
		this.eduEndDe = eduEndDe;
	}
	public String getWeAcceptAt() {
		return weAcceptAt;
	}
	public void setWeAcceptAt(String weAcceptAt) {
		this.weAcceptAt = weAcceptAt;
	}
	public String getHomepageAt() {
		return homepageAt;
	}
	public void setHomepageAt(String homepageAt) {
		this.homepageAt = homepageAt;
	}
	public String getStartDe() {
		return startDe;
	}
	public void setStartDe(String startDe) {
		this.startDe = startDe;
	}
	public String getStartHH() {
		return startHH;
	}
	public void setStartHH(String startHH) {
		this.startHH = startHH;
	}
	public String getStartMM() {
		return startMM;
	}
	public void setStartMM(String startMM) {
		this.startMM = startMM;
	}
	public String getEndDe() {
		return endDe;
	}
	public void setEndDe(String endDe) {
		this.endDe = endDe;
	}
	public String getEndHH() {
		return endHH;
	}
	public void setEndHH(String endHH) {
		this.endHH = endHH;
	}
	public String getEndMM() {
		return endMM;
	}
	public void setEndMM(String endMM) {
		this.endMM = endMM;
	}
	public String getEduCnSnapshot() {
		return eduCnSnapshot;
	}
	public void setEduCnSnapshot(String eduCnSnapshot) {
		this.eduCnSnapshot = eduCnSnapshot;
	}
	public String getEduCnHtml() {
		return eduCnHtml;
	}
	public void setEduCnHtml(String eduCnHtml) {
		this.eduCnHtml = eduCnHtml;
	}
	public String getEduSeq() {
		return eduSeq;
	}
	public void setEduSeq(String eduSeq) {
		this.eduSeq = eduSeq;
	}
	public String getEduNm() {
		return eduNm;
	}
	public void setEduNm(String eduNm) {
		this.eduNm = eduNm;
	}
	public String getEduDe() {
		return eduDe;
	}
	public void setEduDe(String eduDe) {
		this.eduDe = eduDe;
	}
	public String getEduBeginTimeHour() {
		return eduBeginTimeHour;
	}
	public void setEduBeginTimeHour(String eduBeginTimeHour) {
		this.eduBeginTimeHour = eduBeginTimeHour;
	}
	public String getEduBeginTimeMin() {
		return eduBeginTimeMin;
	}
	public void setEduBeginTimeMin(String eduBeginTimeMin) {
		this.eduBeginTimeMin = eduBeginTimeMin;
	}
	public String getEduEndTimeHour() {
		return eduEndTimeHour;
	}
	public void setEduEndTimeHour(String eduEndTimeHour) {
		this.eduEndTimeHour = eduEndTimeHour;
	}
	public String getEduEndTimeMin() {
		return eduEndTimeMin;
	}
	public void setEduEndTimeMin(String eduEndTimeMin) {
		this.eduEndTimeMin = eduEndTimeMin;
	}
	public String getCalendarYn() {
		return calendarYn;
	}
	public void setCalendarYn(String calendarYn) {
		this.calendarYn = calendarYn;
	}
	public String getEduPlace() {
		return eduPlace;
	}
	public void setEduPlace(String eduPlace) {
		this.eduPlace = eduPlace;
	}
	public String getEduNmpr() {
		return eduNmpr;
	}
	public void setEduNmpr(String eduNmpr) {
		this.eduNmpr = eduNmpr;
	}
	public String getEduCn() {
		return eduCn;
	}
	public void setEduCn(String eduCn) {
		this.eduCn = eduCn;
	}
	public String getEduProcess() {
		return eduProcess;
	}
	public void setEduProcess(String eduProcess) {
		this.eduProcess = eduProcess;
	}
	public String getEduSubjectvity() {
		return eduSubjectvity;
	}
	public void setEduSubjectvity(String eduSubjectvity) {
		this.eduSubjectvity = eduSubjectvity;
	}
	public String getEduInstNm() {
		return eduInstNm;
	}
	public void setEduInstNm(String eduInstNm) {
		this.eduInstNm = eduInstNm;
	}
	public String getEduInstDept() {
		return eduInstDept;
	}
	public void setEduInstDept(String eduInstDept) {
		this.eduInstDept = eduInstDept;
	}
	public String getEduTargetType() {
		return eduTargetType;
	}
	public void setEduTargetType(String eduTargetType) {
		this.eduTargetType = eduTargetType;
	}
	public String getCenterCd() {
		return centerCd;
	}
	public void setCenterCd(String centerCd) {
		this.centerCd = centerCd;
	}
	public String getDeptCd() {
		return deptCd;
	}
	public void setDeptCd(String deptCd) {
		this.deptCd = deptCd;
	}
	public String getTeamCd() {
		return teamCd;
	}
	public void setTeamCd(String teamCd) {
		this.teamCd = teamCd;
	}
    public int getRuleNo() {
        return ruleNo;
    }
    public void setRuleNo(int ruleNo) {
        this.ruleNo = ruleNo;
    }
    public String getLectureId() {
        return lectureId;
    }
    public void setLectureId(String lectureId) {
        this.lectureId = lectureId;
    }
	public int getEduYearOld() {
		return eduYearOld;
	}
	public void setEduYearOld(int eduYearOld) {
		this.eduYearOld = eduYearOld;
	}
	public String getInstrctrOthbcYn() {
		return instrctrOthbcYn;
	}
	public void setInstrctrOthbcYn(String instrctrOthbcYn) {
		this.instrctrOthbcYn = instrctrOthbcYn;
	}
	public String getInstrctrStartDe() {
		return instrctrStartDe;
	}
	public void setInstrctrStartDe(String instrctrStartDe) {
		this.instrctrStartDe = instrctrStartDe;
	}
	public String getInstrctrStartHH() {
		return instrctrStartHH;
	}
	public void setInstrctrStartHH(String instrctrStartHH) {
		this.instrctrStartHH = instrctrStartHH;
	}
	public String getInstrctrStartMM() {
		return instrctrStartMM;
	}
	public void setInstrctrStartMM(String instrctrStartMM) {
		this.instrctrStartMM = instrctrStartMM;
	}
	public String getInstrctrEndDe() {
		return instrctrEndDe;
	}
	public void setInstrctrEndDe(String instrctrEndDe) {
		this.instrctrEndDe = instrctrEndDe;
	}
	public String getInstrctrEndHH() {
		return instrctrEndHH;
	}
	public void setInstrctrEndHH(String instrctrEndHH) {
		this.instrctrEndHH = instrctrEndHH;
	}
	public String getInstrctrEndMM() {
		return instrctrEndMM;
	}
	public void setInstrctrEndMM(String instrctrEndMM) {
		this.instrctrEndMM = instrctrEndMM;
	}
	public String getInstrctrOthbcYn1() {
		return instrctrOthbcYn1;
	}
	public void setInstrctrOthbcYn1(String instrctrOthbcYn1) {
		this.instrctrOthbcYn1 = instrctrOthbcYn1;
	}
	
}                                     
