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
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ibm.icu.util.BytesTrie.Iterator;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrBbsManageService;
import egovframework.ncts.mngr.homeMngr.vo.MngrBbsManageVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import egovframework.ncts.mngr.homeMngr.mapper.EgovNctsMngrBbsManageMapper;

@Service
public class EgovNctsMngrBbsManageImpl implements EgovNctsMngrBbsManageService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsManageImpl.class);
    
    @Autowired
    private EgovNctsMngrBbsManageMapper egovNctsMngrBbsManageMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectMngrBbsManageList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrBbsManageMapper.selectBbsManageCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrBbsManageMapper.selectMngrBbsManageList(pageVO);
    }
   
    @Override
    public HashMap<String, Object> selectBbsManageDetail(MngrBbsManageVO param)throws Exception{
        HashMap<String, Object> result = egovNctsMngrBbsManageMapper.selectBbsManageDetail(param);
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
    
    
    public void delBbsManage(MngrBbsManageVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrBbsManageMapper.delBbsManage(param);
        } else{
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressBbsManage(HttpServletRequest request, MngrBbsManageVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        if(ProcType.UPDATE.equals(procType)) {
            param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
            egovNctsMngrBbsManageMapper.bbsManageUpdateProc(param);
        } else if(ProcType.INSERT.equals(procType)) {
            param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
            egovNctsMngrBbsManageMapper.bbsManageInsertProc(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrBbsManageMapper.selectCommonExcel(pageVO);
        
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
    
    public void mngrBbsAnswerManage(HttpServletRequest request, MngrBbsManageVO param)throws Exception{
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setFrstRegisterId(user.getUserId());
        	param.setLastUpdusrId(user.getUserId());
        }
        param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
        
        egovNctsMngrBbsManageMapper.mngrBbsAnswerManage(param);
    }
}
