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
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrBbsNoticeService;
import egovframework.ncts.mngr.homeMngr.vo.MngrBbsNoticeVO;
import egovframework.ncts.mngr.homeMngr.vo.MngrPopupVO;
import egovframework.ncts.mngr.homeMngr.mapper.EgovNctsMngrBbsNoticecMapper;

@Service
public class EgovNctsMngrBbsNoticeImpl implements EgovNctsMngrBbsNoticeService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsNoticeImpl.class);
    
    @Autowired
    private EgovNctsMngrBbsNoticecMapper egovNctsMngrBbsNoticecMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectMngrBbsNoticeList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrBbsNoticecMapper.selectBbsNoticeCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrBbsNoticecMapper.selectMngrBbsNoticeList(pageVO);
    }
   
    @Override
    public HashMap<String, Object> selectBbsNoticeDetail(MngrBbsNoticeVO param)throws Exception{
        HashMap<String, Object> result = egovNctsMngrBbsNoticecMapper.selectBbsNoticeDetail(param);
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
    
    
    public void delBbsNotice(MngrBbsNoticeVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrBbsNoticecMapper.delBbsNotice(param);
        } else{
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressBbsNotice(HttpServletRequest request, MngrBbsNoticeVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        
        if(ProcType.UPDATE.equals(procType)) {
            param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
            egovNctsMngrBbsNoticecMapper.bbsNoticeUpdateProc(param);
        } else if(ProcType.INSERT.equals(procType)) {
            param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));
            egovNctsMngrBbsNoticecMapper.bbsNoticeInsertProc(param);
        } else{
            throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }

	@Override
	public void updateBbsNotag(MngrBbsNoticeVO param) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsMngrBbsNoticecMapper.selectBbsNoTagNull();
		List<HashMap<String, Object>> rslist2 = egovNctsMngrBbsNoticecMapper.selectBbsNoTagNullPop();
		
		for(int i=0; i<rslist.size(); i++) {
			MngrBbsNoticeVO vo = new MngrBbsNoticeVO();
			vo.setBbsNo(Integer.parseInt(String.valueOf(rslist.get(i).get("BBS_NO"))));
			vo.setNoTag(ParamUtils.removeHtmlTag((String) rslist.get(i).get("CONTENTS")));
			
			egovNctsMngrBbsNoticecMapper.updateBbsNotag(vo);
		}
		for(int i=0; i<rslist2.size(); i++) {
			if(null != rslist2.get(i).get("CONTENTS")) {
				MngrPopupVO vo = new MngrPopupVO();
				vo.setNoTag(ParamUtils.removeHtmlTag((String) rslist2.get(i).get("CONTENTS")));
				vo.setPopNo(Integer.parseInt(String.valueOf(rslist2.get(i).get("POP_NO"))));
				
				egovNctsMngrBbsNoticecMapper.updateBbsNotagPop(vo);
			}
		}
		

	}
    
    
}
