package egovframework.ncts.mngr.shareMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.shareMngr.mapper.EgovNctsMngrShareMapper;
import egovframework.ncts.mngr.shareMngr.service.EgovNctsMngrShareService;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;


@Service
public class EgovNctsMngrShareServiceImpl implements EgovNctsMngrShareService{
	
	/** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrShareServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrShareMapper egovNctsMngrShareMapper; 
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
    @Override
    public List<HashMap<String, Object>> selectShareList(PageInfoVO pageVO)throws Exception {
    	
    	int cnt = egovNctsMngrShareMapper.selectShareTotCnt(pageVO);
    	pageVO.setTotalRecordCount(cnt);
    	
    	return egovNctsMngrShareMapper.selectShareList(pageVO);
    	
    }
	
	

	@Override
	public HashMap<String, Object> selectShareListDetail(MngrShareVO param) throws Exception {
		
		 HashMap<String, Object> rs = egovNctsMngrShareMapper.selectShareListDetail(param);
		
		 rs.put("SHARE_CN", ParamUtils.reverseHtmlTag((String)rs.get("SHARE_CN")));
		 
		  
		  String fileView = FileViewMarkupBuilder.newInstance()
		  .atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
		  .wrapMarkup("p") .isIcon(true) 
		  .isSize(true) 
		  .build() 
		  .toString();
		  rs.put("fileView", fileView);
		 
		  
		  return rs;
	}

	@Override
	public void shareProgress(MngrShareVO param) throws Exception {
		// TODO Auto-generated method stub
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) { 
			param.setNoTag(ParamUtils.removeHtmlTag(param.getShareCnSnapshot())); 
			egovNctsMngrShareMapper.insertShareList(param);
		   
	    }else if (ProcType.UPDATE.equals(procType)) { 
	    	param.setNoTag(ParamUtils.removeHtmlTag(param.getShareCnSnapshot())); 
	    	egovNctsMngrShareMapper.updateShareList(param);
	    
	    }else if (ProcType.DELETE.equals(procType)) { 
	    	
	    	egovNctsMngrShareMapper.deleteShareList(param);
	    	
		    
	    }else{
	    	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype")); 
	    }
		
	}



	/*
	 * @Override public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)
	 * throws Exception { HashMap<String, Object> rs = new HashMap<>();
	 * HashMap<String, Object> paramMap = new HashMap<>(); String fileName = "";
	 * String templateFile = "";
	 * 
	 * List<HashMap<String, Object>> rsTp =
	 * egovNctsMngrShareMapper.selectCommonExcel(pageVO);
	 * 
	 * for(int i=0; i<rsTp.size(); i++){ rsTp.get(i).put("SHARE_CN",
	 * ParamUtils.removeHtmlTag((String) rsTp.get(i).get("SHARE_CN"))); }
	 * 
	 * paramMap.put("rsList",rsTp); fileName = pageVO.getExcelFileNm(); templateFile
	 * = pageVO.getExcelPageNm();
	 * 
	 * rs.put("paramMap", paramMap); rs.put("fileName", fileName);
	 * rs.put("templateFile", templateFile);
	 * 
	 * return rs; }
	 */



	

}
