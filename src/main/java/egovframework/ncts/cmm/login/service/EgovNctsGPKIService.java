package egovframework.ncts.cmm.login.service;

import egovframework.com.security.vo.CustomUser;

public interface EgovNctsGPKIService {

	CustomUser selectUserDN(CustomUser userInfo) throws Exception;
	void insertDn(CustomUser param) throws Exception;
}
