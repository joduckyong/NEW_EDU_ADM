package egovframework.ncts.mngr.instrctrMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.thymeleaf.spring4.SpringTemplateEngine;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.ems.service.EgovMultiPartEmail;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrActMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrActService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrActVO;

@Service
public class EgovNctsInstrctrActServiceImpl implements EgovNctsInstrctrActService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrActServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrActMapper egovNctsInstrctrActMapper;
    
    @Resource(name = "emailTemplateEngine")
	private SpringTemplateEngine springTemplateEngine;
	
	@Autowired
	private EgovMultiPartEmail egovMultiPartEmail;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrActList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsInstrctrActMapper.selectInstrctrActCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsInstrctrActMapper.selectInstrctrActList(pageVO);
    }
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrActDetail(MngrInstrctrActVO param) throws Exception {
        List<HashMap<String, Object>> result = egovNctsInstrctrActMapper.selectInstrctrActDetail(param);
        
        return result;
    }
    
    public void actProc(MngrInstrctrActVO param) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrActMapper.actProc(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    /*   
    public HashMap<String, Object> selectCommonExcel(MngrInstrctrMngrVO vo)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsInstrctrActMapper.selectCommonExcel(vo);

        paramMap.put("rsList",rsTp);
        fileName = "instrctrList";
        templateFile = "instrctrList.xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }*/
    
    /*public void updateFile(HttpServletRequest request, MngrInstrctrActVO param) throws Exception {
        //ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        //if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrActMapper.updateFile(param);
        //}
    }*/
}
