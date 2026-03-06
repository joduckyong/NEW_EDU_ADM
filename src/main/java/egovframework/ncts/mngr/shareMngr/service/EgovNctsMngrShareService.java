package egovframework.ncts.mngr.shareMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;

public interface EgovNctsMngrShareService {
	
	List<HashMap<String, Object>> selectShareList(PageInfoVO pageVO)throws Exception;
	
    HashMap<String, Object> selectShareListDetail(MngrShareVO param)throws Exception; 
    
	void shareProgress(MngrShareVO param)throws Exception;
	
	//HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO) throws Exception;

}
