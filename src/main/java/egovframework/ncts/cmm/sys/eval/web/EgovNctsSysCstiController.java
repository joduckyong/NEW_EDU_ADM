package egovframework.ncts.cmm.sys.eval.web;

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

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.eval.vo.EvalManageCodeVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/eval")
public class EgovNctsSysCstiController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysCstiController.class); 
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	
	@PreAuth(menuCd="90040201", pageType=PageType.LIST)
	@RequestMapping(value = "/cstiForm.do")
	public String cstiForm(HttpServletRequest request, ModelMap model, @ModelAttribute("common") EvalManageCodeVO param) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(SessionUtil.hasAdminRole(request) || SessionUtil.hasUserRole(request))
			param.setCenterCd(user.getCenterId());
		
		List<HashMap<String, Object>> cstiList = (List<HashMap<String, Object>>) commonCodeService.getCstiList(param);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		model.addAttribute("centerList", centerList);
		model.addAttribute("cstiList", cstiList);
		
		return "cmm/sys/eval/cstiForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectCstiView.do")
	public @ResponseBody HashMap<String, Object> selectRescDetail(ModelMap model) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			result.put("success", "success");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value = "/selectCstiList.do")
	public @ResponseBody HashMap<String, Object> selectCstiList(@ModelAttribute("common") EvalManageCodeVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> cstiList = (List<HashMap<String, Object>>) commonCodeService.getCstiList(param);
			
			result.put("cstiList", cstiList);
			
			result.put("success", "success");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}
}
