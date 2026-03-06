package egovframework.ncts.cmm.sys.auth.service.impl;

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

@Service
public class EgovNctsSysAuthServiceImpl implements EgovNctsSysAuthService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthServiceImpl.class);
	
	@Autowired
	private EgovNctsSysAuthMapper sysAuthMapper; 
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void authProcess(AuthGrpVO param) throws Exception {
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			sysAuthMapper.insertAuthGrp(param);
			List<AuthVO> authList = param.getAuthList();
			if(null != authList){
				for(AuthVO vo : authList){
					String menuCd = vo.getMenuCd();
					if(menuCd != null){
						vo.setAuthGrpNo(param.getAuthGrpNo());
						sysAuthMapper.insertAuth(vo);
					}
				}
			}
		}else if (ProcType.UPDATE.equals(procType)) {
			sysAuthMapper.deleteAuth(param);
			
			sysAuthMapper.updateAuthGrp(param);
			List<AuthVO> authList = param.getAuthList();
			if(null != authList){
				for(AuthVO vo : authList){
					String menuCd = vo.getMenuCd();
					if(menuCd != null){
						vo.setAuthGrpNo(param.getAuthGrpNo());
						sysAuthMapper.insertAuth(vo);
					}
				}
			}
		}else if (ProcType.DELETE.equals(procType)) {
			if(!param.getMappingCnt().equals("0")) throw new ErrorExcetion(egovMessageSource.getMessage("errors.auth.delete01"));
			
			sysAuthMapper.deleteAuthDetail(param);
			sysAuthMapper.deleteAuthGrp(param);

			sysAuthMapper.deleteDeptAuth(param);
			sysAuthMapper.deleteAuthMapping(param);
			
			
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
		
	}

	@Override
	public HashMap<String, Object> selectDetail(AuthGrpVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysAuthMapper.selectDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectAuthList(PageInfoVO searchVO) throws Exception {
		int cnt = sysAuthMapper.selectAuthListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return sysAuthMapper.selectAuthList(searchVO);
	}

	@Override
	public List<HashMap<String, Object>> selectMenuAuthList(AuthGrpVO vo) throws Exception {
		List<HashMap<String, Object>> resultVO = sysAuthMapper.selectMenuAuthList(vo);
		return resultVO;
	}
}
