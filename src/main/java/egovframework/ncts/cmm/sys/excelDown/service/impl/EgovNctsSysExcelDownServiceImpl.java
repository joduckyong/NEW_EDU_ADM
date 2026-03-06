package egovframework.ncts.cmm.sys.excelDown.service.impl;

import javax.annotation.Resource;

import java.util.HashMap;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.excelDown.mapper.EgovNctsSysExcelDownMapper;
import egovframework.ncts.cmm.sys.excelDown.service.EgovNctsSysExcelDownService;
import egovframework.ncts.cmm.sys.excelDown.vo.ExcelDownVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsSysExcelDownServiceImpl implements EgovNctsSysExcelDownService {
	
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysExcelDownServiceImpl.class);
	
	@Autowired
	private EgovNctsSysExcelDownMapper egovNctsSysExcelDownMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void insertExcelResn(ExcelDownVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.INSERT.equals(procType)){
        	egovNctsSysExcelDownMapper.insertExcelResn(param);
        } else{
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
	}
	
	@Override
	public List<HashMap<String, Object>> selectExcelList(PageInfoVO searchVO) throws Exception {
		int cnt = egovNctsSysExcelDownMapper.selectExcelListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return egovNctsSysExcelDownMapper.selectExcelList(searchVO);
	}
	
	@Override
	public HashMap<String, Object> selectExcelListDetail(ExcelDownVO param) throws Exception {
		HashMap<String, Object> rs = egovNctsSysExcelDownMapper.selectExcelListDetail(param);
		return rs;
	}

	@Override
	public void updateExcelDown(ExcelDownVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			egovNctsSysExcelDownMapper.updateExcelDownProcess(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	@Override
	public void deleteExcelDown(ExcelDownVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.DELETE.equals(procType)) {
			egovNctsSysExcelDownMapper.deleteExcelDownProcess(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	 public HashMap<String, Object> selectExcelDownList(PageInfoVO pageVO)throws Exception{
	        HashMap<String, Object> rs = new HashMap<>();
	        HashMap<String, Object> paramMap = new HashMap<>();
	        String fileName = "";
	        String templateFile = "";
	        
	        List<HashMap<String, Object>> rsTp = egovNctsSysExcelDownMapper.selectCommonExcel(pageVO);
	        paramMap.put("rsList",rsTp);
	        fileName = pageVO.getExcelFileNm();
	        templateFile = pageVO.getExcelPageNm();	        
	        
	        rs.put("paramMap", paramMap);
	        rs.put("fileName", fileName);
	        rs.put("templateFile", templateFile);
	        
	        return rs;
	    }

}
