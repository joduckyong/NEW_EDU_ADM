package egovframework.ncts.cmm.sys.ipauth.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.auth.mapper.EgovNctsSysAuthMapper;
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthService;
import egovframework.ncts.cmm.sys.auth.vo.AuthGrpVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthVO;
import egovframework.ncts.cmm.sys.ipauth.mapper.EgovNctsSysipAuthMapper;
import egovframework.ncts.cmm.sys.ipauth.service.EgovNctsSysipAuthService;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

@Service
public class EgovNctsSysipAuthServiceImpl implements EgovNctsSysipAuthService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysipAuthServiceImpl.class);
	
	@Autowired
	private EgovNctsSysipAuthMapper sysipAuthMapper; 
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void authipProcess(ipAuthVO param) throws Exception {
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)){
			sysipAuthMapper.insertipAuth(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			sysipAuthMapper.updateipAuth(param);			
		}/*else if (ProcType.DELETE.equals(procType)) {
			sysipAuthMapper.deleteipAuth(param);
		}*/else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}		
	}

	@Override
	public HashMap<String, Object> selectipDetail(ipAuthVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysipAuthMapper.selectipAuthDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectipAuthList(PageInfoVO searchVO) throws Exception {
		int cnt = sysipAuthMapper.selectipAuthListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return sysipAuthMapper.selectipAuthList(searchVO);
	}
	
	@Override
	public int selectIpChk(ipAuthVO vo) throws Exception {
		return sysipAuthMapper.selectIpChk(vo);
	}

	@Override
	public int selectIpChk2(ipAuthVO vo) throws Exception {
		return sysipAuthMapper.selectIpChk2(vo);
	}

	@Override
	public void ipChkYtoN(ipAuthVO param) throws Exception {
		sysipAuthMapper.ipChkYtoN(param);
	}

	@Override
	public void ipChkNtoY(ipAuthVO param) throws Exception {
		sysipAuthMapper.ipChkNtoY(param);
	}

	@Override
	public String useAble() throws Exception {
		return sysipAuthMapper.useAble();
	}

	@Override
	public void authipDelete(ipAuthVO param) throws Exception {
		sysipAuthMapper.authipDelete(param);
	}

}
