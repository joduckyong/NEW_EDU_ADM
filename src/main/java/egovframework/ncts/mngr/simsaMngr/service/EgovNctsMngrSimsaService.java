package egovframework.ncts.mngr.simsaMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

public interface EgovNctsMngrSimsaService {
	
	List<HashMap<String, Object>> selectSimsaList(PageInfoVO pageVO)throws Exception; 
	
	HashMap<String, Object> selectSimsaListDetail(MngrSimsaManageVO param)throws Exception; 
	
    void simsaProcess(MngrSimsaManageVO param)throws Exception;
    
    int deleteRequire1(MngrSimsaManageVO param)throws Exception;
    
    void deleteSimsaList(MngrSimsaManageVO param)throws Exception;
    
    int selectSimsaActiveCnt(MngrSimsaManageVO param) throws Exception;
    
    void closeUpdateYN() throws Exception;
    
    HashMap<String, Object> selectStartDePast(MngrSimsaManageVO param) throws Exception;

    List<HashMap<String, Object>> selectSimsaNumList() throws Exception;
    
    List<HashMap<String, Object>> selectSimsaAppListMain(MngrSimsaApplicantVO VO) throws Exception;
        
    HashMap<String, Object> selectAll(MngrSimsaApplicantVO VO) throws Exception;
    
    HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception;
}
