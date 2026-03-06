package egovframework.ncts.cmm.sys.center.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.Sha256Crypto;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.center.mapper.EgovNctsSysCenterMapper;
import egovframework.ncts.cmm.sys.center.service.EgovNctsSysCenterService;
import egovframework.ncts.cmm.sys.center.vo.DeptVO;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Service
public class EgovNctsSysCenterServiceImpl implements EgovNctsSysCenterService {
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysCenterServiceImpl.class);
	 
	@Autowired
	private EgovNctsSysCenterMapper sysCenterMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void centerProcess(DeptVO param) throws Exception {

		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			sysCenterMapper.insertCenter(param);
			System.out.println(param.getDeptCd());
			sysCenterMapper.updateCenterMapping(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			sysCenterMapper.updateCenter(param);
			/*sysCenterMapper.updateCenterMapping(param);*/
		}else if(ProcType.DELETE.equals(procType)) {
			sysCenterMapper.deleteCenter(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

 
	@Override
	public HashMap<String, Object> selectCenterDetail(DeptVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysCenterMapper.selectCenterDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectCenterList(PageInfoVO searchVO) throws Exception {
		int cnt = sysCenterMapper.selectCenterListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return sysCenterMapper.selectCenterList(searchVO);
	}


	

	@Override
	public void userProcess(UserVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			param.setUserPwd(Sha256Crypto.encryption(Sha256Crypto.INIT_PWD));
			sysCenterMapper.insertUser(param);
			sysCenterMapper.insertUserRole(param);
			sysCenterMapper.insertAuthUserMapping(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			sysCenterMapper.updateUser(param);
			//sysCenterMapper.updateUserRole(param);
			sysCenterMapper.updateAuthUserMapping(param);
		}else if (ProcType.DELETE.equals(procType)) {
			sysCenterMapper.deleteUser(param);
			sysCenterMapper.deleteUserAuthMapping(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public HashMap<String, Object> selectUserDetail(UserVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysCenterMapper.selectUserDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectUserList(PageInfoVO searchVO) throws Exception {
		int cnt = sysCenterMapper.selectUserListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		List<HashMap<String, Object>> rs = sysCenterMapper.selectUserList(searchVO);
		for(HashMap<String, Object> tmp : rs){
			if(Sha256Crypto.authenticate(Sha256Crypto.INIT_PWD, (String) tmp.get("USER_PWD"))) tmp.put("INIT_PW_STAT", "Y");
			else  tmp.put("INIT_PW_STAT", "N");
		}
		return rs;
	}

	@Override
	public void userInitPwd(UserVO param) throws Exception {
		param.setUserPwd(Sha256Crypto.encryption(Sha256Crypto.INIT_PWD));
		sysCenterMapper.userInitPwd(param);
	}


	@Override
	public List<HashMap<String, Object>> selectAuthList() throws Exception {
		return sysCenterMapper.selectAuthList();
	}


	@Override
	public HashMap<String, Object> selectUserIdDupChk(UserVO param) throws Exception {
		HashMap<String, Object> rs = sysCenterMapper.selectUserIdDupChk(param);
		return rs;
	}


}
