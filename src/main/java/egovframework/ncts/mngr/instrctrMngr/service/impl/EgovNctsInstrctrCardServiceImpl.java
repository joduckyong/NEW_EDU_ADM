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

import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.ems.service.EgovMultiPartEmail;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrActMapper;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrCardMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrCardService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrActVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrCardVO;

@Service
public class EgovNctsInstrctrCardServiceImpl implements EgovNctsInstrctrCardService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrActServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrCardMapper egovNctsInstrctrCardMapper;
    
    @Resource(name = "emailTemplateEngine")
	private SpringTemplateEngine springTemplateEngine;
	
	@Autowired
	private EgovMultiPartEmail egovMultiPartEmail;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrCardList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsInstrctrCardMapper.selectInstrctrCardCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsInstrctrCardMapper.selectInstrctrCardList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectInstrctrCardDetail(MngrInstrctrCardVO param) throws Exception {
        HashMap<String, Object> result = egovNctsInstrctrCardMapper.selectInstrctrCardDetail(param);
        
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString();
        result.put("fileView", fileView);
        
        return result;
    }
    
    public void cardProc(MngrInstrctrCardVO param) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrCardMapper.cardProc(param);
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
    
    public void updateFile(HttpServletRequest request, MngrInstrctrCardVO param) throws Exception {
        //ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        //if(ProcType.UPDATE.equals(procType)) {
            egovNctsInstrctrCardMapper.updateFile(param);
        //}
    }
}
