package egovframework.ncts.cmm.login.service;

import egovframework.com.security.vo.CustomUser;

public interface EgovNctsLoginService {

	void updateLockAt(String userId) throws Exception;
	void updateFailrCnt(CustomUser user) throws Exception;
}
