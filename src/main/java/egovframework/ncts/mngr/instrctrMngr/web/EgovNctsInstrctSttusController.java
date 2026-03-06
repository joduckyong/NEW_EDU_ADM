package egovframework.ncts.mngr.instrctrMngr.web;

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
import org.springframework.web.util.CookieGenerator;

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrSttusService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrSttusVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Controller
@RequestMapping(value = "/ncts/mngr/instrctrMngr")
public class EgovNctsInstrctSttusController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctSttusController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;    
    
    @Autowired
    private EgovNctsInstrctrSttusService egovNctsInstrctrSttusService;
    @Autowired
    
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	 
	
	@Autowired
	private ExcelDownloadView excelDownloadView;	    
    
    @PreAuth(menuCd="110010401", pageType=PageType.LIST)
    @RequestMapping(value = "/instrctrSttusList.do")
    public String instrctrMngrList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrSttusVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        
        codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14")); // 단계
        codeMap.put("DMH19", commonCodeService.getCodeByGroup("DMH19")); // 교육 구분
    	
		CustomUser user = SessionUtil.getProperty(request);
		/*if(null != user) {
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) pageVO.setCenterCd(user.getCenterId());	
		}*/
        
        List<HashMap<String, Object>> list = egovNctsInstrctrSttusService.selectInstrctrSttusList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        
		model.addAttribute("centerList", CenterList);
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        
        return "mngr/instrctrMngr/instrctrSttusList.ncts_content";
    }
    
    @RequestMapping(value = "/instrctrSttusDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrMemberDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrSttusVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsInstrctrSttusService.selectInstrctrSttusDetail(param);
        
        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @RequestMapping(value = "/instrctrSttusExcelDownload.do")
    public void instrctrSttusExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsInstrctrSttusService.selectInstrctrSttusExcelDownload(pageVO);
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }    
    
    @RequestMapping(value = "/instrctrDetailPopup.do")
    public String instrctrDetailPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrInstrctrSttusVO param, MngrMemberVO memberVO) throws Exception {
    	HashMap<String, Object> codeMap = new HashMap<>();
    	codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급
    	
    	if(null != param.getInstrctrNo() && !"".equals(param.getInstrctrNo())) {
    		List<HashMap<String, Object>> list = egovNctsInstrctrSttusService.selectInstrctrDetailList(pageVO);
    		memberVO.setUserNo(Integer.parseInt(param.getInstrctrNo()));
    		HashMap<String, Object> user = egovNctsMngrMemberService.selectMngrMemberDetail(memberVO);
    		model.addAttribute("list", list);
    		model.addAttribute("user", user);
    	}
    	
    	model.addAttribute("codeMap", codeMap);
    	return "mngr/instrctrMngr/instrctrDetailPopup.ncts_popup";
    }    
    
    
}