package egovframework.ncts.cmm.sys.auth.web;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthService;
import egovframework.ncts.cmm.sys.auth.vo.AuthGrpVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/auth")
public class EgovNctsSysAuthController {
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.setAutoGrowNestedPaths(true);
	    binder.setAutoGrowCollectionLimit(5000);

	}



	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthController.class); 
	
	@Autowired
	private EgovNctsSysAuthService sysAuthService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	
	@PreAuth(menuCd="90030101", pageType=PageType.LIST)
	@RequestMapping(value = "/authList.do")
	public String authList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") AuthVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		
		CustomUser user = SessionUtil.getProperty(request);
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthService.selectAuthList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		return "cmm/sys/auth/authList.ncts_content";
	}
	
	@PreAuth(menuCd="90030101", pageType=PageType.FORM)
	@RequestMapping(value = "/authForm.do")
	public String authInsert(HttpServletRequest request,ModelMap model, @ModelAttribute("common") AuthGrpVO param,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		
		CustomUser user = SessionUtil.getProperty(request);
		
			pageVO.setCenterCd(user.getCenterId());	
			String center = user.getCenterId();
			model.addAttribute("center", center);
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysAuthService.selectDetail(param);
			model.addAttribute("result", result);
		}
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		List<HashMap<String, Object>> rslist=(List<HashMap<String, Object>>) sysAuthService.selectMenuAuthList(param);
		
		model.addAttribute("rslist", rslist);
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("codeMap", codeMap);
		
		return "cmm/sys/auth/authForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90030101")
	@RequestMapping(value = "/authProcess.do")
	public @ResponseBody HashMap<String, Object> authProcess(@ModelAttribute AuthGrpVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysAuthService.authProcess(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch(ErrorExcetion e){
			LOGGER.debug(e.getMessage());
			result.put("msg", e.getMessage());
			
		}catch (Exception e) {		
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
}
