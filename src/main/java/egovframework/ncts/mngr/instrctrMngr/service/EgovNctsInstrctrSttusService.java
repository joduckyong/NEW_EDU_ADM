package egovframework.ncts.mngr.instrctrMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrSttusVO;

public interface EgovNctsInstrctrSttusService {
    List<HashMap<String, Object>> selectInstrctrSttusList(PageInfoVO pageVO)throws Exception;
    HashMap<String, Object> selectInstrctrSttusDetail(MngrInstrctrSttusVO param)throws Exception;
	HashMap<String, Object> selectInstrctrSttusExcelDownload(PageInfoVO pageVO)throws Exception;
	List<HashMap<String, Object>> selectInstrctrDetailList(PageInfoVO pageVO)throws Exception;
}
