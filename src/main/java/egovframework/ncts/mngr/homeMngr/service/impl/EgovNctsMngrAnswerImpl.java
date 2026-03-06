package egovframework.ncts.mngr.homeMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrAnswerService;
import egovframework.ncts.mngr.homeMngr.vo.MngrAnswerVO;
import egovframework.ncts.mngr.homeMngr.mapper.EgovNctsMngrAnswerMapper;


@Service
public class EgovNctsMngrAnswerImpl implements EgovNctsMngrAnswerService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrAnswerImpl.class);
    
    @Autowired
    private EgovNctsMngrAnswerMapper egovNctsMngrAnswerMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectMngrAnwerList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrAnswerMapper.selectAnswerCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrAnswerMapper.selectMngrAnserList(pageVO);
    }
   
    @Override
    public HashMap<String, Object> selectAnswerDetail(MngrAnswerVO param)throws Exception{
        HashMap<String, Object> result = egovNctsMngrAnswerMapper.selectAnswerDetail(param);
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString(); 
        
        String originCont = StringEscapeUtils.unescapeHtml3((String) result.get("CONTENTS"));
        
        result.put("CONTENTS", originCont);
        result.put("fileView", fileView);
        
        return result;
    }
     
    public void delAnswer(MngrAnswerVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrAnswerMapper.delAnswer(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressAnswer(HttpServletRequest request, MngrAnswerVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        if(ProcType.UPDATE.equals(procType)) {
            param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
            egovNctsMngrAnswerMapper.answerUpdateProc(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrAnswerMapper.selectCommonExcel(pageVO);
        
        for(int i=0; i<rsTp.size(); i++){
            rsTp.get(i).put("CONTENTS", ParamUtils.removeHtmlTag((String) rsTp.get(i).get("CONTENTS")));
        }
        
        paramMap.put("rsList",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }
}
