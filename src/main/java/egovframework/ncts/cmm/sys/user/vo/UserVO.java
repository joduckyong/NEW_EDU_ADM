package egovframework.ncts.cmm.sys.user.vo;

import java.util.List;

import egovframework.com.vo.CommonVO;

public class UserVO extends CommonVO{
	private String userId           ;
	private String userNm           ;
	private String userPwd          ;
	private String userBirth        ;
	private String userGender       ;
	private String userHp           ;
	private String userEmail        ;
	private String groupId          ;
	private String useAt            ;
	private String delAt            ;
	private String frstRegisterId  ;
	private String frstRegistPnttm ;
	private String lastUpdusrId    ;
	private String lastUpdtPnttm   ;
	private String centerCd;
	private String deptCd;
	private String teamCd;
	private String userQualf;
	private String roleNm          ;
	private String deptAllAuthorAt;
	private String useAtDisabledDe;
	private String lockAt;
	private String orginlLockAt;
	
	public String getUserQualf() {
		return userQualf;
	}
	public void setUserQualf(String userQualf) {
		this.userQualf = userQualf;
	}
	private List<UserVO> userList;
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserPwd() {
		return userPwd;
	}
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}
	public String getUserBirth() {
		return userBirth;
	}
	public void setUserBirth(String userBirth) {
		this.userBirth = userBirth;
	}
	public String getUserGender() {
		return userGender;
	}
	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}
	public String getUserHp() {
		return userHp;
	}
	public void setUserHp(String userHp) {
		this.userHp = userHp;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public String getDelAt() {
		return delAt;
	}
	public void setDelAt(String delAt) {
		this.delAt = delAt;
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
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public List<UserVO> getUserList() {
		return userList;
	}
	public void setUserList(List<UserVO> userList) {
		this.userList = userList;
	}
	public String getDeptAllAuthorAt() {
		return deptAllAuthorAt;
	}
	public void setDeptAllAuthorAt(String deptAllAuthorAt) {
		this.deptAllAuthorAt = deptAllAuthorAt;
	}
	public String getUseAtDisabledDe() {
		return useAtDisabledDe;
	}
	public void setUseAtDisabledDe(String useAtDisabledDe) {
		this.useAtDisabledDe = useAtDisabledDe;
	}
	public String getLockAt() {
		return lockAt;
	}
	public void setLockAt(String lockAt) {
		this.lockAt = lockAt;
	}
	public String getOrginlLockAt() {
		return orginlLockAt;
	}
	public void setOrginlLockAt(String orginlLockAt) {
		this.orginlLockAt = orginlLockAt;
	}
	
	
}
