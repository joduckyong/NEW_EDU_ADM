package egovframework.ncts.mngr.common.service;

import java.util.HashMap;
import java.util.List;

import com.nbp.ncp.nes.ApiResponse;
import com.nbp.ncp.nes.model.EmailSendRequestRecipients;
import com.nbp.ncp.nes.model.EmailSendResponse;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.common.vo.MngrMailVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;


public interface EgovNctsMngrMailService {
	void mngrSendEmail(MngrMailVO mailVo, PageInfoVO pageVO) throws Exception;
    /*void getMailList() throws Exception;*/
	/*void insertMailTmpKey(PageInfoVO pageVO) throws Exception;
	void mailTargetTmpProc(MngrMailVO mailVO) throws Exception;*/
	int selectUserNoCnt() throws Exception;
	HashMap<String, Object> selectLastUserNo() throws Exception;
	List<HashMap<String, Object>> selectMailAllUserList(MngrMailVO param) throws Exception;
	
	List<HashMap<String, Object>> selectMngrMailRequestList(PageInfoVO pageVO) throws Exception;
	List<HashMap<String, Object>> selectMngrMailStatusList(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> selectMngrMailRequestDetail(MngrMailVO param) throws Exception;
	
	List<HashMap<String, Object>> selectMailAllViewUserList(PageInfoVO pageVO) throws Exception;
	void updateMailRequest(MngrMailVO mngrMailVO) throws Exception;
	void updateMailStatusList(MngrMailVO param) throws Exception;
}
