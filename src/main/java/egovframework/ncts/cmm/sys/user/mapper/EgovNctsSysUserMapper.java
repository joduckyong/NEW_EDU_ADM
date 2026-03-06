package egovframework.ncts.cmm.sys.user.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.user.vo.UserVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsSysUserMapper {
	void insertUser(UserVO vo) throws Exception;

	int updateUser(UserVO vo) throws Exception;

	void deleteUser(UserVO vo) throws Exception;
	
	void insertUserRole(UserVO vo) throws Exception;
	
	int updateUserRole(UserVO vo) throws Exception;

	HashMap<String, Object> selectUserDetail(UserVO vo) throws Exception;

	List<HashMap<String, Object>> selectUserList(PageInfoVO searchVO) throws Exception;

	int selectUserListTotCnt(PageInfoVO searchVO) throws Exception;
	

	void deleteUserAuthMapping(UserVO vo) throws Exception;
	
	void userInitPwd(UserVO param) throws Exception;

	HashMap<String, Object> selectAuthUserDetail(UserVO param) throws Exception;

	void insertAuthUserMapping(UserVO param) throws Exception;

	void updateAuthUserMapping(UserVO param) throws Exception;
}
