package egovframework.ncts.mngr.instrctrMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.CookieGenerator;

import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrMngrService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrMngrVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Controller
@RequestMapping(value = "/ncts/mngr/instrctrMngr")
public class EgovNctsInstrctrMngrController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrMngrController.class);
    
    @Autowired
    private EgovNctsInstrctrMngrService egovNctsInstrctrMngrService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
    
    @PreAuth(menuCd="110010101", pageType=PageType.LIST)
    @RequestMapping(value = "/instrctrMngrList.do")
    public String instrctrMngrList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrMngrVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        String jspFile = "";
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급
        codeMap.put("DMH30", commonCodeService.getCodeByGroup("DMH30")); // 강사활동결과등급
        
        if(null != pageVO.getSearchCondition1() && !"".equals(pageVO.getSearchCondition1())) {
        	list = egovNctsInstrctrMngrService.selectInstrctrOfflectList(pageVO);
        	jspFile = "instrctrOfflectList";
        } else {
        	pageVO.setsGubun3("INSTRCTR");
        	list = egovNctsInstrctrMngrService.selectInstrctrMngrList(pageVO);
        	jspFile = "instrctrMngrList";
        }
        
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        
        return "mngr/instrctrMngr/"+ jspFile +".ncts_content";
    }
    
    @RequestMapping(value = "/mngrInstrctrDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrInstrctrDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("common2") MngrInstrctrMngrVO instrctrParam, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> seList = null;
        List<HashMap<String, Object>> seVideoList = null;
        HashMap<String, Object> de = egovNctsInstrctrMngrService.selectMngrInstrctrDetail(param);
        seList = egovNctsMngrMemberService.selectMngrMemberSeDetail(param);
        seVideoList = egovNctsMngrMemberService.selectMngrMemberSeVideoDetail(param);
        List<HashMap<String, Object>> status = egovNctsInstrctrMngrService.selectInstrctrStatusList(pageVO);
        
        result.put("de", de);
        result.put("status", status);
        result.put("se", seList);
        result.put("seVideo", seVideoList);
        result.put("success", "success");
        return result;
    }    
    
    @PreAuth(menuCd="110010101", pageType=PageType.FORM)
    @RequestMapping(value = "/instrctrForm.do")
    public String instrctrForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH08", commonCodeService.getCodeByGroup("DMH08"));
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급        
        
        if (ProcType.UPDATE.equals(procType)) {
            HashMap<String, Object> result = new HashMap<>();

            result = egovNctsMngrMemberService.selectMngrMemberDetail(param);
            //result.put("USER_PW", egovNctsMngrMemberService.getDecryptPw(result.get("USER_PW"))); 
            
            model.addAttribute("result", result);
        }
        
        model.addAttribute("codeMap", codeMap);
        return "mngr/instrctrMngr/instrctrForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110010101")
    @RequestMapping(value = "/mngrProc.do")
    public @ResponseBody HashMap<String, Object> mngrProc(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        
        try {
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
    
    @RequestMapping(value = "/instrctrOfflectExcelDownload.do")
    public void instrctrOfflectExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsInstrctrMngrService.selectInstrctrOfflectExcelDownload(pageVO);
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }        
    
    @RequestMapping(value = "/instrctrTabPopup.do")
    public String instrctrTabPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, MngrMemberVO memberVO) throws Exception {
    	return "mngr/instrctrMngr/instrctrTabPopup.ncts_popup";
    }        
    
    @RequestMapping(value = "/insertInstrctrStatus.do")
    public @ResponseBody HashMap<String, Object> insertInstrctrStatus(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrInstrctrMngrVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
    	try {
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) {
    			param.setFrstRegisterId(user.getUserId());
    			param.setLastUpdusrId(user.getUserId());
    		}    		
    		egovNctsInstrctrMngrService.insertInstrctrStatus(param);
    		
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
    
    @RequestMapping(value = "/mngrInstrctrStatusListPopup.do")
    public String mngrInstrctrStatusListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, MngrInstrctrMngrVO param) throws Exception {
    	pageVO.setPageType("INSTRCTR");
    	List<HashMap<String, Object>> rslist = egovNctsInstrctrMngrService.selectInstrctrStatusList(pageVO);
    	model.addAttribute("rslist", rslist);
    	return "mngr/instrctrMngr/mngrInstrctrStatusListPopup.ncts_popup";
    }        
    
}