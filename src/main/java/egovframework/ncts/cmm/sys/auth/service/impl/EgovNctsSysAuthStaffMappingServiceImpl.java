package egovframework.ncts.cmm.sys.auth.service.impl;

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
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.auth.mapper.EgovNctsSysAuthStaffMappingMapper;
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthStaffMappingService;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Service
public class EgovNctsSysAuthStaffMappingServiceImpl implements EgovNctsSysAuthStaffMappingService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthStaffMappingServiceImpl.class);
	
	@Autowired
	private EgovNctsSysAuthStaffMappingMapper sysAuthStaffMappingMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	 
//    String iniFilePath = "/penta/scpdb_agent.ini";
    //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
	@Override
	public void authMappingProcess(UserVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			List<UserVO> userList = param.getUserList();
			if(null != userList){
				for(UserVO vo : userList){
					vo.setGroupId(param.getGroupId());
					sysAuthStaffMappingMapper.deleteAuthMapping(vo);
					
					sysAuthStaffMappingMapper.insertAuthMapping(vo);
				}
			}
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
		
	}


	@Override
	public List<HashMap<String, Object>> selectAuthStaffMappingList(PageInfoVO pageVO) throws Exception {

		ScpDbAgent agt = new ScpDbAgent();
	    List<HashMap<String, Object>> list = sysAuthStaffMappingMapper.selectAuthStaffMappingList(pageVO);

	    // 결과값 변환 처리 
	    for (HashMap<String, Object> tmp : list) {
	    	try {
				if (tmp.get("USER_HP") != null && !"".equals(String.valueOf(tmp.get("USER_HP")))) {
					tmp.put("USER_HP", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_HP").toString(),"UTF-8"));
				}
				if (tmp.get("USER_BIRTH") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH")))) {
					tmp.put("USER_BIRTH", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH").toString(),"UTF-8"));
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
	public void insertDeleteAuthRcord(UserVO param) throws Exception {
		sysAuthStaffMappingMapper.deleteAuthMapping(param);
		sysAuthStaffMappingMapper.insertDeleteAuthRcord(param);
	}
	
}
