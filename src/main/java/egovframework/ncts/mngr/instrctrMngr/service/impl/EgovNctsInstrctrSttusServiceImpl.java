package egovframework.ncts.mngr.instrctrMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrSttusMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrSttusService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrSttusVO;

@Service
public class EgovNctsInstrctrSttusServiceImpl implements EgovNctsInstrctrSttusService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrSttusServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrSttusMapper egovNctsInstrctrSttusMapper;
    
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
//    String iniFilePath = "/penta/scpdb_agent.ini";
    //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrSttusList(PageInfoVO pageVO) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
        int cnt = egovNctsInstrctrSttusMapper.selectInstrctrSttusTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        List<HashMap<String, Object>> list = egovNctsInstrctrSttusMapper.selectInstrctrSttusList(pageVO);

        // 결과값 변환 처리
        for (HashMap<String, Object> tmp : list) {
        	try {
	            if (tmp.get("PHONE_NO") != null && !"".equals(String.valueOf(tmp.get("PHONE_NO")))) {
	            	tmp.put("PHONE_NO", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("PHONE_NO").toString(),"UTF-8"));
	            }
	
	            if (tmp.get("HP_NO") != null && !"".equals(String.valueOf(tmp.get("HP_NO")))) {
	            	tmp.put("HP_NO", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("HP_NO").toString(),"UTF-8"));
	            }
	            
	            if (tmp.get("EMAIL") != null && !"".equals(String.valueOf(tmp.get("EMAIL")))) {
	            	tmp.put("EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("EMAIL").toString(),"UTF-8"));
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
    public HashMap<String, Object> selectInstrctrSttusDetail(MngrInstrctrSttusVO param) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
        HashMap<String, Object> result = egovNctsInstrctrSttusMapper.selectInstrctrSttusDetail(param);
        try {
	        if (result.get("PHONE_NO") != null && !"".equals(String.valueOf(result.get("PHONE_NO")))) {
	        	result.put("PHONE_NO", agt.ScpDecB64(iniFilePath, "KEY1",result.get("PHONE_NO").toString(),"UTF-8"));
	        }
	
	        if (result.get("HP_NO") != null && !"".equals(String.valueOf(result.get("HP_NO")))) {
	        	result.put("HP_NO", agt.ScpDecB64(iniFilePath, "KEY1",result.get("HP_NO").toString(),"UTF-8"));
	        }
	        
	        if (result.get("EMAIL") != null && !"".equals(String.valueOf(result.get("EMAIL")))) {
	        	result.put("EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",result.get("EMAIL").toString(),"UTF-8"));
	        }        
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	}   
        return result;
    }

	@Override
	public HashMap<String, Object> selectInstrctrSttusExcelDownload(PageInfoVO pageVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsInstrctrSttusMapper.selectInstrctrSttusExcelDownload(pageVO);
        // 결과값 변환 처리
        for (HashMap<String, Object> tmp : rsTp) {
        	try {
	            if (tmp.get("PHONE_NO") != null && !"".equals(String.valueOf(tmp.get("PHONE_NO")))) {
	            	tmp.put("PHONE_NO", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("PHONE_NO").toString(),"UTF-8"));
	            }
	
	            if (tmp.get("HP_NO") != null && !"".equals(String.valueOf(tmp.get("HP_NO")))) {
	            	tmp.put("HP_NO", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("HP_NO").toString(),"UTF-8"));
	            }
	            
	            if (tmp.get("EMAIL") != null && !"".equals(String.valueOf(tmp.get("EMAIL")))) {
	            	tmp.put("EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("EMAIL").toString(),"UTF-8"));
	            }
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	} 
        }
        
        paramMap.put("rslist",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectInstrctrDetailList(PageInfoVO pageVO) throws Exception {
		return egovNctsInstrctrSttusMapper.selectInstrctrDetailList(pageVO);
	}
    
}
