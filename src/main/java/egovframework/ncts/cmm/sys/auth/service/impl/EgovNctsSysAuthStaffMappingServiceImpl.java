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
		return sysAuthStaffMappingMapper.selectAuthStaffMappingList(pageVO);
	}
	
	@Override
	public void insertDeleteAuthRcord(UserVO param) throws Exception {
		sysAuthStaffMappingMapper.deleteAuthMapping(param);
		sysAuthStaffMappingMapper.insertDeleteAuthRcord(param);
	}
	
}
