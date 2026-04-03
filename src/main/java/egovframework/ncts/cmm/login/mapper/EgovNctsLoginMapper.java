package egovframework.ncts.cmm.login.mapper;

import egovframework.com.security.vo.CustomUser;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsLoginMapper {
	void updateLockAt(String userId) throws Exception;
	void updateFailrCnt(CustomUser user) throws Exception;
}
