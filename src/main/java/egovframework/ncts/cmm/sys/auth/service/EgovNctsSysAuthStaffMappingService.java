package egovframework.ncts.cmm.sys.auth.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

public interface EgovNctsSysAuthStaffMappingService {

	void authMappingProcess(UserVO vo) throws Exception;

	List<HashMap<String, Object>> selectAuthStaffMappingList(PageInfoVO pageVO) throws Exception;
	
	void insertDeleteAuthRcord(UserVO param) throws Exception;
}
