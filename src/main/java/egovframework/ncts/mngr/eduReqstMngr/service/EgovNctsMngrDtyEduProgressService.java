package egovframework.ncts.mngr.eduReqstMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;

public interface EgovNctsMngrDtyEduProgressService {
	HashMap<String, Object> selectMngrDtyEduProgressDetail(MngrDtyEduProgressVO vo) throws Exception;
	
	List<HashMap<String, Object>> selectMngrDtyEduProgressList(PageInfoVO searchVO) throws Exception;

    List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduProgressVO param) throws Exception;

	void updateDtyComplProgress(MngrDtyEduProgressVO param) throws Exception;

	void packageCertificateProgress(MngrDtyEduProgressVO param) throws Exception;

	List<HashMap<String, Object>> complAutoCheck(MngrDtyEduProgressVO param) throws Exception;

	List<HashMap<String, Object>> selectPackageDetailCodeList(MngrDtyEduProgressVO dtyEduVO) throws Exception;
}
