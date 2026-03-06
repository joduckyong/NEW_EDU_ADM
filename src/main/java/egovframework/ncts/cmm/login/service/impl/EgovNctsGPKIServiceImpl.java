package egovframework.ncts.cmm.login.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.ncts.cmm.login.mapper.EgovNctsGPKIMapper;
import egovframework.ncts.cmm.login.service.EgovNctsGPKIService;

@Service
public class EgovNctsGPKIServiceImpl implements EgovNctsGPKIService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsGPKIServiceImpl.class);
	
	@Autowired
	private EgovNctsGPKIMapper egovNctsGPKIMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	@Override
	public CustomUser selectUserDN(CustomUser userInfo) throws Exception {
		return egovNctsGPKIMapper.selectUserDN(userInfo);
	}

	@Override
	public void insertDn(CustomUser param) throws Exception {
		egovNctsGPKIMapper.insertDn(param);
	}
	
}
