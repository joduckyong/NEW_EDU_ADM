package egovframework.com.service.impl;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.mapper.CommonIpChkMapper;
import egovframework.com.service.CommonIpChkService;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;


@Service
public class CommonIpChkServiceImpl implements CommonIpChkService {
	private static final Logger log = LoggerFactory.getLogger(CommonIpChkServiceImpl.class);
	
	@Autowired
	private CommonIpChkMapper commonIpChkMapper;

	@Override
	public int selectIpChk(ipAuthVO vo) throws Exception {
		return commonIpChkMapper.selectIpChk(vo);
	}

	@Override
	public int selectIpChk2(ipAuthVO vo) throws Exception {
		return commonIpChkMapper.selectIpChk2(vo);
	}

	
}
