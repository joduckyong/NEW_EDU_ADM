package egovframework.ncts.mngr.eduReqstMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEduIrregularMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduIrregularService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;

@Service
public class EgovNctsMngrEduIrregularServiceImpl implements EgovNctsMngrEduIrregularService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduIrregularServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrEduIrregularMapper egovNctsMngrEduIrregularMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public List<HashMap<String, Object>> selectNfdrmPlanList(PageInfoVO pageVO)throws Exception{
		int cnt = egovNctsMngrEduIrregularMapper.selecNfdrmPlanCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
	    return egovNctsMngrEduIrregularMapper.selectNfdrmPlanList(pageVO);
	}
	
	@Override
	public HashMap<String, Object> selectNfdrmPlanDetail(MngrEduVO param)throws Exception{
	    
	    return egovNctsMngrEduIrregularMapper.selectNfdrmPlanDetail(param);
	}
	
	@Override
	public void updateNfdrmPlan(HttpServletRequest request, MngrEduVO param)throws Exception{
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		CustomUser customUser = SessionUtil.getProperty(request);
	    if(null != customUser) param.setUserId(customUser.getUserId());
        
		if (ProcType.INSERT.equals(procType)) {
			egovNctsMngrEduIrregularMapper.insertNfdrmPlan(param);
		} else if (ProcType.UPDATE.equals(procType)) {
			egovNctsMngrEduIrregularMapper.updateNfdrmPlan(param);
		} else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduIrregularMapper.deleteNfdrmPlan(param);
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	@Override
	public List<HashMap<String, Object>> selectNfdrmPlanYearList(PageInfoVO pageVO)throws Exception{
		return egovNctsMngrEduIrregularMapper.nfdrmPlanExcelDownload(pageVO);
	}
	
	@Override
	public HashMap<String, Object> nfdrmPlanExcelDownload(PageInfoVO pageVO) throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrEduIrregularMapper.nfdrmPlanExcelDownload(pageVO);

        paramMap.put("rsList",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
		
		return rs;
	}
}
