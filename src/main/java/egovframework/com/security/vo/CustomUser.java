package egovframework.com.security.vo;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class CustomUser implements UserDetails {
	private static final long serialVersionUID = -8013266509229867163L;

	private String userId;
	private String userPw;
	private String userNm ;     
	private String userBirth;   
	private String userGender;  
	private String userHp ;     
	private String userEmail;   
	private String groupId;
	private String centerCode;
	private String centerId;
	private String centerNm;
	private String deptCd;
	private String deptNm;
	private String teamCd;
	private String teamNm;
	private String useYn ;
	private String dn;
	private String lockAt;
	private String failrCnt;	
	private String userQualfNm;
	private String deptAllAuthorAt;
	private String macUseableAt;
	private String macPort;
	private String wideArea;
	
	private List<Role> authorities;
	
	private boolean accountNonExpired = true;
	private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
	private boolean enabled = true;

	public String getCenterCode() {
		return centerCode;
	}

	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String getUsername() {
		return userId;
	}

	public void setUsername(String userId) {
		this.userId = userId;
	}

	@Override
	public String getPassword() {
		return userPw;
	}

	public void setPassword(String userPw) {
		this.userPw = userPw;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return this.authorities;
	}

	public void setAuthorities(List<Role> authorities) {
		this.authorities = authorities;
	}

	@Override
	public boolean isAccountNonExpired() {
		return this.accountNonExpired;
	}

	public void setAccountNonExpired(boolean accountNonExpired) {
		this.accountNonExpired = accountNonExpired;
	}

	@Override
	public boolean isAccountNonLocked() {
		return this.accountNonLocked;
	}

	public void setAccountNonLocked(boolean accountNonLocked) {
		this.accountNonLocked = accountNonLocked;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return this.credentialsNonExpired;
	}

	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired;
	}

	@Override
	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
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

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getCenterId() {
		return centerId;
	}

	public void setCenterId(String centerId) {
		this.centerId = centerId;
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

	public String getCenterNm() {
		return centerNm;
	}

	public void setCenterNm(String centerNm) {
		this.centerNm = centerNm;
	}

	public String getDeptNm() {
		return deptNm;
	}

	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}

	public String getTeamNm() {
		return teamNm;
	}

	public void setTeamNm(String teamNm) {
		this.teamNm = teamNm;
	}

	public String getDn() {
		return dn;
	}

	public void setDn(String dn) {
		this.dn = dn;
	}

	public String getUserQualfNm() {
		return userQualfNm;
	}

	public void setUserQualfNm(String userQualfNm) {
		this.userQualfNm = userQualfNm;
	}

	public String getDeptAllAuthorAt() {
		return deptAllAuthorAt;
	}

	public void setDeptAllAuthorAt(String deptAllAuthorAt) {
		this.deptAllAuthorAt = deptAllAuthorAt;
	}

	public String getLockAt() {
		return lockAt;
	}

	public void setLockAt(String lockAt) {
		this.lockAt = lockAt;
	}

	public String getFailrCnt() {
		return failrCnt;
	}

	public void setFailrCnt(String failrCnt) {
		this.failrCnt = failrCnt;
	}

	public String getMacUseableAt() {
		return macUseableAt;
	}

	public void setMacUseableAt(String macUseableAt) {
		this.macUseableAt = macUseableAt;
	}

	public String getMacPort() {
		return macPort;
	}

	public void setMacPort(String macPort) {
		this.macPort = macPort;
	}

	public String getWideArea() {
		return wideArea;
	}

	public void setWideArea(String wideArea) {
		this.wideArea = wideArea;
	}
	
	
}
