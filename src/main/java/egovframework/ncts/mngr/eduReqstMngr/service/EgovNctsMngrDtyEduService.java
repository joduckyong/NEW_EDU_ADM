package egovframework.ncts.mngr.eduReqstMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;

public interface EgovNctsMngrDtyEduService {
	void mngrDtyEduProcess(MngrDtyEduVO param) throws Exception;
	
	HashMap<String, Object> selectMngrDtyEduDetail(MngrDtyEduVO vo) throws Exception;

	List<HashMap<String, Object>> selectMngrDtyEduList(PageInfoVO searchVO) throws Exception;
	
	List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduApplicantVO param) throws Exception;

    List<HashMap<String, Object>> selectDtyEduList()throws Exception;
    
	HashMap<String, Object> mngrDtyEduApplicantDownload(MngrDtyEduApplicantVO param) throws Exception;

	void updateDtyInstrctrOthbcYnProcess(MngrDtyEduVO param) throws Exception;

}
