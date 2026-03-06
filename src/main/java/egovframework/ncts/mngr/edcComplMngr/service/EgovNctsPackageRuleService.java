package egovframework.ncts.mngr.edcComplMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrPackageRuleVO;

public interface EgovNctsPackageRuleService {
    List<HashMap<String, Object>> selectPackageRuleList(PageInfoVO pageVO)throws Exception;
    HashMap<String, Object> selectPackageRuleDetail(MngrPackageRuleVO param)throws Exception;
    void mngrPackageRuleProc(MngrPackageRuleVO param)throws Exception;
	List<HashMap<String, Object>> selectMngrEduPackageInfoList(PageInfoVO pageVO)throws Exception;
}
