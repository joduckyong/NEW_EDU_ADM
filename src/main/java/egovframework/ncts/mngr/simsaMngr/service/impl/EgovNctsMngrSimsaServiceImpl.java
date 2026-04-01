package egovframework.ncts.mngr.simsaMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.ParamUtils;
import egovframework.com.TextUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.shareMngr.mapper.EgovNctsMngrShareMapper;
import egovframework.ncts.mngr.shareMngr.service.impl.EgovNctsMngrShareServiceImpl;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;
import egovframework.ncts.mngr.simsaMngr.mapper.EgovNctsMngrSimsaMapper;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaService;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

@Service("simsaService")
public class EgovNctsMngrSimsaServiceImpl implements EgovNctsMngrSimsaService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrShareServiceImpl.class);

	@Autowired
	private EgovNctsMngrSimsaMapper egovNctsMngrSimsaMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

//    String iniFilePath = "/penta/scpdb_agent.ini";
    //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
	@Override
	public List<HashMap<String, Object>> selectSimsaList(PageInfoVO pageVO) throws Exception {

		int cnt = egovNctsMngrSimsaMapper.selectSimsaTotCnt(pageVO);

		pageVO.setTotalRecordCount(cnt);

		return egovNctsMngrSimsaMapper.selectSimsaList(pageVO);
	}

	@Override
	public HashMap<String, Object> selectSimsaListDetail(MngrSimsaManageVO param) throws Exception {

		HashMap<String, Object> rs = egovNctsMngrSimsaMapper.selectSimsaListDetail(param);

		return rs;
	}

	@Override
	public int selectSimsaActiveCnt(MngrSimsaManageVO param) throws Exception {

		int activeCnt = egovNctsMngrSimsaMapper.selectSimsaActiveCnt(param);

		return activeCnt;
	}

	@Override
	public void simsaProcess(MngrSimsaManageVO param) throws Exception {

		ProcType procType = ProcType.findByProcType(param.getProcType());

		if (ProcType.INSERT.equals(procType)) { 

			egovNctsMngrSimsaMapper.insertSimsaList(param);
			

		} else if (ProcType.UPDATE.equals(procType)) { 

			egovNctsMngrSimsaMapper.updateSimsaList(param);
		

		}  else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype")); 
		}

	}

	@Override
	public void closeUpdateYN() throws Exception {
		egovNctsMngrSimsaMapper.closeUpdateYN();

	}

	

	@Override
	public int deleteRequire1(MngrSimsaManageVO param) throws Exception {
		
		int deleteRe1 = egovNctsMngrSimsaMapper.deleteRequire1(param);
		
		return deleteRe1;
	}


	
	@Override
	public void deleteSimsaList(MngrSimsaManageVO param) throws Exception {
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		 if (ProcType.DELETE.equals(procType)) {

			egovNctsMngrSimsaMapper.deleteSimsaList(param);

		}
		
	}


	@Override
	public HashMap<String, Object> selectStartDePast(MngrSimsaManageVO param) throws Exception {
		
		HashMap<String, Object> startDeChk = egovNctsMngrSimsaMapper.selectStartDePast(param);
		
		return startDeChk;
	}
	
	@Override
	public List<HashMap<String, Object>> selectSimsaNumList() throws Exception {
		return egovNctsMngrSimsaMapper.selectSimsaNumList();
	}

	@Override
	public List<HashMap<String, Object>> selectSimsaAppListMain(MngrSimsaApplicantVO VO) throws Exception {
	 ScpDbAgent agt = new ScpDbAgent();
     List<HashMap<String, Object>> list = egovNctsMngrSimsaMapper.selectSimsaAppListMain(VO);
		
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
	public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO) throws Exception {
		
//			egovNctsMngrSimsaMapper.selectCommonExcel(pageVO);
			ScpDbAgent agt = new ScpDbAgent();
			
	        HashMap<String, Object> rs = new HashMap<>();
	        HashMap<String, Object> paramMap = new HashMap<>();
	        String fileName = "";
	        String templateFile = "";
	        
	        List<HashMap<String, Object>> rsTp = egovNctsMngrSimsaMapper.selectCommonExcel(pageVO);
	        for (HashMap<String, Object> tmp : rsTp) {
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
	        paramMap.put("rsList",rsTp);
	        fileName = pageVO.getExcelFileNm();
	        templateFile = pageVO.getExcelPageNm();
	        
	        rs.put("paramMap", paramMap);
	        rs.put("fileName", fileName);
	        rs.put("templateFile", templateFile);
	        
	        return rs;
	}

	@Override
	public HashMap<String, Object> selectAll(MngrSimsaApplicantVO VO) throws Exception {
		
		HashMap<String, Object> allList = egovNctsMngrSimsaMapper.selectAll(VO);
		
		return allList;
	}

	
	
	
	
	
}
