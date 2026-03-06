package egovframework.ncts.mngr.eduReqstMngr.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;

public interface EgovNctsMngrEduProgressService {
	void mngrEduProgressProcess(MngrEduProgressVO param) throws Exception;

	HashMap<String, Object> selectMngrEduProgressDetail(MngrEduProgressVO vo) throws Exception;
	
	List<HashMap<String, Object>> selectMngrEduProgressList(PageInfoVO searchVO) throws Exception;

    List<HashMap<String, Object>> selectMngrEduApplicantList(MngrEduProgressVO param) throws Exception;

	void updateComplProgress(MngrEduProgressVO param) throws Exception;
}
