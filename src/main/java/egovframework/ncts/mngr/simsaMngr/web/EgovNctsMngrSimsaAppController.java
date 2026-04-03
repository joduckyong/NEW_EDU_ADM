package egovframework.ncts.mngr.simsaMngr.web;

import java.io.IOException;
import java.util.ArrayList;
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

import egovframework.com.DateUtil;
import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.mngr.shareMngr.web.EgovNctsMngrShareController;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaAppService;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaService;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

@Controller
@RequestMapping(value = "/ncts/mngr/simsaMngr")
public class EgovNctsMngrSimsaAppController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrShareController.class);

	@Autowired
	private EgovNctsMngrSimsaAppService egovNctsSimsaAppService;
	@Autowired
	private EgovNctsMngrSimsaService egovNctsSimsaService;
	@Autowired
	private CommonCodeService commonCodeService;
    @Autowired
    private ExcelDownloadView excelDownloadView;	
	
	@PreAuth(menuCd = "110110101", pageType = PageType.FORM)
	@RequestMapping(value = "/mngrSimsaApplicant.do")
	public String mngrSimsaAppList(HttpServletRequest request, ModelMap model, @ModelAttribute("common") MngrSimsaApplicantVO param, MngrSimsaManageVO vo, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) egovNctsSimsaAppService.selectSimsaAppList(param);
		HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
	    
	    HashMap<String, Object> codeMap = new HashMap<>();
	    codeMap.put("DMH25", commonCodeService.getCodeByGroup("DMH25")); // 교육 소분류
	    codeMap.put("DMH26", commonCodeService.getCodeByGroup("DMH26")); // 강사 소분류
	    codeMap.put("DMH27", commonCodeService.getCodeByGroup("DMH27")); // 통보방법
	    codeMap.put("DMH28", commonCodeService.getCodeByGroup("DMH28")); // 심사결과
	    
	    if((null != param.getSimsaSeq() && !"".equals(param.getSimsaSeq())) || (null != param.getSearchCondition2() && "sn".equals(param.getSearchCondition2()))) {
	    	HashMap<String, Object> rs = egovNctsSimsaService.selectSimsaListDetail(vo);
	    	model.addAttribute("rs", rs);
	    }
	    model.addAttribute("rslist", rslist);
	    model.addAttribute("cal", year);
	    model.addAttribute("codeMap", codeMap);
			
	    return "mngr/simsaMngr/mngrSimsaApplicant.ncts_content";
	}
	
	@RequestMapping(value = "/selectSimsaNumList.do")
	public @ResponseBody HashMap<String, Object> selectSimsaNumList(HttpServletRequest request, ModelMap model,@ModelAttribute MngrSimsaManageVO param) throws Exception  {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("simsaNumList", egovNctsSimsaService.selectSimsaNumList());
			result.put("success", "success");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		return result;
	}	
	
	@RequestMapping(value = "/updateSimsaAppList.do")
	public @ResponseBody HashMap<String, Object> updateSimsaAppList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrSimsaApplicantVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		CustomUser user = SessionUtil.getProperty(request);
		try {
			if(null != user) param.setLastUpdusrId(user.getUserId());
			egovNctsSimsaAppService.updateSimsaAppList(param);
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		} catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		return result;
	}	
	
    @RequestMapping(value = "/simsaAppExcelDownload.do")
    public void simsaAppExcelDownload(HttpServletRequest request, HttpServletResponse response, ModelMap model,@ModelAttribute("common") MngrSimsaApplicantVO param) throws Exception {
        HashMap<String, Object> rsMap = egovNctsSimsaAppService.selectSimsaAppExcelDownload(param);
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }	
		
	
	 
}
