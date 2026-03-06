package egovframework.ncts.mngr.cmptMngr.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.com.DateUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.cmptMngr.service.EgovNctsCmptReqstService;
import egovframework.ncts.mngr.cmptMngr.vo.MngrCmptReqstVO;

@Controller
@RequestMapping(value = "/ncts/mngr/cmptMngr")
public class EgovNctsMngrCmptReqstController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrCmptReqstController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private EgovNctsCmptReqstService egovNctsCmptReqstService;
    
    @PreAuth(menuCd="110080101", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrCmptReqstList.do")
    public String mngrCmptReqstList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCmptReqstVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        List<HashMap<String, Object>> codeList  = null;
        List<HashMap<String, Object>> commonList  = null;
        String course = "";
        
        list = egovNctsCmptReqstService.selectCmptReqstList(pageVO);
        HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
        
        model.addAttribute("cal", year);
        model.addAttribute("codeList", codeList);
        model.addAttribute("codeMap", commonList);
        model.addAttribute("list", list);
        
        return "mngr/cmptMngr/mngrCmptReqstList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrCmptReqstDetail.do")
    public @ResponseBody HashMap<String, Object> mngrCmptReqstDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCmptReqstVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsCmptReqstService.selectCmptReqstDetail(param);
        result.put("de", de);
        result.put("success", "success");
        
        return result;
    }
    
    @PreAuth(menuCd="110080101", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrCmptReqstForm.do")
    public String mngrCmptReqstForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrCmptReqstVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> commonList  = null;
        List<HashMap<String, Object>> codeList  = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
		String atchFileId = "";
		if (ProcType.UPDATE.equals(procType)) {
			result = egovNctsCmptReqstService.selectCmptReqstDetail(param);
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(10)
                .build();
        
        model.addAttribute("markup", markup);
        return "mngr/cmptMngr/mngrCmptReqstForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110080101")
	@RequestMapping(value = "/mngrProgressCmptReqst.do")
	public @ResponseBody HashMap<String, Object> mngrProgressCmptReqst(final MultipartHttpServletRequest multiRequest,ModelMap model, @ModelAttribute MngrCmptReqstVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			if (ProcType.isFindFileUpload(param.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("mngr")     // 저장위치
						.keyStr("mngr_") // 파일명키
						.procType(ProcType.findByProcType(param.getProcType()))
						.atchFileId(param.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
			}
			
			egovNctsCmptReqstService.mngrProgressCmptReqst(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
    
    @AuthCheck(menuCd="110080101")
    @RequestMapping(value = "/deleteCmptReqst.do")
    public @ResponseBody HashMap<String, Object> deleteCmptReqst(ModelMap model, @ModelAttribute MngrCmptReqstVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		egovNctsCmptReqstService.mngrProgressCmptReqst(param);
    		
    		result.put("success", "success");
    		result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
    	}catch (IOException e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
    	}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
    	
    	return result;
    }
    
    @AuthCheck(menuCd="110080101")
    @RequestMapping(value = "/updateReflctYn.do")
    public @ResponseBody HashMap<String, Object> updateReflctYn(ModelMap model, @ModelAttribute MngrCmptReqstVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	 String msg = "";
    	try {
    		egovNctsCmptReqstService.updateReflctYn(param);
    		
    		if("N".equalsIgnoreCase(param.getReflctYn())){
                msg = "미반영되었습니다.";
            } else if("Y".equalsIgnoreCase(param.getReflctYn())){
                msg = "반영되었습니다.";
            } else {
                msg = ProcessMessageSource.newInstance().getMsg(param.getProcType());
            }
    		
    		result.put("success", "success");
    		result.put("msg", msg);
    	}catch (IOException e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
    	}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
    	
    	return result;
    }
    
    @RequestMapping(value = "/mngrCmptAnswer.do")
    public @ResponseBody HashMap<String, Object> mngrCmptAnswer(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCmptReqstVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            egovNctsCmptReqstService.mngrCmptAnswer(request, param);
            
            result.put("success", "success");
            result.put("msg", "저장되었습니다.");
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg("UPDATE"));
        }catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg("UPDATE"));
		}

        return result;
    }
    
    @RequestMapping(value = "/mngrCmptConfirmAt.do")
    public @ResponseBody HashMap<String, Object> mngrCmptConfirmAt(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCmptReqstVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> result = new HashMap<>();
    	
    	try {
    		egovNctsCmptReqstService.mngrCmptConfirmAt(param);
    		
    		result.put("success", "success");
    		result.put("msg", "저장되었습니다.");
    	}catch (IOException e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg("UPDATE"));
    	}catch (Exception e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg("UPDATE"));
    	}
    	
    	return result;
    }
    
}