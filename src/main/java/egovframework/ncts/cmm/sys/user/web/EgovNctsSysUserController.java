package egovframework.ncts.cmm.sys.user.web;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
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
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.user.service.EgovNctsSysUserService;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/user")
public class EgovNctsSysUserController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysUserController.class);
	
	@Autowired
	private EgovNctsSysUserService sysUserService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="90020201", pageType=PageType.LIST)
	@RequestMapping(value = "/userList.do")
	public String userList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") UserVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysUserService.selectUserList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		return "cmm/sys/user/userList.ncts_content";
	}
	
	@PreAuth(menuCd="90020201", pageType=PageType.FORM)
	@RequestMapping(value = "/userForm.do")
	public String userInsert(ModelMap model, @ModelAttribute("common") UserVO param) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Collection<? extends GrantedAuthority>  authorities = authentication.getAuthorities();
		for(GrantedAuthority vo : authorities){
			model.addAttribute("userRoleNm", vo.getAuthority());
		}
		
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		codeMap.put("SYS02", commonCodeService.getCodeByGroup("SYS02"));
		codeMap.put("SYS03", commonCodeService.getCodeByGroup("SYS03"));
		codeMap.put("NCTS10", commonCodeService.getCodeByGroup("NCTS10"));
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysUserService.selectUserDetail(param);
			model.addAttribute("result", result);
		}
		
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		model.addAttribute("centerList", centerList);
		model.addAttribute("codeMap", codeMap);
		
		return "cmm/sys/user/userForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90020201")
	@RequestMapping(value = "/userProcess.do")
	public @ResponseBody HashMap<String, Object> userProcess(ModelMap model, @ModelAttribute UserVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		try {
			sysUserService.userProcess(param);
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}

	
	@AuthCheck(menuCd="90020201")
	@RequestMapping(value = "/userInitPwd.do")
	public @ResponseBody HashMap<String, Object> userInitPwd(ModelMap model, @ModelAttribute UserVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		try {
			sysUserService.userInitPwd(param);
			result.put("success", "success");
			result.put("msg", "패스워드를 초기화했습니다.");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", "패스워드 초기화에 실패하였습니다.\n관리자에게 문의해주세요.");
		}
		
		return result;
	}
}
