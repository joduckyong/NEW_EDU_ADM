package egovframework.ncts.mngr.common.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.vo.MngrMailVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrMailMapper {
	// member
	List<HashMap<String, Object>> selectMailAllUserList(MngrMailVO mngrMailVO) throws Exception;
	HashMap<String, Object> selectMailUserNo(MngrMemberVO param) throws Exception;
	String selectUserEmail(String userEmail) throws Exception;
	void insertMailRequest(MngrMailVO mngrMailVO) throws Exception;
	void updateMailRequest(MngrMailVO mngrMailVO) throws Exception;
	void deleteMailRequest(MngrMailVO mngrMailVO) throws Exception;
	void mailListProc(MngrMailVO mngrMailVO) throws Exception;
	
	//void insertMailTmpKey(PageInfoVO pageVO) throws Exception;
	//void insertMailTargetTmp(MngrMailVO mngrMailVO) throws Exception;
	//void deleteMailTargetTmp(MngrMailVO mngrMailVO) throws Exception;
	int selectUserNoCnt() throws Exception;
	HashMap<String, Object> selectLastUserNo() throws Exception;
	
	List<HashMap<String, Object>> selectMngrMailRequestList(PageInfoVO pageVO) throws Exception;
	int selectMngrMailRequestListTotCnt(PageInfoVO pageVO) throws Exception;
	List<HashMap<String, Object>> selectMngrMailStatusUpdateList() throws Exception;
	List<HashMap<String, Object>> selectMngrMailStatusList(PageInfoVO pageVO) throws Exception;
	int selectMngrMailStatusListTotCnt(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> selectMngrMailRequestDetail(MngrMailVO param) throws Exception;
	
	List<HashMap<String, Object>> selectMailAllViewUserList(PageInfoVO pageVO) throws Exception;
	int selectMailAllViewUserListTotCnt(PageInfoVO pageVO) throws Exception;
}
