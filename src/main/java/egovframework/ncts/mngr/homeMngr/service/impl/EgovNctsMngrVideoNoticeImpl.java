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

import egovframework.com.AESCrypt;
import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.homeMngr.mapper.EgovNctsMngrVideoNoticeMapper;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrVideoNoticeService;
import egovframework.ncts.mngr.homeMngr.vo.MngrVideoNoticeVO;

@Service
public class EgovNctsMngrVideoNoticeImpl implements EgovNctsMngrVideoNoticeService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrVideoNoticeImpl.class);
    
    @Autowired
    private EgovNctsMngrVideoNoticeMapper egovNctsMngrVideoNoticeMapper;
    @Autowired
    private EgovNctsMngrCommonService egovNctsMngrCommonService;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectMngrVideoNoticeList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrVideoNoticeMapper.selectMngrVideoNoticeCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrVideoNoticeMapper.selectMngrVideoNoticeList(pageVO);
    }
   
    @Override
    public HashMap<String, Object> selectVideoNoticeDetail(MngrVideoNoticeVO param)throws Exception{
        HashMap<String, Object> result = egovNctsMngrVideoNoticeMapper.selectVideoNoticeDetail(param);
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString(); 
        
        String originCont = StringEscapeUtils.unescapeHtml3((String) result.get("CONTENTS"));
        if(null != result.get("BBS_PW") && !"".equals(result.get("BBS_PW"))) result.put("BBS_PW", AESCrypt.decrypt(result.get("BBS_PW").toString()));
        
        result.put("CONTENTS", originCont);
        result.put("fileView", fileView);
        
        return result;
    }
    
    public void mngrProgressVideoNotice(HttpServletRequest request, MngrVideoNoticeVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setFrstRegisterId(user.getUserId());
        	param.setLastUpdusrId(user.getUserId());
        }
        
        if(ProcType.INSERT.equals(procType) || ProcType.UPDATE.equals(procType)) {
        	param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
        	if(ProcType.INSERT.equals(procType)) egovNctsMngrVideoNoticeMapper.videoNoticeInsertProc(param);
        	else egovNctsMngrVideoNoticeMapper.videoNoticeUpdateProc(param);
        	
			MngrCommonVO commonVO = new MngrCommonVO();
			commonVO.setPwSeq(param.getPwSeq());
			commonVO.setTypeCd(param.getTypeCd());
			commonVO.setBbsNo(String.valueOf(param.getBbsNo()));
			commonVO.setBbsPw(param.getBbsPw());		
			commonVO.setFrstRegisterId(param.getFrstRegisterId());
			commonVO.setLastUpdusrId(param.getLastUpdusrId());
			egovNctsMngrCommonService.bbsPwProc(commonVO);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void delVideoNotice(MngrVideoNoticeVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrVideoNoticeMapper.delVideoNotice(param);
        } else {
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
}
