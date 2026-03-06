package egovframework.ncts.mngr.eduReqstMngr.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduRequstApplicantVO;

public interface EgovNctsMngrEdcRequestService {

    List<HashMap<String, Object>> selectMngrEdcRequestList(PageInfoVO pageVO)throws Exception;

    HashMap<String, Object> selectMngrEdcReqstDetail(MngrEdcRequestVO param)throws Exception;

    void mngrEduReqstProcess(MngrEdcRequestVO param)throws Exception;

    HashMap<String, Object> selectCommonExcel(MngrEdcRequestVO vo)throws Exception;
    
    List<HashMap<String, Object>> selectMngrEdcInstrctrAsignList(PageInfoVO pageVO)throws Exception;
    
    HashMap<String, Object> instrctrAsignProcess(MngrEdcInstrctrVO param) throws Exception;    
    
	List<HashMap<String, Object>> selectMngrEduReqstApplicantList(MngrEdcRequestVO param) throws Exception;
	
    void MngrEduReqstApplicantProcess(MngrEduRequstApplicantVO param) throws Exception;

	HashMap<String, Object> mngrEdcRequsetApplicantDownload(PageInfoVO pageVO) throws Exception;

    void updateApplAtProcess(MngrEdcRequestVO param)throws Exception;

	List<HashMap<String, Object>> selectIrregEduList() throws Exception;

	void updateReqstComplProgress(HttpServletRequest reqeust, MngrEduRequstApplicantVO param)  throws Exception;
	
    List<HashMap<String, Object>> selectReqstCenterRecordList(PageInfoVO pageVO)throws Exception;
}
