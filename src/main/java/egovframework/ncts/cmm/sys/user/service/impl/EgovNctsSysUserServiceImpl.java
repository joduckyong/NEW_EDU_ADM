package egovframework.ncts.cmm.sys.user.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ScpDbCode;
import egovframework.com.Sha256Crypto;
import egovframework.com.cmm.EgovMessageSource;
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
	
	@Autowired
	private ScpDbCode scp;
	
	@Override
	public void userProcess(UserVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if(ProcType.INSERT.equals(procType) || ProcType.UPDATE.equals(procType)) {
			param.setUserEmail(scp.b64Str("E", param.getUserEmail()));
			param.setUserHp(scp.b64Str("E", param.getUserHp()));
			
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

	@Override
	public HashMap<String, Object> selectUserDetail(UserVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysUserMapper.selectUserDetail(vo);
		
		resultVO.put("USER_EMAIL", scp.b64Str("D", resultVO.get("USER_EMAIL").toString()));
		resultVO.put("USER_HP", scp.b64Str("D", resultVO.get("USER_HP").toString()));
		
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectUserList(PageInfoVO searchVO) throws Exception {
		int cnt = sysUserMapper.selectUserListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		List<HashMap<String, Object>> rs = sysUserMapper.selectUserList(searchVO);
		for(HashMap<String, Object> tmp : rs){
			if(Sha256Crypto.authenticate(Sha256Crypto.INIT_PWD, (String) tmp.get("USER_PWD"))) tmp.put("INIT_PW_STAT", "Y");
			else  tmp.put("INIT_PW_STAT", "N");
			
			tmp.put("USER_EMAIL", scp.b64Str("D", tmp.get("USER_EMAIL").toString()));
			tmp.put("USER_HP", scp.b64Str("D", tmp.get("USER_HP").toString()));
		}
		return rs;
	}

	@Override
	public void userInitPwd(UserVO param) throws Exception {
		param.setUserPwd(Sha256Crypto.encryption(Sha256Crypto.INIT_PWD));
		sysUserMapper.userInitPwd(param);
	}
	
}
