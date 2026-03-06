package egovframework.ncts.cmm.sys.excelDown.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.excelDown.vo.ExcelDownVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsSysExcelDownMapper {
	void insertExcelResn(ExcelDownVO param) throws Exception;
	List<HashMap<String, Object>> selectExcelList(PageInfoVO searchVO) throws Exception;
	List<HashMap<String, Object>> selectExcelAllList(PageInfoVO searchVO) throws Exception;
	int selectExcelListTotCnt(PageInfoVO searchVO) throws Exception;
	List<HashMap<String, Object>> selectCommonExcel(PageInfoVO PageVO)throws Exception;
	HashMap<String, Object> selectExcelListDetail(ExcelDownVO param) throws Exception;
	void updateExcelDownProcess(ExcelDownVO param) throws Exception;
	void deleteExcelDownProcess(ExcelDownVO param) throws Exception;
}
