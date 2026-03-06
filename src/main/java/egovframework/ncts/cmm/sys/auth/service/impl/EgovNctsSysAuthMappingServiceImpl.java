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
import egovframework.ncts.cmm.sys.auth.mapper.EgovNctsSysAuthMappingMapper;
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthMappingService;
import egovframework.ncts.cmm.sys.auth.vo.AuthMappingVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthVO;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Service
public class EgovNctsSysAuthMappingServiceImpl implements EgovNctsSysAuthMappingService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthMappingServiceImpl.class);
	
	@Autowired
	private EgovNctsSysAuthMappingMapper sysAuthMappingMapper;
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	@Override
	public void authMappingProcess(DeptVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			List<DeptVO> deptList = param.getDeptList();
			String deptDepth="";
			if(null != deptList){
				for(DeptVO vo : deptList){
					vo.setGroupId(param.getGroupId());
					deptDepth=vo.getDeptDepth();
					sysAuthMappingMapper.updateAuthMapping(vo);
					
					if(deptDepth.equals("1") || deptDepth.equals("2")){
						vo.setType("02");
						sysAuthMappingMapper.updateAuthMapping(vo);
					}
					sysAuthMappingMapper.updateUserAuthMapping(vo);
				}
			}
		}else if (ProcType.DELETE.equals(procType)) {
			sysAuthMappingMapper.deleteDeptMapping(param);
			sysAuthMappingMapper.deleteDeptGroupId(param);

			sysAuthMappingMapper.deleteUserAuthMapping(param);
			
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
		
	}


	@Override
	public HashMap<String, Object> selectAuthMapping(AuthMappingVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysAuthMappingMapper.selectAuthMapping(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectAuthDeptMappingList(PageInfoVO pageVO) throws Exception {
		return sysAuthMappingMapper.selectAuthDeptMappingList(pageVO);
	}
	
	@Override
	public List<HashMap<String, Object>> selectAuthGroupList(PageInfoVO pageVO) throws Exception {
		return sysAuthMappingMapper.selectAuthGroupList(pageVO);
	}
	
	@Override
	public List<HashMap<String, Object>> selectAuthDetail(AuthVO vo) throws Exception {
		return sysAuthMappingMapper.selectAuthDetail(vo);
	}


	@Override
	public List<HashMap<String, Object>> selectAuthDetail2(AuthVO vo) throws Exception {
		return sysAuthMappingMapper.selectAuthDetail2(vo);
	}

	
}
