package egovframework.ncts.mngr.eduReqstMngr.service.impl;

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
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrDtyEduMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;

@Service
public class EgovNctsMngrDtyEduServiceImpl implements EgovNctsMngrDtyEduService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDtyEduServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrDtyEduMapper egovNctsMngrDtyEduMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
//  String iniFilePath = "/penta/scpdb_agent.ini";
  //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
  private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
	
	@Override
	public void mngrDtyEduProcess(MngrDtyEduVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
			
		if (ProcType.INSERT.equals(procType)) {
			egovNctsMngrDtyEduMapper.insertMngrDtyEdu(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			egovNctsMngrDtyEduMapper.updateMngrDtyEdu(param);
		}else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrDtyEduMapper.deleteMngrDtyEdu(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	@Override
	public List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduApplicantVO param) throws Exception {
		
		ScpDbAgent agt = new ScpDbAgent();
		
		List<HashMap<String, Object>> rs = egovNctsMngrDtyEduMapper.selectMngrDtyEduApplicantList(param);
		
		for(HashMap<String, Object> tmp : rs){
			
			try {
	            if (tmp.get("TEL") != null && !"".equals(String.valueOf(tmp.get("TEL")))) {
	            	String tel = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("TEL").toString(),"UTF-8");
	            	tmp.put("TEL", TextUtil.formatTel(tel));
	            }
	
	            if (tmp.get("EMAIL") != null && !"".equals(String.valueOf(tmp.get("EMAIL")))) {
	            	tmp.put("EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("EMAIL").toString(),"UTF-8"));
	            }
	            
	            if (tmp.get("BIRTHDAY") != null && !"".equals(String.valueOf(tmp.get("BIRTHDAY")))) {
	            	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("BIRTHDAY").toString(),"UTF-8");
	            	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	            	tmp.put("BIRTHDAY", formattedDate);
	            }
	            
				String fileView = FileViewMarkupBuilder.newInstance()
						.atchFileId(StringUtils.defaultIfEmpty((String) tmp.get("ATCH_FILE_ID"), ""))
						.wrapMarkup("p")
						.isIcon(true)
						.isSize(true)
						.build()
						.toString();
				tmp.put("fileView", fileView);
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}  
		}
		return rs;
	}

	@Override
	public HashMap<String, Object> selectMngrDtyEduDetail(MngrDtyEduVO vo) throws Exception {
		HashMap<String, Object> rs = egovNctsMngrDtyEduMapper.selectMngrDtyEduDetail(vo);
		rs.put("EDU_CN", ParamUtils.reverseHtmlTag((String)rs.get("EDU_CN")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMngrDtyEduList(PageInfoVO searchVO) throws Exception {
		int cnt = egovNctsMngrDtyEduMapper.selectMngrDtyEduListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return egovNctsMngrDtyEduMapper.selectMngrDtyEduList(searchVO);
	}
	
	@Override
	public List<HashMap<String, Object>> selectDtyEduList()throws Exception {
	    return egovNctsMngrDtyEduMapper.selectDtyEduList();
	}

	@Override
	public HashMap<String, Object> mngrDtyEduApplicantDownload(MngrDtyEduApplicantVO param) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        HashMap<String, Object> re = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        MngrDtyEduVO vo = new MngrDtyEduVO();
        
        vo.setEduSeq(param.getEduSeq());
        vo.setEduDivision(param.getEduDivision());
        List<HashMap<String, Object>> rsTp = egovNctsMngrDtyEduMapper.mngrDtyEduApplicantDownload(param);
        for (HashMap<String, Object> tmp : rsTp) {

        	try {
	            if (tmp.get("USER_HP") != null && !"".equals(String.valueOf(tmp.get("USER_HP")))) {
	            	String userHp = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_HP").toString(),"UTF-8");
	            	tmp.put("USER_HP", TextUtil.formatTel(userHp));
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
        
        
        re = egovNctsMngrDtyEduMapper.selectMngrDtyEduDetail(vo);
        if(!("".equals(re.get("INSTRCTR_NM_S")) || null == re.get("INSTRCTR_NM_S"))) re.put("INSTRCTR_NM_S", "," + re.get("INSTRCTR_NM_S"));
        else re.put("INSTRCTR_NM_S", "");
        paramMap.put("rd", re);
        paramMap.put("rsList",rsTp);
        fileName = param.getExcelFileNm();
        templateFile = param.getExcelPageNm()+".xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
		
		return rs;
	}
	
	@Override
	public void updateDtyInstrctrOthbcYnProcess(MngrDtyEduVO param) throws Exception {
		egovNctsMngrDtyEduMapper.updateDtyInstrctrOthbcYnProcess(param);
		
	}
}
