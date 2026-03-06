package egovframework.ncts.mngr.userMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.util.CookieGenerator;

import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;


@Controller
@RequestMapping(value = "/ncts/mngr/userMngr")
public class EgovNctsMngrMemberController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrMemberController.class);
    
    @Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110060301", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrMemberList.do")
    public String mngrMemberList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급        
        list = egovNctsMngrMemberService.selectMngrMemberList(pageVO);
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        return "mngr/userMngr/mngrMemberList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrMemberDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrMemberDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> seList = null;
        List<HashMap<String, Object>> seVideoList = null;
        HashMap<String, Object> de = egovNctsMngrMemberService.selectMngrMemberDetail(param);
        seList = egovNctsMngrMemberService.selectMngrMemberSeDetail(param);
        seVideoList = egovNctsMngrMemberService.selectMngrMemberSeVideoDetail(param);
        
        result.put("de", de);
        result.put("se", seList);
        result.put("seVideo", seVideoList);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110060301", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrMemberForm.do")
    public String mngrMemberForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH08", commonCodeService.getCodeByGroup("DMH08"));
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급        
        
        String atchFileId = "";
        
        if (ProcType.UPDATE.equals(procType)) {
            HashMap<String, Object> result = new HashMap<>();

            result = egovNctsMngrMemberService.selectMngrMemberDetail(param);
            //result.put("USER_PW", egovNctsMngrMemberService.getDecryptPw(result.get("USER_PW"))); 
            atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
            
            model.addAttribute("result", result);
        }
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(false)
                .atchFileId(atchFileId)
                .fileTotal(1)
                .build();
        
        model.addAttribute("codeMap", codeMap);
        model.addAttribute("markup", markup);
        return "mngr/userMngr/mngrMemberForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110060301")
    @RequestMapping(value = "/mngrProc.do")
    public @ResponseBody HashMap<String, Object> mngrProc(final MultipartHttpServletRequest multiRequest,HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	
        	if (ProcType.isFindFileUpload(param.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("join")     // 저장위치
						.keyStr("join_") // 파일명키
						.procType(ProcType.findByProcType(param.getProcType()))
						.atchFileId(param.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
			}
        	
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) {
    			param.setFrstRegisterId(user.getUserId());
    			param.setLastUpdusrId(user.getUserId());
    		}
            egovNctsMngrMemberService.mngrProc(param);
            
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
    
    @RequestMapping(value = "/mngrDeleteMember.do")
    public @ResponseBody HashMap<String, Object> mngrDeleteMember(HttpServletRequest request,ModelMap model, @ModelAttribute MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrMemberService.delMember(param);
            
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
    
    @RequestMapping(value = "/memberExcelDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrMemberService.selectCommonExcel(pageVO);
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    
    @RequestMapping(value = "/selecSeDetail.do")
    public @ResponseBody HashMap<String, Object> selecSeDetail(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> seList = null;
        seList = egovNctsMngrMemberService.selecSeDetail(param);
        
        result.put("se", seList);
        result.put("success", "success");
        return result;
    }
    
    @RequestMapping(value = "/selectIdEmailChk.do")
    public @ResponseBody HashMap<String, Object> selectEmailChk(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param) throws Exception {
    	HashMap<String, Object> result = new HashMap<>();
    	HashMap<String,Object> infoChk = egovNctsMngrMemberService.selectIdEmailChk(param);
    	
    	result.put("infoChk", infoChk);
    	result.put("success", "success");
    	return result;
    }
    
    @RequestMapping(value = "/isueCertProc.do")
    public @ResponseBody HashMap<String, Object> isueCertProc(HttpServletResponse res, HttpServletRequest request,ModelMap model, @ModelAttribute MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null) ip = request.getRemoteAddr();
        param.setUserIp(ip);
        
        try {
            egovNctsMngrMemberService.isueCertProc(param);
            
            result.put("success", "success");
            result.put("msg", "완료");
        } catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        } catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
        return result;
    }
    
    @RequestMapping(value = "/fileConfirmProcess.do")
    public @ResponseBody HashMap<String, Object> fileConfirmProcess(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        CustomUser user = SessionUtil.getProperty(request);
		if(null != user) param.setFileConfirmId(user.getUserId());
        try {
            egovNctsMngrMemberService.fileConfirmProcess(param);
            
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
    
    @RequestMapping(value = "/mngrFileConfirmListPopup.do")
    public String mngrFileConfirmListPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
	   List<HashMap<String, Object>> rslist = egovNctsMngrMemberService.selectFileConfirmList(pageVO);
	   model.addAttribute("rslist",rslist);
	   return "mngr/userMngr/mngrFileConfirmListPopup.ncts_popup";
    }
    
    @RequestMapping(value = "/updateMngrMemberNote.do")
    public @ResponseBody HashMap<String, Object> updateMngrMemberNote(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		egovNctsMngrMemberService.updateMngrMemberNote(param);
    		
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
    
    @RequestMapping(value = "/updateMngrMemberEntrstDe.do")
    public @ResponseBody HashMap<String, Object> updateMngrMemberEntrstDe(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		egovNctsMngrMemberService.updateMngrMemberEntrstDe(param);
    		
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
    
    @RequestMapping(value = "/updateMngrMemberPackageAuthAt.do")
    public @ResponseBody HashMap<String, Object> updateMngrMemberPackageAuthAt(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		egovNctsMngrMemberService.updateMngrMemberPackageAuthAt(param);
    		
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
    
    @RequestMapping(value = "/mngrMemberNoteListPopup.do")
    public String mngrMemberNoteListPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> rs = egovNctsMngrMemberService.selectMngrMemberDetail(param);
    	List<HashMap<String, Object>> rslist = egovNctsMngrMemberService.selectMemberNoteList(pageVO);
    	model.addAttribute("rs",rs);
    	model.addAttribute("rslist",rslist);
    	return "mngr/userMngr/mngrMemberNoteListPopup.ncts_popup";
    }    
    
    @RequestMapping(value = "/selectMemberNoteDetail.do")
    public @ResponseBody HashMap<String, Object> selectMemberNoteDetail(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param) throws Exception {
    	HashMap<String, Object> result = new HashMap<>();
    	HashMap<String,Object> rs = egovNctsMngrMemberService.selectMemberNoteDetail(param);
    	
    	result.put("rs", rs);
    	result.put("success", "success");
    	return result;
    }    
    
    @RequestMapping(value = "/mngrMemberNoteProc.do")
    public @ResponseBody HashMap<String, Object> mngrMemberNoteProc(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
        CustomUser user = SessionUtil.getProperty(request);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());    	
			param.setLastUpdusrId(user.getUserId());    	
		}
    	try {
    		egovNctsMngrMemberService.mngrMemberNoteProc(param);
    		
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
    
}