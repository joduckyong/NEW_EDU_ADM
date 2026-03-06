package egovframework.ncts.mngr.edcOperMngr.service;

import java.util.HashMap;

import egovframework.com.vo.PageInfoVO;

public interface EgovNctsMngrOperStatService {
	HashMap<String, Object> selectYearEduList(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> statYearEduExcelDownload(PageInfoVO pageVO) throws Exception;
	void insertDateTable() throws Exception;
}
