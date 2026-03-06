package egovframework.ncts.mngr.edcComplMngr.web;

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
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsLctreOffService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreOffVO;
import egovframework.ncts.mngr.edcOperMngr.vo.MngrLctreVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduApplicantVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcComplMngr")
public class EgovNctsMngrLctreOffController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrLctreOffController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private EgovNctsLctreOffService egovNctsLctreOffService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110040601", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrLctreOffList.do")
    public String mngrLctreOffList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrLctreOffVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        String course = "";
        pageVO.setsGubun("Y");
        List<HashMap<String, Object>> list = egovNctsLctreOffService.selectLctreList(pageVO);
        
        HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14"));//교육과정
        
        for(int i=0; i<list.size(); i++){
        	course = (String)list.get(i).get("COURSES");
        	
        	if(course.indexOf("00") != -1) list.get(i).put("COURSES00", "00");
        	if(course.indexOf("01") != -1) list.get(i).put("COURSES01", "01");
            if(course.indexOf("02") != -1) list.get(i).put("COURSES02", "02");
            if(course.indexOf("03") != -1) list.get(i).put("COURSES03", "03");
            if(course.indexOf("04") != -1) list.get(i).put("COURSES04", "04");
            if(course.indexOf("07") != -1) list.get(i).put("COURSES07", "07");
        }
        
        model.addAttribute("codeMap", codeMap);
        model.addAttribute("list", list);
        
        return "mngr/edcComplMngr/mngrLctreOffList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrLctreOffDetail.do")
    public @ResponseBody HashMap<String, Object> mngrLctreOffDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrLctreOffVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = null;
        
        try {
            de = egovNctsLctreOffService.selectLctreDetail(param);
            if(null != de && "Y".equals(de.get("VIDEO_AT"))) result.put("lectureList", egovNctsLctreOffService.selectLectureOnlectList(param)); 
            result.put("de", de);
            result.put("success", "success");
        } catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }
        
        return result;
    }
    
    
    @PreAuth(menuCd="110040601", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrLctreOffForm.do")
    public String mngrLctreOffForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrLctreOffVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> commonList  = null;
        List<HashMap<String, Object>> codeList  = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        codeList = commonCodeService.getCodeByGroup("DMH12");
        commonList = commonCodeService.getCodeByGroup("DMH14");
        
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsLctreOffService.selectLctreDetail(param);
            
            model.addAttribute("result", result);
        }
        
        model.addAttribute("codeList", codeList);
        model.addAttribute("codeMap", commonList);
        return "mngr/edcComplMngr/mngrLctreOffForm.ncts_content";
    }
    
    
    //@AuthCheck(menuCd="110040601")
    @RequestMapping(value = "/mngrProgressOffLctre.do")
    public @ResponseBody HashMap<String, Object> mngrProgressLctre(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrLctreOffVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsLctreOffService.mngrProgressOffLctre(request, param);
            
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
    
    //@AuthCheck(menuCd="110040601")
    @RequestMapping(value = "/mngrDeleteOffLctre.do")
    public @ResponseBody HashMap<String, Object> mngrDeleteOffLctre(HttpServletRequest request,ModelMap model, @ModelAttribute MngrLctreOffVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        String msg = "";
        try {
            egovNctsLctreOffService.delOffLctre(param);
            
            result.put("success", "success");

            if("N".equalsIgnoreCase(param.getActiveYn())){
                msg = "활성화를 완료하였습니다.";
            } else if("Y".equalsIgnoreCase(param.getActiveYn())){
                msg = "비활성화를 완료하였습니다.";
            } else {
                msg = ProcessMessageSource.newInstance().getMsg(param.getProcType());
            }

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
    
    @RequestMapping(value = "/lctreOffExcelDownload.do")
    public void lctreOffExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsLctreOffService.selectLctreExcelList(pageVO);
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    
	@RequestMapping(value = "/mngrLctrePopup.do")
	public String mngrLctrePopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrLctreOffVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		ProcType procType = ProcType.findByProcType(param.getProcType());
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		String atchFileId = "";
		
		if (ProcType.UPDATE.equals(procType)) {
			result = egovNctsLctreOffService.selectLectureOnlectDetail(param);
			
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(false)
                .atchFileId(atchFileId)
                .fileTotal(1)
                .build();
		model.addAttribute("markup", markup);
		model.addAttribute("codeMap", codeMap);
		return "mngr/edcComplMngr/mngrLctrePopup.ncts_popup";
	}    
    
    @RequestMapping(value = "/lectureOnlectProc.do")
    public @ResponseBody HashMap<String, Object> lectureOnlectProc(final MultipartHttpServletRequest multiRequest,ModelMap model, @ModelAttribute("common") MngrLctreOffVO param) throws Exception{
		CustomUser user = SessionUtil.getProperty(multiRequest);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());
			param.setLastUpdusrId(user.getUserId());
		}
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
    		
    		egovNctsLctreOffService.lectureOnlectProc(param);
    		
    		result.put("paramData", param);
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
    
    @RequestMapping(value = "/deleteLectureOnlect.do")
    public @ResponseBody HashMap<String, Object> deleteLectureOnlect(HttpServletRequest request,ModelMap model, @ModelAttribute MngrLctreOffVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsLctreOffService.lectureOnlectProc(param);
            
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