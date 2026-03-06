package egovframework.ncts.mngr.instrctrMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrMngrVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

public interface EgovNctsInstrctrMngrService {
    List<HashMap<String, Object>> selectInstrctrMngrList(PageInfoVO pageVO)throws Exception;

    HashMap<String, Object> selectInstrctrMngrDetail(MngrInstrctrMngrVO param)throws Exception;
    
    void mngrProc(MngrInstrctrMngrVO param) throws Exception;

    HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception;
    
    List<HashMap<String, Object>> selectInstrctrOfflectList(PageInfoVO pageVO)throws Exception;

	HashMap<String, Object> selectInstrctrOfflectExcelDownload(PageInfoVO pageVO)throws Exception;
	HashMap<String, Object> selectMngrInstrctrDetail(MngrMemberVO param) throws Exception;

	List<HashMap<String, Object>> selectInstrctrStatusList(PageInfoVO pageVO) throws Exception;
	void insertInstrctrStatus(MngrInstrctrMngrVO param) throws Exception;
}
