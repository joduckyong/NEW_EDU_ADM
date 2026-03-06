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
import egovframework.ncts.cmm.sys.dept.mapper.EgovNctsSysDeptMapper;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Service
public class EgovNctsSysDeptServiceImpl implements EgovNctsSysDeptService {
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysDeptServiceImpl.class);
	
	@Autowired 
	private EgovNctsSysDeptMapper sysDeptMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void deptProcess(DeptVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			sysDeptMapper.insertDept(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			sysDeptMapper.updateDept(param);
			if(param.getUseAt().equals("N")){
				sysDeptMapper.deleteDept(param);
				sysDeptMapper.deleteUserAuthMapping(param);
				
				sysDeptMapper.deleteUserDept(param);
			}
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public HashMap<String, Object> selectDeptDetail(DeptVO vo) throws Exception {
		HashMap<String, Object> resultVO = sysDeptMapper.selectDeptDetail(vo);
		return resultVO;
	}

	@Override
	public List<HashMap<String, Object>> selectDeptList(PageInfoVO searchVO) throws Exception {
		int cnt = sysDeptMapper.selectDeptListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return sysDeptMapper.selectDeptList(searchVO);
	}

	@Override
	public List<HashMap<String, Object>> selectCenterList() throws Exception {
		return sysDeptMapper.selectCenterList();
	}
}
