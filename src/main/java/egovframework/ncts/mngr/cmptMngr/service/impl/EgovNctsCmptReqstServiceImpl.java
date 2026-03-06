package egovframework.ncts.mngr.cmptMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.file.mapper.FileMngeMapper;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.cmptMngr.mapper.EgovNctsCmptReqstMapper;
import egovframework.ncts.mngr.cmptMngr.service.EgovNctsCmptReqstService;
import egovframework.ncts.mngr.cmptMngr.vo.MngrCmptReqstVO;

@Service
public class EgovNctsCmptReqstServiceImpl implements EgovNctsCmptReqstService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsCmptReqstServiceImpl.class);
    
    @Autowired
    private EgovNctsCmptReqstMapper egovNctsCmptReqstMapper;
    
    @Autowired
    private FileMngeMapper fileMngeMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectCmptReqstList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsCmptReqstMapper.selecCmptReqstTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsCmptReqstMapper.selectCmptReqstList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectCmptReqstDetail(MngrCmptReqstVO param)throws Exception{
        HashMap<String, Object> rs = egovNctsCmptReqstMapper.selectCmptReqstDetail(param);
		rs.put("CMPT_REQST_CONTENTS", ParamUtils.reverseHtmlTag((String)rs.get("CMPT_REQST_CONTENTS")));
		rs.put("CMPT_REQST_CONTENTS_ANSWER", ParamUtils.reverseHtmlTag((String)rs.get("CMPT_REQST_CONTENTS_ANSWER")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		
		List<HashMap<String, Object>> fileList = fileMngeMapper.selectFileInfs((String)rs.get("ATCH_FILE_ID"));
		if(null != fileList && fileList.size() >0){
			HashMap<String, Object> fileMap = fileList.get(0);
			if(null != fileMap) rs.put("STRE_FILE_NM",fileMap.get("STRE_FILE_NM"));
		}
        return rs;
    }
    
    @Override
    public void mngrProgressCmptReqst(MngrCmptReqstVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			param.setNoTag(ParamUtils.removeHtmlTag(param.getCmptReqstContentsSnapshot()));
			egovNctsCmptReqstMapper.insertCmptReqst(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			param.setNoTag(ParamUtils.removeHtmlTag(param.getCmptReqstContentsSnapshot()));
			egovNctsCmptReqstMapper.updateCmptReqst(param);
		}else if (ProcType.DELETE.equals(procType)) {
			egovNctsCmptReqstMapper.deleteCmptReqst(param);
		}else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
    }

	@Override
	public void updateReflctYn(MngrCmptReqstVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.DELETE.equals(procType)) {
			String yn = "";
			if("Y".equals(param.getReflctYn())) yn = "N";
			else if("N".equals(param.getReflctYn())) yn = "Y";
			param.setReflctYn(yn);
			egovNctsCmptReqstMapper.updateReflctYn(param);
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	public void mngrCmptAnswer(HttpServletRequest request, MngrCmptReqstVO param)throws Exception{
	    ProcType procType = ProcType.findByProcType(param.getProcType());

        if (ProcType.UPDATE.equals(procType)){
            egovNctsCmptReqstMapper.mngrCmptAnswer(param);
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public void mngrCmptConfirmAt(MngrCmptReqstVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)){
			egovNctsCmptReqstMapper.mngrCmptConfirmAt(param);
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
}
