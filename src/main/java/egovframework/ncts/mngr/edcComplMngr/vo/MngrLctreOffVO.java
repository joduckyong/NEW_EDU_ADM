package egovframework.ncts.mngr.edcComplMngr.vo;

import java.util.ArrayList;
import java.util.List;

import egovframework.com.vo.CommonVO;

public class MngrLctreOffVO extends CommonVO{
	private String lectureSeq;
    private String lectureId;
    private String lectureIdOld;
    private String lectureNm;
    private String lectureReplcId;
    private String courses;
    private String courses00;
    private String courses01;
    private String courses02;
    private String courses03;
    private String courses04;
    private String courses07;
    private String status;
    private String edcGoal;
    private String edcGoalSnapshot;
    private String frstRegisterId;
    private String frstRegistPnttm;
    private String lastUpdusrId;
    private String lastUpdtPnttm;
    private String atnlcStle;
    private String atnlcTime;
    private String progrmComposition;
    private String delYn;
    private String activeYn; 
    private String nonFdrmYn;
    private String edcTime;
    private String tempSeq;
    private String videoAt;
    private String videoImdtlAt;
    private String videoDuration;
    private String atnlcTaget;
    private String youtubeId;
    private String lectureSn;
    private String[] delTempSeq;
    
    
    public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getEdcGoal() {
        return edcGoal;
    }
    public void setEdcGoal(String edcGoal) {
        this.edcGoal = edcGoal;
    }
    public String getEdcGoalSnapshot() {
        return edcGoalSnapshot;
    }
    public void setEdcGoalSnapshot(String edcGoalSnapshot) {
        this.edcGoalSnapshot = edcGoalSnapshot;
    }

    public String getAtnlcStle() {
        return atnlcStle;
    }
    public void setAtnlcStle(String atnlcStle) {
        this.atnlcStle = atnlcStle;
    }
    public String getAtnlcTime() {
        return atnlcTime;
    }
    public void setAtnlcTime(String atnlcTime) {
        this.atnlcTime = atnlcTime;
    }
    
    public String getLectureNm() {
        return lectureNm;
    }
    public void setLectureNm(String lectureNm) {
        this.lectureNm = lectureNm;
    }
    public String getCourses01() {
        return courses01;
    }
    public void setCourses01(String courses01) {
        this.courses01 = courses01;
    }
    public String getCourses02() {
        return courses02;
    }
    public void setCourses02(String courses02) {
        this.courses02 = courses02;
    }
    public String getCourses03() {
        return courses03;
    }
    public void setCourses03(String courses03) {
        this.courses03 = courses03;
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
    public String getLastUpdusrId() {
        return lastUpdusrId;
    }
    public void setLastUpdusrId(String lastUpdusrId) {
        this.lastUpdusrId = lastUpdusrId;
    }
    public String getLastUpdtPnttm() {
        return lastUpdtPnttm;
    }
    public void setLastUpdtPnttm(String lastUpdtPnttm) {
        this.lastUpdtPnttm = lastUpdtPnttm;
    }

    public String getLectureId() {
        return lectureId;
    }
    public void setLectureId(String lectureId) {
        this.lectureId = lectureId;
    }
    public String getLectureReplcId() {
        return lectureReplcId;
    }
    public void setLectureReplcId(String lectureReplcId) {
        this.lectureReplcId = lectureReplcId;
    }
	public String getCourses() {
		return courses;
	}
	public void setCourses(String courses) {
		this.courses = courses;
	}
	public String getDelYn() {
		return delYn;
	}
	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}
    public String getCourses04() {
        return courses04;
    }
    public void setCourses04(String courses04) {
        this.courses04 = courses04;
    }
    public String getLectureIdOld() {
        return lectureIdOld;
    }
    public void setLectureIdOld(String lectureIdOld) {
        this.lectureIdOld = lectureIdOld;
    }
    public String getActiveYn() {
        return activeYn;
    }
    public void setActiveYn(String activeYn) {
        this.activeYn = activeYn;
    }
    public String getNonFdrmYn() {
        return nonFdrmYn;
    }
    public void setNonFdrmYn(String nonFdrmYn) {
        this.nonFdrmYn = nonFdrmYn;
    }
    public String getEdcTime() {
        return edcTime;
    }
    public void setEdcTime(String edcTime) {
        this.edcTime = edcTime;
    }
	public String getCourses00() {
		return courses00;
	}
	public void setCourses00(String courses00) {
		this.courses00 = courses00;
	}
	public String getCourses07() {
		return courses07;
	}
	public void setCourses07(String courses07) {
		this.courses07 = courses07;
	}
	public String getLectureSeq() {
		return lectureSeq;
	}
	public void setLectureSeq(String lectureSeq) {
		this.lectureSeq = lectureSeq;
	}
	public String getTempSeq() {
		return tempSeq;
	}
	public void setTempSeq(String tempSeq) {
		this.tempSeq = tempSeq;
	}
	public String getVideoDuration() {
		return videoDuration;
	}
	public void setVideoDuration(String videoDuration) {
		this.videoDuration = videoDuration;
	}
	public String getAtnlcTaget() {
		return atnlcTaget;
	}
	public void setAtnlcTaget(String atnlcTaget) {
		this.atnlcTaget = atnlcTaget;
	}
	public String getYoutubeId() {
		return youtubeId;
	}
	public void setYoutubeId(String youtubeId) {
		this.youtubeId = youtubeId;
	}
	public String getProgrmComposition() {
		return progrmComposition;
	}
	public void setProgrmComposition(String progrmComposition) {
		this.progrmComposition = progrmComposition;
	}
	public String getVideoAt() {
		return videoAt;
	}
	public void setVideoAt(String videoAt) {
		this.videoAt = videoAt;
	}
	public String getLectureSn() {
		return lectureSn;
	}
	public void setLectureSn(String lectureSn) {
		this.lectureSn = lectureSn;
	}
	public String[] getDelTempSeq() {
		return delTempSeq;
	}
	public void setDelTempSeq(String[] delTempSeq) {
		this.delTempSeq = delTempSeq;
	}
	public String getVideoImdtlAt() {
		return videoImdtlAt;
	}
	public void setVideoImdtlAt(String videoImdtlAt) {
		this.videoImdtlAt = videoImdtlAt;
	}
	
    
}
