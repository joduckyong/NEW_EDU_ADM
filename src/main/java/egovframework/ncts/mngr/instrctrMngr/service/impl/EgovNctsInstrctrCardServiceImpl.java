package egovframework.ncts.mngr.instrctrMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.thymeleaf.spring4.SpringTemplateEngine;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.SessionUtil;
import egovframework.com.TextUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.ems.service.EgovMultiPartEmail;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrActMapper;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrCardMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrCardService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrActVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrCardVO;

@Service
public class EgovNctsInstrctrCardServiceImpl implements EgovNctsInstrctrCardService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrActServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrCardMapper egovNctsInstrctrCardMapper;
    
    @Resource(name = "emailTemplateEngine")
	private SpringTemplateEngine springTemplateEngine;
	
	@Autowired
	private EgovMultiPartEmail egovMultiPartEmail;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
//  String iniFilePath = "/penta/scpdb_agent.ini";
  //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
  private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");

    
    @Override
    public List<HashMap<String, Object>> selectInstrctrCardList(PageInfoVO pageVO) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
    	
    	if (pageVO.getSearchKeyword2() != null && !"".equals(pageVO.getSearchKeyword2())) {
	    	String searchKeyword2 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword2());
	    	pageVO.setSearchKeyword2(searchKeyword2);
    	}       	
    	if (pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3())) {
    		String searchKeyword3 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword3().replaceAll("-", ""));
    		pageVO.setSearchKeyword3(searchKeyword3);
    	}       	
        int cnt = egovNctsInstrctrCardMapper.selectInstrctrCardCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        List<HashMap<String, Object>> list = egovNctsInstrctrCardMapper.selectInstrctrCardList(pageVO);

        // 결과값 변환 처리
        for (HashMap<String, Object> tmp : list) {
        	try {
	            if (tmp.get("USER_HP_NO") != null && !"".equals(String.valueOf(tmp.get("USER_HP_NO")))) {
	            	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_HP_NO").toString(),"UTF-8");
	            	tmp.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
	            }
	            if (tmp.get("USER_EMAIL") != null && !"".equals(String.valueOf(tmp.get("USER_EMAIL")))) {
	            	tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
	            }
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}   
        }

        return list;        
    }
    
    @Override
    public HashMap<String, Object> selectInstrctrCardDetail(MngrInstrctrCardVO param) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();    	
        HashMap<String, Object> result = egovNctsInstrctrCardMapper.selectInstrctrCardDetail(param);
        try {
	        if (result.get("USER_HP_NO") != null && !"".equals(String.valueOf(result.get("USER_HP_NO")))) {
	        	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_HP_NO").toString(),"UTF-8");
	        	result.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
	        }
	        if (result.get("USER_EMAIL") != null && !"".equals(String.valueOf(result.get("USER_EMAIL")))) {
	        	result.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_EMAIL").toString(),"UTF-8"));
	        }
	        String fileView = FileViewMarkupBuilder.newInstance()
	                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
	                .wrapMarkup("p")
	                .isIcon(true)
	                .isSize(true)
	                .build()
	                .toString();
	        result.put("fileView", fileView);
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	} 
        
        return result;
    }
    
    public void cardProc(MngrInstrctrCardVO param) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrCardMapper.cardProc(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    /*   
    public HashMap<String, Object> selectCommonExcel(MngrInstrctrMngrVO vo)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsInstrctrActMapper.selectCommonExcel(vo);

        paramMap.put("rsList",rsTp);
        fileName = "instrctrList";
        templateFile = "instrctrList.xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }*/
    
    public void updateFile(HttpServletRequest request, MngrInstrctrCardVO param) throws Exception {
        //ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        //if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrCardMapper.updateFile(param);
        //}
    }
}
