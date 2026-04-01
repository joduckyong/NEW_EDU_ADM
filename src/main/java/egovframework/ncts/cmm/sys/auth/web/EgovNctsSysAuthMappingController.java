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
import egovframework.ncts.cmm.sys.auth.service.EgovNctsSysAuthMappingService;
import egovframework.ncts.cmm.sys.auth.vo.AuthMappingVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthVO;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/auth")
public class EgovNctsSysAuthMappingController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysAuthMappingController.class); 
	
	@Autowired
	private EgovNctsSysAuthMappingService sysAuthMappingService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="90030102", pageType=PageType.FORM, token=true)
	@RequestMapping(value = "/authMappingForm.do")
	public String authInsert(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") AuthMappingVO param) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthMappingService.selectAuthDeptMappingList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		
		return "cmm/sys/auth/authMappingForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90030102")
	@RequestMapping(value = "/authMappingProcess.do")
	public @ResponseBody HashMap<String, Object> authMappingProcess(@ModelAttribute DeptVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysAuthMappingService.authMappingProcess(param);
			
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
	
	@PreAuth(menuCd="90030102", pageType=PageType.MAIN)
	@RequestMapping(value = "/authGroupPopup.do")
	public String authGroupPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthMappingService.selectAuthGroupList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		
		return "cmm/sys/auth/authGroupPopup.ncts_popup";
	}
	
	@PreAuth(menuCd="90030102", pageType=PageType.POPUP)
	@RequestMapping(value = "/authDetailPopup.do")
	public String authDetailPopup(HttpServletRequest request,ModelMap model, @ModelAttribute AuthVO param,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		
		pageVO.setCenterCd(user.getCenterId());	
		String center = user.getCenterId();
		model.addAttribute("center", center);
	    if(center == "10000000"){
	    	List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthMappingService.selectAuthDetail(param);
	    	model.addAttribute("rslist", rslist);
	    }else if(center != "10000000"){
	    	List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthMappingService.selectAuthDetail2(param);
			model.addAttribute("rslist", rslist);

	    }
		return "cmm/sys/auth/authDetailPopup.ncts_popup";
	}
	
	@RequestMapping(value = "/selectAuthDetail.do")
	public @ResponseBody HashMap<String, Object> selectAuthDetail(@ModelAttribute AuthVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysAuthMappingService.selectAuthDetail(param);
			
			result.put("success", "success");
			result.put("rslist", rslist);
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
