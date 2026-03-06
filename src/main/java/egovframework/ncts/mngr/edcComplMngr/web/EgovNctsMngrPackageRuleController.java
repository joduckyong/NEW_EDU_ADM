package egovframework.ncts.mngr.edcComplMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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

import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsPackageRuleService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrPackageRuleVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcComplMngr")
public class EgovNctsMngrPackageRuleController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrPackageRuleController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private EgovNctsPackageRuleService egovNctsPackageRuleService;
    
    @PreAuth(menuCd="110130201", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrPackageRuleList.do")
    public String mngrPackageRuleList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrPackageRuleVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        List<HashMap<String, Object>> commonList  = null;
        
        list = egovNctsPackageRuleService.selectPackageRuleList(pageVO);
        commonList = commonCodeService.getCodeByGroup("DMH29");
        
        model.addAttribute("list", list);
        model.addAttribute("codeMap", commonList);
        
        return "mngr/edcComplMngr/mngrPackageRuleList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrPackageRuleDetail.do")
    public @ResponseBody HashMap<String, Object> mngrPackageRuleDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrPackageRuleVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsPackageRuleService.selectPackageRuleDetail(param);
        
        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110130201", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrPackageRuleForm.do")
    public String mngrPackageRuleForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrPackageRuleVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> commonList  = null;
                
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        commonList = commonCodeService.getCodeByGroup("DMH29");

        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsPackageRuleService.selectPackageRuleDetail(param);
            model.addAttribute("result", result);
        }

        model.addAttribute("codeMap", commonList);
        return "mngr/edcComplMngr/mngrPackageRuleForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110130201")
    @RequestMapping(value = "/mngrPackageRuleProc.do")
    public @ResponseBody HashMap<String, Object> mngrPackageRuleProc(HttpServletRequest request ,ModelMap model, @ModelAttribute("common") MngrPackageRuleVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        CustomUser user = SessionUtil.getProperty(request);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());
			param.setLastUpdusrId(user.getUserId());
		}
        
        egovNctsPackageRuleService.mngrPackageRuleProc(param);
            
        result.put("success", "success");
        result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));

        return result;
    }
    
    @AuthCheck(menuCd="110130201")
    @RequestMapping(value = "/deletePackageRule.do")
    public @ResponseBody HashMap<String, Object> deletePackageRule(HttpServletRequest request,ModelMap model, @ModelAttribute MngrPackageRuleVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsPackageRuleService.mngrPackageRuleProc(param);
            
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
    
	@RequestMapping(value = "/mngrPackageListPopup.do")
	public String mngrPackageListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrPackageRuleVO param) throws Exception {
		List<HashMap<String, Object>> list = null;
		List<HashMap<String, Object>> commonList  = null;
		
		commonList = commonCodeService.getCodeByGroup("DMH14");
        list = egovNctsPackageRuleService.selectMngrEduPackageInfoList(pageVO);
		
		model.addAttribute("list", list);
		model.addAttribute("codeMap", commonList);
		
		return "mngr/edcComplMngr/mngrPackageListPopup.ncts_popup";
	}    
}