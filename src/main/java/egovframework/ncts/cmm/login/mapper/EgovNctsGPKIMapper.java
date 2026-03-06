package egovframework.ncts.cmm.login.mapper;

import egovframework.com.security.vo.CustomUser;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsGPKIMapper {

	CustomUser selectUserDN(CustomUser userInfo) throws Exception;

	void insertDn(CustomUser param) throws Exception;

}
