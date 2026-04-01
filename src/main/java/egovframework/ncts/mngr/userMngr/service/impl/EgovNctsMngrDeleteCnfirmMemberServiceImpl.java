package egovframework.ncts.mngr.userMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.TextUtil;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrDeleteCnfirmMemberMapper;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrDeleteCnfirmMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsMngrDeleteCnfirmMemberServiceImpl implements EgovNctsMngrDeleteCnfirmMemberService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDeleteCnfirmMemberServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrDeleteCnfirmMemberMapper egovNctsMngrDeleteCnfirmMemberMapper;
    
//  String iniFilePath = "/penta/scpdb_agent.ini";
  //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
  private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberList(PageInfoVO pageVO) throws Exception {
    	
    	ScpDbAgent agt = new ScpDbAgent();
    	
    	if(pageVO.getSearchKeyword2() != null && !"".equals(pageVO.getSearchKeyword2())) {
    		String searchKeywork2 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword2().toString());
    		pageVO.setSearchKeyword2(searchKeywork2);
    	}
    	if(pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3())) {
    		String searchKeywork3 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword3().toString().replace("-", ""));
    		pageVO.setSearchKeyword3(searchKeywork3);
    	}
    	
        int cnt = egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        List<HashMap<String, Object>> list = egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberList(pageVO);

        // 결과값 변환 처리
        for (HashMap<String, Object> row : list) {
        	try {
	            if (row.get("USER_EMAIL") != null && !"".equals(String.valueOf(row.get("USER_EMAIL")))) {
	                row.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1", row.get("USER_EMAIL").toString(),"UTF-8"));
	            }
	            if (row.get("USER_HP_NO") != null && !"".equals(String.valueOf(row.get("USER_HP_NO")))) {
	                String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1", row.get("USER_HP_NO").toString(),"UTF-8");
	                row.put("USER_HP_NO", TextUtil.formatTel(userHpNo));            	
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
    public HashMap<String, Object> selectMngrDeleteCnfirmMemberDetail(MngrMemberVO param) throws Exception {
    	
    	ScpDbAgent agt = new ScpDbAgent();
    	
        HashMap<String, Object> result = egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberDetail(param);
        
        try {
	        if (result.get("USER_EMAIL") != null && !"".equals(String.valueOf(result.get("USER_EMAIL")))) {
	        	result.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1", result.get("USER_EMAIL").toString(),"UTF-8"));
	        }
	        
	        if (result.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(result.get("USER_BIRTH_YMD")))) {
	            String userBirthYmd = agt.ScpDecB64(iniFilePath, "KEY1", result.get("USER_BIRTH_YMD").toString(),"UTF-8");
	            String formattedDate = userBirthYmd.substring(0,4) + "." + userBirthYmd.substring(4,6) + "." + userBirthYmd.substring(6,8);        
	            result.put("USER_BIRTH_YMD", formattedDate);
	        }
	        
	        if (result.get("USER_HP_NO") != null && !"".equals(String.valueOf(result.get("USER_HP_NO")))) {
	            String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1", result.get("USER_HP_NO").toString(),"UTF-8");
	            result.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
	        }
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	}   
        
        
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString(); 
        
        result.put("fileView", fileView);
        return result;
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeDetail(MngrMemberVO param) throws Exception {
        return egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberSeDetail(param);
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeVideoDetail(MngrMemberVO param) throws Exception {
    	return egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberSeVideoDetail(param);
    }

	@Override
	public void deleteMngrDeleteCnfirmMember(MngrMemberVO param) throws Exception {
		egovNctsMngrDeleteCnfirmMemberMapper.deleteMngrDeleteCnfirmMember(param);
	}

   
}
