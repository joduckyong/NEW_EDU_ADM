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
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsMngrEduPackageService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEduPackageVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcComplMngr")
public class EgovNctsMngrEduPackageController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduPackageController.class);
    
	@Autowired
	private CommonCodeService commonCodeService;    
    
	@Autowired
	private EgovNctsMngrCommonService egovNctsMngrCommonService;    
    
    @Autowired
    private EgovNctsMngrEduPackageService egovNctsMngrEduPackageService;
    
    @PreAuth(menuCd="110130101", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrEduPackageList.do")
    public String selectMngrEduPackageList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduPackageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        
        List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) egovNctsMngrEduPackageService.selectMngrEduPackageInfoList(pageVO);
        
        model.addAttribute("packageList", rslist);
        
        return "mngr/edcComplMngr/mngrEduPackageList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrEduPackageDetail.do")
    public @ResponseBody HashMap<String, Object> mngrEduPackageDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduPackageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> detail = egovNctsMngrEduPackageService.selectMngrEduPackageDetail(param);
        List<HashMap<String, Object>> codeList = egovNctsMngrEduPackageService.selectMngrEduPackageDetailCodeList(param);
        
        result.put("detail", detail);
        result.put("codeList", codeList);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110130101", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrEduPackageForm.do")
    public String mngrEduPackageForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrEduPackageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> codeMap = new HashMap<>();
        codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
        codeMap.put("DMH19", commonCodeService.getCodeByGroup("DMH19"));
        codeMap.put("DMH29", commonCodeService.getCodeByGroup("DMH29"));
        
        ProcType procType = ProcType.findByProcType(param.getProcType());
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrEduPackageService.selectMngrEduPackageDetail(param);
            model.addAttribute("result", result);
        }
        model.addAttribute("codeMap", codeMap);

        return "mngr/edcComplMngr/mngrEduPackageForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110130101")
    @RequestMapping(value = "/mngrEduPackageProc.do")
    public @ResponseBody HashMap<String, Object> mngrEduPackageProc(HttpServletRequest request, ModelMap model, @ModelAttribute("common") MngrEduPackageVO param) throws Exception{
    	HashMap<String, Object> result = new HashMap<>();
        CustomUser user = SessionUtil.getProperty(request);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());
			param.setLastUpdusrId(user.getUserId());
		}
        
        egovNctsMngrEduPackageService.mngrEduPackageProc(param);
            
        result.put("success", "success");
        result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));

        return result;
    }
    
    @AuthCheck(menuCd="110130101")
    @RequestMapping(value = "/deleteMngrEduPackageInfo.do")
    public @ResponseBody HashMap<String, Object> deleteMngrEduPackageInfo(HttpServletRequest request, ModelMap model, @ModelAttribute("common") MngrEduPackageVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsMngrEduPackageService.deleteMngrEduPackageInfo(param);
            
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
    
	@RequestMapping(value = "/offlectListPopup.do")
	public String offlectListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrCommonVO param) throws Exception {
		List<HashMap<String, Object>> list = egovNctsMngrCommonService.selectLectureList(param);
		model.addAttribute("list", list);
		
		return "mngr/edcComplMngr/offlectListPopup.ncts_popup";
	}    
    
}