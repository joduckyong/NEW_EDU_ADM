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
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrOneOnOneService;
import egovframework.ncts.mngr.homeMngr.vo.MngrOneOnOneVO;
import egovframework.ncts.mngr.homeMngr.mapper.EgovNctsMngrOneOnOneMapper;

@Service
public class EgovNctsMngrOneOnOneImpl implements EgovNctsMngrOneOnOneService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsManageImpl.class);
    
    @Autowired
    private EgovNctsMngrOneOnOneMapper egovNctsMngrOneOnOneMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectOneOnOneList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrOneOnOneMapper.selectOneOnOneCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        List<HashMap<String, Object>> rslist = egovNctsMngrOneOnOneMapper.selectOneOnOneList(pageVO);
        int idx = 0;
        for(HashMap<String, Object> map : rslist) {
        	map.put("ANSWER_CONTENT", ParamUtils.reverseHtmlTag(StringUtils.defaultIfEmpty((String)rslist.get(idx).get("ANSWER_CONTENT"),"")));
        	idx++;
        }
        return egovNctsMngrOneOnOneMapper.selectOneOnOneList(pageVO);
    }
   
    @Override
    public HashMap<String, Object> selectOneOnOneDetail(MngrOneOnOneVO param)throws Exception{
        HashMap<String, Object> result = egovNctsMngrOneOnOneMapper.selectOneOnOneDetail(param);
        result.put("ANSWER_CONTENT", ParamUtils.reverseHtmlTag(StringUtils.defaultIfEmpty((String)result.get("ANSWER_CONTENT"),"")));
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
    
    public void mngrOneOnOneAnswer(HttpServletRequest request, MngrOneOnOneVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setFrstRegisterId(user.getUserId());
        	param.setLastUpdusrId(user.getUserId());
        }
        param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
        
        if(ProcType.INSERT.equals(procType)){
            egovNctsMngrOneOnOneMapper.mngrOneOnOneAnswer(param);
        } else if(ProcType.UPDATE.equals(procType)){
            egovNctsMngrOneOnOneMapper.mngrOneOnOneAnswerUp(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void delAnswerManage(MngrOneOnOneVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrOneOnOneMapper.delAnswerManage(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressOneOnOne(HttpServletRequest request, MngrOneOnOneVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)) {
            egovNctsMngrOneOnOneMapper.oneOnOneUpdateProc(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    /*
    public HashMap<String, Object> selectCommonExcel(MngrBbsManageVO vo)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrBbsManageMapper.selectCommonExcel(vo);
        
        for(int i=0; i<rsTp.size(); i++){
            rsTp.get(i).put("CONTENTS", ParamUtils.removeHtmlTag((String) rsTp.get(i).get("CONTENTS")));
        }
        
        paramMap.put("rsList",rsTp);
        fileName = "mngrManageList";
        templateFile = "mngrManageList.xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }
    
    */
}
