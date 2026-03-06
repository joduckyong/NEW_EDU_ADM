package egovframework.ncts.cmm.sys.auth.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.user.vo.UserVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsSysAuthStaffMappingMapper {
	int deleteAuthMapping(UserVO vo) throws Exception;
	
	int insertAuthMapping(UserVO vo) throws Exception;

	List<HashMap<String, Object>> selectAuthStaffMappingList(PageInfoVO pageVO) throws Exception;
	
	void insertDeleteAuthRcord(UserVO vo) throws Exception;
	
}
