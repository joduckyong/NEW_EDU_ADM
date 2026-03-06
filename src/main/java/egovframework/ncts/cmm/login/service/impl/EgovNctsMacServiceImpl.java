package egovframework.ncts.cmm.login.service.impl;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ncts.cmm.login.mapper.EgovNctsMacMapper;
import egovframework.ncts.cmm.login.service.EgovNctsMacService;

@Service
public class EgovNctsMacServiceImpl implements EgovNctsMacService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMacServiceImpl.class);
	
	@Autowired
	private EgovNctsMacMapper egovNctsMacMapper;

	@Override
	public String selectMacServerAt() throws Exception {
		return egovNctsMacMapper.selectMacServerAt();
	}

	@Override
	public void updateMacServerAt(String macServerAt) throws Exception {
		egovNctsMacMapper.updateMacServerAt(macServerAt);
	}

	@Override
	public String selectMacServerPortAt(HashMap<String, Object> param) throws Exception {
		return egovNctsMacMapper.selectMacServerPortAt(param);
	}
	
	@Override
	public void updateMacServerPortAt(HashMap<String, Object> param) throws Exception {
		egovNctsMacMapper.updateMacServerPortAt(param);
	}



}
