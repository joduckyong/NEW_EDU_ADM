package egovframework.ncts.mngr.edcComplMngr.service.impl;

import java.util.Arrays;
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
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsLctreRuleService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreRuleVO;
import egovframework.ncts.mngr.edcComplMngr.mapper.EgovNctsLctreRuleMapper;

@Service
public class EgovNctsLctreRuleImpl implements EgovNctsLctreRuleService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsLctreOffImpl.class);
    
    @Autowired
    private EgovNctsLctreRuleMapper egovNctsLctreRuleMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectRuleList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsLctreRuleMapper.selecRuleCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsLctreRuleMapper.selectRuleList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectRuleDetail(MngrLctreRuleVO param)throws Exception {
        HashMap<String, Object> result = egovNctsLctreRuleMapper.selectRuleDetail(param);
        
        return result;
    }
    
    public void mngrProgressLctre(HttpServletRequest request, MngrLctreRuleVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        CustomUser user = SessionUtil.getProperty(request);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());
			param.setLastUpdusrId(user.getUserId());
		}
        
        String[] lectureId = param.getLectureId().replaceAll(" ", "").split("[|]");
        Arrays.sort(lectureId);
        String sum = "";
        for(int i=0; i<lectureId.length; i++) {
        	sum += lectureId[i] + "|";
        }
        param.setLectureId(sum.substring(0, sum.length()-1));
        
        if(ProcType.UPDATE.equals(procType)) {
            egovNctsLctreRuleMapper.ruleUpdateProc(param);
        } else if(ProcType.INSERT.equals(procType)){
            egovNctsLctreRuleMapper.ruleLectureInsertProc(param);
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
    }
    
    public void delRuleLctre(MngrLctreRuleVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
        	egovNctsLctreRuleMapper.delRuleLctre(param);
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
    }
}
