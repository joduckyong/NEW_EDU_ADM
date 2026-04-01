package egovframework.ncts.cmm.login.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.UserSessionVO;
import egovframework.ncts.cmm.login.mapper.EgovNctsLoginMapper;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;

@Service
public class EgovNctsLoginServiceImpl implements EgovNctsLoginService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsLoginServiceImpl.class);
	
	@Autowired
	private EgovNctsLoginMapper egovNctsLoginMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	@Override
	public void updateLockAt(String userId) throws Exception {
		egovNctsLoginMapper.updateLockAt(userId);
	}

	@Override
	public void updateFailrCnt(CustomUser user) throws Exception {
		egovNctsLoginMapper.updateFailrCnt(user);
	}
	
	@Override
	public void insertUserSession(UserSessionVO param) throws Exception {
		egovNctsLoginMapper.insertUserSession(param);
	}
	
	@Override
	public void deleteUserSession(String userId) throws Exception {
		egovNctsLoginMapper.deleteUserSession(userId);
	}
	
	@Override
	public List<UserSessionVO> selectActiveSessions(String userId) throws Exception {
		return egovNctsLoginMapper.selectActiveSessions(userId);
	}
	
	@Override
	public void insertVisit(CustomUser user) throws Exception {
		egovNctsLoginMapper.insertVisit(user);
	}	
}
