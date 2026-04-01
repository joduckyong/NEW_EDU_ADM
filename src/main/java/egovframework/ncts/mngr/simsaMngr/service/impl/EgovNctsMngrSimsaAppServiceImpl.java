package egovframework.ncts.mngr.simsaMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import com.ibm.icu.util.BytesTrie.Entry;
import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.TextUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.shareMngr.service.impl.EgovNctsMngrShareServiceImpl;
import egovframework.ncts.mngr.simsaMngr.mapper.EgovNctsMngrSimsaAppMapper;
import egovframework.ncts.mngr.simsaMngr.mapper.EgovNctsMngrSimsaMapper;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaAppService;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EgovNctsMngrSimsaAppServiceImpl implements EgovNctsMngrSimsaAppService{

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrSimsaAppServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrSimsaAppMapper egovNctsMngrSimsaAppMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

//    String iniFilePath = "/penta/scpdb_agent.ini";
    //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
	@Override
	public List<HashMap<String, Object>> selectSimsaAppList(MngrSimsaApplicantVO VO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		List<HashMap<String, Object>> list = egovNctsMngrSimsaAppMapper.selectSimsaAppList(VO);
		
		for(int i=0; i < list.size(); i++) {
			HashMap<String, Object> result = list.get(i);
			
				try {
					
		            if (result.get("USER_HP_NO") != null && !"".equals(String.valueOf(result.get("USER_HP_NO")))) {
		            	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_HP_NO").toString(),"UTF-8");
		            	result.put("USER_HP_NO", userHpNo);
		            }			
		            if (result.get("USER_EMAIL") != null && !"".equals(String.valueOf(result.get("USER_EMAIL")))) {
		            	String userEmail = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_EMAIL").toString(),"UTF-8");
		            	result.put("USER_EMAIL", userEmail);
		            }			
		            
			        String fileView = FileViewMarkupBuilder.newInstance()
			                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
			                .wrapMarkup("p")
			                .isIcon(true)
			                .isSize(true)
			                .build()
			                .toString(); 
			        list.get(i).put("fileView", fileView);
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
	public void updateSimsaAppList(MngrSimsaApplicantVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			List<MngrSimsaApplicantVO> appList = param.getAppList();
			if(null != appList){
				for(MngrSimsaApplicantVO vo : appList){
					egovNctsMngrSimsaAppMapper.updateSimsaAppList(vo);
				}
            }			
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public HashMap<String, Object> selectSimsaAppExcelDownload(MngrSimsaApplicantVO param) throws Exception {

		ScpDbAgent agt = new ScpDbAgent();

        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrSimsaAppMapper.selectSimsaAppExcelDownload(param);
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
        fileName = param.getExcelFileNm();
        templateFile = param.getExcelPageNm();
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }

	

}
