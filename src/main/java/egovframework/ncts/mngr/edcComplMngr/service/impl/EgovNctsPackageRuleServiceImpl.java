package egovframework.ncts.mngr.edcComplMngr.service.impl;

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
import egovframework.ncts.mngr.edcComplMngr.mapper.EgovNctsMngrEduPackageMapper;
import egovframework.ncts.mngr.edcComplMngr.mapper.EgovNctsPackageRuleMapper;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsPackageRuleService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrPackageRuleVO;

@Service
public class EgovNctsPackageRuleServiceImpl implements EgovNctsPackageRuleService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsPackageRuleServiceImpl.class);
    
    @Autowired
    private EgovNctsPackageRuleMapper egovNctsPackageRuleMapper;
    
    @Autowired
    private EgovNctsMngrEduPackageMapper egovNctsMngrEduPackageMapper;    
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectPackageRuleList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsPackageRuleMapper.selectPackageRuleListTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsPackageRuleMapper.selectPackageRuleList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectPackageRuleDetail(MngrPackageRuleVO param)throws Exception {
        HashMap<String, Object> result = egovNctsPackageRuleMapper.selectPackageRuleDetail(param);
        
        return result;
    }
    
    public void mngrPackageRuleProc(MngrPackageRuleVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());

        if(ProcType.INSERT.equals(procType)) {
        	egovNctsPackageRuleMapper.insertPackageRule(param);
        } else if(ProcType.UPDATE.equals(procType)){
        	egovNctsPackageRuleMapper.updatePackageRule(param);
        } else if(ProcType.DELETE.equals(procType)) {
        	egovNctsPackageRuleMapper.deletePackageRule(param);
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
    }

	@Override
	public List<HashMap<String, Object>> selectMngrEduPackageInfoList(PageInfoVO pageVO) throws Exception{
		pageVO.setRecordCountPerPage(99999);
		pageVO.setsGubun("RULE");
		return egovNctsMngrEduPackageMapper.selectMngrEduPackageInfoList(pageVO);
	}
}
