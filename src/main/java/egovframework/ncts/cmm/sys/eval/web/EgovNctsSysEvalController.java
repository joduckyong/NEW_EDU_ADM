package egovframework.ncts.cmm.sys.eval.web;

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

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.eval.vo.EvalManageCodeVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/eval")
public class EgovNctsSysEvalController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysEvalController.class); 
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	
	@PreAuth(menuCd="90040301", pageType=PageType.FORM, token=true)
	@RequestMapping(value = "/evalForm.do")
	public String evalForm(HttpServletRequest request, ModelMap model, @ModelAttribute("common") EvalManageCodeVO param) throws Exception {

		CustomUser user = SessionUtil.getProperty(request);
		if(SessionUtil.hasAdminRole(request) || SessionUtil.hasUserRole(request))
			param.setCenterCd(user.getCenterId());
		
		List<HashMap<String, Object>> evalList = (List<HashMap<String, Object>>) commonCodeService.getEvalList(param);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		model.addAttribute("centerList", centerList);
		model.addAttribute("evalList", evalList);
		
		return "cmm/sys/eval/evalForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectEvalView.do")
	public @ResponseBody HashMap<String, Object> selectRescDetail(ModelMap model) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			result.put("success", "success");
		
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value = "/selectEvalList.do")
	public @ResponseBody HashMap<String, Object> selectEvalList(@ModelAttribute("common") EvalManageCodeVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> evalList = (List<HashMap<String, Object>>) commonCodeService.getEvalList(param);
			
			result.put("evalList", evalList);
			
			result.put("success", "success");
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("success", "error");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}
	

}



