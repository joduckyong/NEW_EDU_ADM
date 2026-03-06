package egovframework.ncts.mngr.common.vo;

import java.io.File;
import java.util.List;

import egovframework.com.vo.CommonVO;

public class MngrMailVO extends CommonVO{
	private String mailSenderAddress;
	private String mailSenderName;
	private String templateSid;
	private String mailTitle;
	private String mailBody;
	private String mailBodySnapshot;
	
    private String requestId;
    private String mailGubun;
    private String userNo;
    private String sendStatus;    
    private String requestDate;    
    private String sendDate;
    
    private String mailId;
    private String listAllCheck;
    private String eduSeq;
    
    private String mailTmpSeq;
    
    
    private String[] userNoArr;
    private String[] userNoNotInArr;
    private String lastUserNo;
    private String mailSenderCnt;
    private String userEmail;
    private String userNm;
    private String requestSubject;
    private List<File> fileList;
    private String centerCd;
    
	public String getMailSenderAddress() {
		return mailSenderAddress;
	}
	public void setMailSenderAddress(String mailSenderAddress) {
		this.mailSenderAddress = mailSenderAddress;
	}
	public String getMailSenderName() {
		return mailSenderName;
	}
	public void setMailSenderName(String mailSenderName) {
		this.mailSenderName = mailSenderName;
	}
	public String getTemplateSid() {
		return templateSid;
	}
	public void setTemplateSid(String templateSid) {
		this.templateSid = templateSid;
	}
	public String getMailTitle() {
		return mailTitle;
	}
	public void setMailTitle(String mailTitle) {
		this.mailTitle = mailTitle;
	}
	public String getMailBody() {
		return mailBody;
	}
	public void setMailBody(String mailBody) {
		this.mailBody = mailBody;
	}
	public String getRequestId() {
		return requestId;
	}
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}
	public String getMailGubun() {
		return mailGubun;
	}
	public void setMailGubun(String mailGubun) {
		this.mailGubun = mailGubun;
	}
	public String getUserNo() {
		return userNo;
	}
	public void setUserNo(String userNo) {
		this.userNo = userNo;
	}
	public String getSendStatus() {
		return sendStatus;
	}
	public void setSendStatus(String sendStatus) {
		this.sendStatus = sendStatus;
	}
	public String getRequestDate() {
		return requestDate;
	}
	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}
	public String getSendDate() {
		return sendDate;
	}
	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	public String getListAllCheck() {
		return listAllCheck;
	}
	public void setListAllCheck(String listAllCheck) {
		this.listAllCheck = listAllCheck;
	}
	public String getEduSeq() {
		return eduSeq;
	}
	public void setEduSeq(String eduSeq) {
		this.eduSeq = eduSeq;
	}
	public String getMailId() {
		return mailId;
	}
	public void setMailId(String mailId) {
		this.mailId = mailId;
	}
	public String getMailTmpSeq() {
		return mailTmpSeq;
	}
	public void setMailTmpSeq(String mailTmpSeq) {
		this.mailTmpSeq = mailTmpSeq;
	}
	public String[] getUserNoArr() {
		return userNoArr;
	}
	public void setUserNoArr(String[] userNoArr) {
		this.userNoArr = userNoArr;
	}
	public String getLastUserNo() {
		return lastUserNo;
	}
	public void setLastUserNo(String lastUserNo) {
		this.lastUserNo = lastUserNo;
	}
	public String[] getUserNoNotInArr() {
		return userNoNotInArr;
	}
	public void setUserNoNotInArr(String[] userNoNotInArr) {
		this.userNoNotInArr = userNoNotInArr;
	}
	public String getMailBodySnapshot() {
		return mailBodySnapshot;
	}
	public void setMailBodySnapshot(String mailBodySnapshot) {
		this.mailBodySnapshot = mailBodySnapshot;
	}
	public String getMailSenderCnt() {
		return mailSenderCnt;
	}
	public void setMailSenderCnt(String mailSenderCnt) {
		this.mailSenderCnt = mailSenderCnt;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getRequestSubject() {
		return requestSubject;
	}
	public void setRequestSubject(String requestSubject) {
		this.requestSubject = requestSubject;
	}
	public List<File> getFileList() {
		return fileList;
	}
	public void setFileList(List<File> fileList) {
		this.fileList = fileList;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getCenterCd() {
		return centerCd;
	}
	public void setCenterCd(String centerCd) {
		this.centerCd = centerCd;
	}
	
}
