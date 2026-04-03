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
public class EgovNctsSysRecoController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysRecoController.class); 
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	
	@PreAuth(menuCd="90040401", pageType=PageType.LIST)
	@RequestMapping(value = "/recoForm.do")
	public String recoForm(HttpServletRequest request, ModelMap model, @ModelAttribute("common") EvalManageCodeVO param) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(SessionUtil.hasAdminRole(request) || SessionUtil.hasUserRole(request))
			param.setCenterCd(user.getCenterId());
		
		List<HashMap<String, Object>> recoList = (List<HashMap<String, Object>>) commonCodeService.getRecoList(param);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		model.addAttribute("centerList", centerList);
		model.addAttribute("recoList", recoList);
		
		return "cmm/sys/eval/recoForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectRecoView.do")
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
	
	@RequestMapping(value = "/selectRecoList.do")
	public @ResponseBody HashMap<String, Object> selectRecoList(@ModelAttribute("common") EvalManageCodeVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> recoList = (List<HashMap<String, Object>>) commonCodeService.getRecoList(param);
			
			result.put("recoList", recoList);
			
			result.put("success", "success");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}
}
