package egovframework.ncts.cmm.sys.auth.web;

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
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthStaffMappingService;
import egovframework.ncts.cmm.sys.auth.vo.AuthMappingVO;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/auth")
public class EgovNctsSysAuthStaffMappingController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthStaffMappingController.class); 
	
	@Autowired
	private EgovNctsSysAuthStaffMappingService sysAuthStaffMappingService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="90030103", pageType=PageType.FORM, token=true)
	@RequestMapping(value = "/authStaffMappingForm.do")
	public String authInsert(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") AuthMappingVO param) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthStaffMappingService.selectAuthStaffMappingList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		
		return "cmm/sys/auth/authStaffMappingForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90030103")
	@RequestMapping(value = "/authStaffMappingProcess.do")
	public @ResponseBody HashMap<String, Object> authStaffMappingProcess(@ModelAttribute UserVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysAuthStaffMappingService.authMappingProcess(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="90030103")
	@RequestMapping(value = "/insertDeleteAuthRcord.do")
	public @ResponseBody HashMap<String, Object> insertDeleteAuthRcord(@ModelAttribute UserVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysAuthStaffMappingService.insertDeleteAuthRcord(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType())); 
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
}
