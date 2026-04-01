package egovframework.ncts.cmm.sys.user.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.ScpDbCode;
import egovframework.com.Sha256Crypto;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.user.mapper.EgovNctsSysUserMapper;
import egovframework.ncts.cmm.sys.user.service.EgovNctsSysUserService;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Service
public class EgovNctsSysUserServiceImpl implements EgovNctsSysUserService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysUserServiceImpl.class);
	
	@Autowired
	private EgovNctsSysUserMapper sysUserMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");	
    
//	@Autowired
//	private ScpDbCode scp;
	
	@Override
	public void userProcess(UserVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		ScpDbAgent agt = new ScpDbAgent();
		
		try {
			if(ProcType.INSERT.equals(procType) || ProcType.UPDATE.equals(procType)) {
				
		    	if (param.getUserEmail() != null && !"".equals(param.getUserEmail()) ) {
			    	String userEmail = agt.ScpEncB64(iniFilePath, "KEY1", param.getUserEmail());
			    	param.setUserEmail(userEmail);
		    	}  
		    	if (param.getUserHp() != null && !"".equals(param.getUserHp()) ) {
		    		String userHp = agt.ScpEncB64(iniFilePath, "KEY1", param.getUserHp());
		    		param.setUserHp(userHp);
		    	}  
		    	if (param.getUserBirth() != null && !"".equals(param.getUserBirth()) ) {
		    		String userBirth = agt.ScpEncB64(iniFilePath, "KEY1", param.getUserBirth());
		    		param.setUserBirth(userBirth);
		    	}  
		    	
	//			param.setUserEmail(scp.b64Str("E", param.getUserEmail()));
	//			param.setUserHp(scp.b64Str("E", param.getUserHp()));
				
				if (ProcType.INSERT.equals(procType)) {
					param.setUserPwd(Sha256Crypto.encryption(Sha256Crypto.INIT_PWD));
					sysUserMapper.insertUser(param);
					sysUserMapper.insertUserRole(param);
					
				}else if (ProcType.UPDATE.equals(procType)) {
					sysUserMapper.updateUser(param);
					sysUserMapper.updateUserRole(param);
				}
				
				HashMap<String, Object> userAuth = sysUserMapper.selectAuthUserDetail(param);
				if(null == userAuth) sysUserMapper.insertAuthUserMapping(param);
				else if(null == userAuth.get("AUTH_GRP_NO")) sysUserMapper.updateAuthUserMapping(param);
			}
			
			else if (ProcType.DELETE.equals(procType)) {
				sysUserMapper.deleteUser(param);
				sysUserMapper.deleteUserAuthMapping(param);
			}else{
				throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
			}
			
	   	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	} 		
	}

	@Override
	public HashMap<String, Object> selectUserDetail(UserVO vo) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		HashMap<String, Object> resultVO = sysUserMapper.selectUserDetail(vo);
		
		try {
			
			if (resultVO.get("USER_EMAIL") != null && !"".equals(resultVO.get("USER_EMAIL"))) {
				resultVO.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",resultVO.get("USER_EMAIL").toString(),"UTF-8"));
			}
			if (resultVO.get("USER_HP") != null && !"".equals(resultVO.get("USER_HP"))) {
				resultVO.put("USER_HP", agt.ScpDecB64(iniFilePath, "KEY1",resultVO.get("USER_HP").toString(),"UTF-8"));
			}

			if (resultVO.get("USER_BIRTH") != null && !"".equals(String.valueOf(resultVO.get("USER_BIRTH")))) {
				String birthday = agt.ScpDecB64(iniFilePath, "KEY1",resultVO.get("USER_BIRTH").toString(),"UTF-8");
				
				if(birthday != null && !"null".equals(birthday)) {
					if(birthday.length() > 8) {
						resultVO.put("USER_BIRTH", birthday.replace("-", ".").substring(0, 10));
					}else {
						String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
						resultVO.put("USER_BIRTH", formattedDate);
					}
				}else{
					resultVO.put("USER_BIRTH", "");
				}

			}	
    	}
		catch (ScpDbAgentException e) {
			LOGGER.info(e.getMessage());
		}
		catch (Exception e) {
			LOGGER.info(e.getMessage());
		} 		
		
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectUserList(PageInfoVO searchVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		int cnt = sysUserMapper.selectUserListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		List<HashMap<String, Object>> rs = sysUserMapper.selectUserList(searchVO);
		for(HashMap<String, Object> tmp : rs){
			if(Sha256Crypto.authenticate(Sha256Crypto.INIT_PWD, (String) tmp.get("USER_PWD"))) tmp.put("INIT_PW_STAT", "Y");
			else  tmp.put("INIT_PW_STAT", "N");
			
			try {
				if (tmp.get("USER_EMAIL") != null && !"".equals(tmp.get("USER_EMAIL"))) {
					tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
				}
				if (tmp.get("USER_HP") != null && !"".equals(tmp.get("USER_HP"))) {
					tmp.put("USER_HP", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_HP").toString(),"UTF-8"));
				}
				if (tmp.get("USER_BIRTH") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH")))) {
					String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH").toString(),"UTF-8");
					
					if(birthday != null && !"null".equals(birthday)) {
						if(birthday.length() > 8) {
							tmp.put("USER_BIRTH", birthday.replace("-", ".").substring(0, 10));
						}else {
							String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
							tmp.put("USER_BIRTH", formattedDate);
						}
					}else{
						tmp.put("USER_BIRTH", "");
					}

				}					
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
	public void userInitPwd(UserVO param) throws Exception {
		param.setUserPwd(Sha256Crypto.encryption(Sha256Crypto.INIT_PWD));
		sysUserMapper.userInitPwd(param);
	}
	
}
