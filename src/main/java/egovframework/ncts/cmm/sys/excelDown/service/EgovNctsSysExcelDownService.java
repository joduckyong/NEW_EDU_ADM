package egovframework.ncts.cmm.sys.excelDown.service;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.excelDown.vo.ExcelDownVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

import java.util.HashMap;
import java.util.List;

public interface EgovNctsSysExcelDownService {
	void insertExcelResn(ExcelDownVO param) throws Exception;
	List<HashMap<String, Object>> selectExcelList(PageInfoVO searchVO) throws Exception;
	HashMap<String, Object> selectExcelDownList(PageInfoVO searchVO)throws Exception;
	HashMap<String, Object> selectExcelListDetail(ExcelDownVO param) throws Exception;
	void updateExcelDown(ExcelDownVO param) throws Exception;
	void deleteExcelDown(ExcelDownVO param) throws Exception;
}
