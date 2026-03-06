package egovframework.ncts.mngr.simsaMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

public interface EgovNctsMngrSimsaAppService {
	
	List<HashMap<String, Object>> selectSimsaAppList(MngrSimsaApplicantVO VO)throws Exception;

	void updateSimsaAppList(MngrSimsaApplicantVO param) throws Exception;

	HashMap<String, Object> selectSimsaAppExcelDownload(MngrSimsaApplicantVO param) throws Exception;
}
