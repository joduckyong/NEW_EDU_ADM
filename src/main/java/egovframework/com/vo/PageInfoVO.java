package egovframework.com.vo;

import java.util.HashMap;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class PageInfoVO extends PaginationInfo{
	
	private String searchKeyword1;
	private String searchKeyword2;
	private String searchKeyword3;
	private String searchKeyword4;
	private String searchKeyword5;
	private String searchKeyword6;
	private String searchKeyword7;
	private String searchCondition1;
	private String searchCondition2;
	private String searchCondition3;
	private String searchCondition4;
	
	private String centerCd;
	private String deptCd;
	private String teamCd;
	private String userId;
	private String userNm;
	private String registerNo;
	private String registerNm;
	private String registerSeq;
	private String familySeq;
	private String progrmSeq;
	private String refnceCd;
    private String counTypeDetail;
    private String progrmType;
	private String distIndvdSeq;
	
	private String trSeq;
	
	private String sGubun;
	private String sGubun1;
	private String sGubun2;
	private String sGubun3;
	private String sGubun4;
	private String sGubun5;
	private String sGubun6;
	private String sGubun7;
	private String sGubun8;
	private String sGubun9;
	private String sGubun10;
	
	private String sYear;
	private String sMonth;
	private String sDate;
	private String sDate01;
	private String sDate02;

	private String distPageType;
	private String distSeq;
	private String distType;
	private String distGrupSeq;
	private String grupSeq;
	private String seSeq;
	private String orderSeq;
	private String orderVal;
	private String boardType;
	private String infectious;
	
	

	private String excelFileNm;
	private String excelPageNm;
	
	private String eduSeq;
	
	private int userNo;
	private int hisSq;
	
	private String registSeq;
	private String trgterGrpSeq;
	private String trgterGrpGubun;
	private String targetTmpSeq;
	private String processingYn;
	
	private String researchRegistSeq;
	private String researchRegistSet;
	
	private String bbsTypeCd;
	private String ipAdress;
	private String ipSeq;
	
	private String lastUserNo;
	private String pageType;
	private String listAllCheck;
	private String[] userNoNotInArr;
	private String[] userNoArr;
	private String requestId;
	
	private String simsaSeq;
	private String lectureId;
	private String eduDivision;
	private String certCd;
	private String instrctrDivision;
	
	private HashMap<String, Object> foreachData;
	private String instrctrNo;
	private String instrctrGubun;
	private String issueDt;
	private String extnAt;
	 
	public String getSimsaSeq() {
		return simsaSeq;
	}
	public void setSimsaSeq(String simsaSeq) {
		this.simsaSeq = simsaSeq;
	}
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
	public String getProgrmType() {
		return progrmType;
	}
	public void setProgrmType(String progrmType) {
		this.progrmType = progrmType;
	}
	public String getCounTypeDetail() {
		return counTypeDetail;
	}
	public void setCounTypeDetail(String counTypeDetail) {
		this.counTypeDetail = counTypeDetail;
	}
	public String getInfectious() {
		return infectious;
	}

	public void setInfectious(String infectious) {
		this.infectious = infectious;
	}

	public String getDistType() {
		return distType;
	}

	public void setDistType(String distType) {
		this.distType = distType;
	}

	public String getGrupSeq() {
		return grupSeq;
	}

	public void setGrupSeq(String grupSeq) {
		this.grupSeq = grupSeq;
	}

	public String getFamilySeq() {
		return familySeq;
	}

	public void setFamilySeq(String familySeq) {
		this.familySeq = familySeq;
	}

	public String getRegisterNm() {
		return registerNm;
	}

	public void setRegisterNm(String registerNm) {
		this.registerNm = registerNm;
	}

	public String getRegisterSeq() {
		return registerSeq;
	}

	public void setRegisterSeq(String registerSeq) {
		this.registerSeq = registerSeq;
	}

	public String getDistPageType() {
		return distPageType;
	}

	public void setDistPageType(String distPageType) {
		this.distPageType = distPageType;
	}

	public String getOrderSeq() {
		return orderSeq;
	}

	public void setOrderSeq(String orderSeq) {
		this.orderSeq = orderSeq;
	}

	public String getEduSeq() {
		return eduSeq;
	}

	public void setEduSeq(String eduSeq) {
		this.eduSeq = eduSeq;
	}

	public String getsDate() {
		return sDate;
	}

	public void setsDate(String sDate) {
		this.sDate = sDate;
	}

	public String getExcelPageNm() {
		return excelPageNm;
	}

	public void setExcelPageNm(String excelPageNm) {
		this.excelPageNm = excelPageNm;
	}

	public String getExcelFileNm() {
		return excelFileNm;
	}

	public void setExcelFileNm(String excelFileNm) {
		this.excelFileNm = excelFileNm;
	}

	public String getDistGrupSeq() {
		return distGrupSeq;
	}

	public void setDistGrupSeq(String distGrupSeq) {
		this.distGrupSeq = distGrupSeq;
	}

	public String getSeSeq() {
		return seSeq;
	}

	public void setSeSeq(String seSeq) {
		this.seSeq = seSeq;
	}

	public String getsGubun() {
		return sGubun;
	}

	public void setsGubun(String sGubun) {
		this.sGubun = sGubun;
	}
	
	public String getsGubun2() {
        return sGubun2;
    }

    public void setsGubun2(String sGubun2) {
        this.sGubun2 = sGubun2;
    }

	public String getsDate01() {
		return sDate01;
	}

	public void setsDate01(String sDate01) {
		this.sDate01 = sDate01;
	}

	public String getsDate02() {
		return sDate02;
	}

	public void setsDate02(String sDate02) {
		this.sDate02 = sDate02;
	}

	public String getDistIndvdSeq() {
		return distIndvdSeq;
	}

	public void setDistIndvdSeq(String distIndvdSeq) {
		this.distIndvdSeq = distIndvdSeq;
	}

	public String getsYear() {
		return sYear;
	}

	public void setsYear(String sYear) {
		this.sYear = sYear;
	}

	public String getsMonth() {
		return sMonth;
	}

	public void setsMonth(String sMonth) {
		this.sMonth = sMonth;
	}

	public String getTrSeq() {
		return trSeq;
	}

	public void setTrSeq(String trSeq) {
		this.trSeq = trSeq;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	
	public String getRegisterNo() {
		return registerNo;
	}

	public void setRegisterNo(String registerNo) {
		this.registerNo = registerNo;
	}

	public PageInfoVO() {
		super();
		setCurrentPageNo(1);
		setRecordCountPerPage(10);
		setPageSize(10);
	}
	
	public String getProgrmSeq() {
		return progrmSeq;
	}

	public void setProgrmSeq(String progrmSeq) {
		this.progrmSeq = progrmSeq;
	}

	@Override
	public void setCurrentPageNo(int currentPageNo) {
		super.setCurrentPageNo(currentPageNo);
	}
	
	@Override
	public void setRecordCountPerPage(int recordCountPerPage) {
		super.setRecordCountPerPage(recordCountPerPage);
	}

	@Override
	public void setPageSize(int pageSize) {
		super.setPageSize(pageSize);
	}

	@Override
	public void setTotalRecordCount(int totalRecordCount) {
		super.setTotalRecordCount(totalRecordCount);
	}

	public String getSearchKeyword1() {
		return searchKeyword1;
	}

	public void setSearchKeyword1(String searchKeyword1) {
		this.searchKeyword1 = searchKeyword1;
	}

	public String getSearchKeyword2() {
		return searchKeyword2;
	}

	public void setSearchKeyword2(String searchKeyword2) {
		this.searchKeyword2 = searchKeyword2;
	}

	public String getSearchKeyword3() {
		return searchKeyword3;
	}

	public void setSearchKeyword3(String searchKeyword3) {
		this.searchKeyword3 = searchKeyword3;
	}

	public String getSearchKeyword4() {
		return searchKeyword4;
	}

	public void setSearchKeyword4(String searchKeyword4) {
		this.searchKeyword4 = searchKeyword4;
	}
	
	public String getSearchKeyword5() {
		return searchKeyword5;
	}

	public void setSearchKeyword5(String searchKeyword5) {
		this.searchKeyword5 = searchKeyword5;
	}

	public String getSearchCondition1() {
		return searchCondition1;
	}

	public void setSearchCondition1(String searchCondition1) {
		this.searchCondition1 = searchCondition1;
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

	public String getSearchCondition4() {
		return searchCondition4;
	}

	public void setSearchCondition4(String searchCondition4) {
		this.searchCondition4 = searchCondition4;
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

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBoardType() {
		return boardType;
	}

	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}

	public String getDistSeq() {
		return distSeq;
	}

	public void setDistSeq(String distSeq) {
		this.distSeq = distSeq;
	}

	public String getRefnceCd() {
		return refnceCd;
	}

	public void setRefnceCd(String refnceCd) {
		this.refnceCd = refnceCd;
	}

    public int getUserNo() {
        return userNo;
    }

    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }

    public String getsGubun1() {
        return sGubun1;
    }

    public void setsGubun1(String sGubun1) {
        this.sGubun1 = sGubun1;
    }

    public int getHisSq() {
        return hisSq;
    }

    public void setHisSq(int hisSq) {
        this.hisSq = hisSq;
    }
	public String getsGubun3() {
		return sGubun3;
	}
	public void setsGubun3(String sGubun3) {
		this.sGubun3 = sGubun3;
	}
	public String getRegistSeq() {
		return registSeq;
	}
	public void setRegistSeq(String registSeq) {
		this.registSeq = registSeq;
	}
	public String getTrgterGrpSeq() {
		return trgterGrpSeq;
	}
	public void setTrgterGrpSeq(String trgterGrpSeq) {
		this.trgterGrpSeq = trgterGrpSeq;
	}
	public String getTrgterGrpGubun() {
		return trgterGrpGubun;
	}
	public void setTrgterGrpGubun(String trgterGrpGubun) {
		this.trgterGrpGubun = trgterGrpGubun;
	}
	public String getTargetTmpSeq() {
		return targetTmpSeq;
	}
	public void setTargetTmpSeq(String targetTmpSeq) {
		this.targetTmpSeq = targetTmpSeq;
	}
	public String getProcessingYn() {
		return processingYn;
	}
	public void setProcessingYn(String processingYn) {
		this.processingYn = processingYn;
	}
	public String getResearchRegistSeq() {
		return researchRegistSeq;
	}
	public void setResearchRegistSeq(String researchRegistSeq) {
		this.researchRegistSeq = researchRegistSeq;
	}
	public String getResearchRegistSet() {
		return researchRegistSet;
	}
	public void setResearchRegistSet(String researchRegistSet) {
		this.researchRegistSet = researchRegistSet;
	}
	public String getSearchKeyword6() {
		return searchKeyword6;
	}
	public void setSearchKeyword6(String searchKeyword6) {
		this.searchKeyword6 = searchKeyword6;
	}
	public String getSearchKeyword7() {
		return searchKeyword7;
	}
	public void setSearchKeyword7(String searchKeyword7) {
		this.searchKeyword7 = searchKeyword7;
	}
	public String getBbsTypeCd() {
		return bbsTypeCd;
	}
	public void setBbsTypeCd(String bbsTypeCd) {
		this.bbsTypeCd = bbsTypeCd;
	}
	public String getsGubun4() {
		return sGubun4;
	}
	public void setsGubun4(String sGubun4) {
		this.sGubun4 = sGubun4;
	}
	public String getLastUserNo() {
		return lastUserNo;
	}
	public void setLastUserNo(String lastUserNo) {
		this.lastUserNo = lastUserNo;
	}
	public String getPageType() {
		return pageType;
	}
	public void setPageType(String pageType) {
		this.pageType = pageType;
	}
	public String getListAllCheck() {
		return listAllCheck;
	}
	public void setListAllCheck(String listAllCheck) {
		this.listAllCheck = listAllCheck;
	}
	public String[] getUserNoNotInArr() {
		return userNoNotInArr;
	}
	public void setUserNoNotInArr(String[] userNoNotInArr) {
		this.userNoNotInArr = userNoNotInArr;
	}
	public String[] getUserNoArr() {
		return userNoArr;
	}
	public void setUserNoArr(String[] userNoArr) {
		this.userNoArr = userNoArr;
	}
	public String getRequestId() {
		return requestId;
	}
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}
	public String getsGubun5() {
		return sGubun5;
	}
	public void setsGubun5(String sGubun5) {
		this.sGubun5 = sGubun5;
	}
	public String getsGubun6() {
		return sGubun6;
	}
	public void setsGubun6(String sGubun6) {
		this.sGubun6 = sGubun6;
	}
	public String getsGubun7() {
		return sGubun7;
	}
	public void setsGubun7(String sGubun7) {
		this.sGubun7 = sGubun7;
	}
	public String getsGubun8() {
		return sGubun8;
	}
	public void setsGubun8(String sGubun8) {
		this.sGubun8 = sGubun8;
	}
	public String getsGubun9() {
		return sGubun9;
	}
	public void setsGubun9(String sGubun9) {
		this.sGubun9 = sGubun9;
	}
	public String getsGubun10() {
		return sGubun10;
	}
	public void setsGubun10(String sGubun10) {
		this.sGubun10 = sGubun10;
	}
	public String getLectureId() {
		return lectureId;
	}
	public void setLectureId(String lectureId) {
		this.lectureId = lectureId;
	}
	public String getEduDivision() {
		return eduDivision;
	}
	public void setEduDivision(String eduDivision) {
		this.eduDivision = eduDivision;
	}
	public String getCertCd() {
		return certCd;
	}
	public void setCertCd(String certCd) {
		this.certCd = certCd;
	}
	public String getInstrctrDivision() {
		return instrctrDivision;
	}
	public void setInstrctrDivision(String instrctrDivision) {
		this.instrctrDivision = instrctrDivision;
	}
	public HashMap<String, Object> getForeachData() {
		return foreachData;
	}
	public void setForeachData(HashMap<String, Object> foreachData) {
		this.foreachData = foreachData;
	}
	public String getInstrctrNo() {
		return instrctrNo;
	}
	public void setInstrctrNo(String instrctrNo) {
		this.instrctrNo = instrctrNo;
	}
	public String getOrderVal() {
		return orderVal;
	}
	public void setOrderVal(String orderVal) {
		this.orderVal = orderVal;
	}
	public String getIssueDt() {
		return issueDt;
	}
	public void setIssueDt(String issueDt) {
		this.issueDt = issueDt;
	}
	public String getInstrctrGubun() {
		return instrctrGubun;
	}
	public void setInstrctrGubun(String instrctrGubun) {
		this.instrctrGubun = instrctrGubun;
	}
	public String getExtnAt() {
		return extnAt;
	}
	public void setExtnAt(String extnAt) {
		this.extnAt = extnAt;
	}
	
	
    
}
