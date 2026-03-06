package egovframework.ncts.cmm.sys.dept.service.impl;

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
import egovframework.ncts.cmm.sys.dept.mapper.EgovNctsSysDeptTeamMapper;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptTeamService;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Service
public class EgovNctsSysDeptTeamServiceImpl implements EgovNctsSysDeptTeamService {
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysDeptTeamServiceImpl.class);
	
	@Autowired 
	private EgovNctsSysDeptTeamMapper sysDeptTeamMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void deptTeamProcess(DeptVO param) throws Exception {

		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			sysDeptTeamMapper.updateDeptTeamOrdPull(param);
			sysDeptTeamMapper.insertDeptTeam(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			sysDeptTeamMapper.updateDeptTeam(param);
			if(param.getUseAt().equals("N")){
				sysDeptTeamMapper.deleteUserAuthMapping(param);
				
				sysDeptTeamMapper.deleteUserDept(param);
			}
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public HashMap<String, Object> selectDeptTeamDetail(DeptVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysDeptTeamMapper.selectDeptTeamDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectDeptTeamList(PageInfoVO searchVO) throws Exception {
		int cnt = sysDeptTeamMapper.selectDeptTeamListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return sysDeptTeamMapper.selectDeptTeamList(searchVO);
	}

	@Override
	public List<HashMap<String, Object>> selectDeptOptionList(DeptVO param) throws Exception {
		return sysDeptTeamMapper.selectDeptOptionList(param);
	}
}
