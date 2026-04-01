package egovframework.ncts.cmm.login.service;

import java.util.List;

import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.UserSessionVO;

public interface EgovNctsLoginService {

	void updateLockAt(String userId) throws Exception;
	void updateFailrCnt(CustomUser user) throws Exception;
	
	void insertUserSession(UserSessionVO param) throws Exception;
	void deleteUserSession(String userId) throws Exception;
	List<UserSessionVO> selectActiveSessions(String userId) throws Exception;
	
	void insertVisit(CustomUser user) throws Exception;
}
