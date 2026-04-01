package egovframework.ncts.cmm.sys.center.web;

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
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.center.service.EgovNctsSysCenterService;
import egovframework.ncts.cmm.sys.center.vo.DeptVO;
import egovframework.ncts.cmm.sys.user.service.EgovNctsSysUserService;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/center")
public class EgovNctsSysCenterController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysCenterController.class); 
	
	@Autowired
	private EgovNctsSysCenterService sysCenterService;
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private EgovNctsSysUserService sysUserService;
	
	
	@PreAuth(menuCd="90020401", pageType=PageType.LIST)
	@RequestMapping(value = "/centerList.do")
	public String centerList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") DeptVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysCenterService.selectCenterList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("rslist", rslist);
		model.addAttribute("centerList", centerList);
		return "cmm/sys/center/centerList.ncts_content";
	}
	
	@PreAuth(menuCd="90020401", pageType=PageType.FORM)
	@RequestMapping(value = "/centerForm.do")
	public String centerForm(ModelMap model, @ModelAttribute("common") DeptVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		List<HashMap<String, Object>> authList = (List<HashMap<String, Object>>) sysCenterService.selectAuthList();
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysCenterService.selectCenterDetail(param);
			model.addAttribute("result", result);
		}
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("authList", authList);
		return "cmm/sys/center/centerForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90020401")
	@RequestMapping(value = "/centerProcess.do")
	public @ResponseBody HashMap<String, Object> centerProcess(@ModelAttribute DeptVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysCenterService.centerProcess(param);
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
	
	@PreAuth(menuCd="90020402", pageType=PageType.LIST)
	@RequestMapping(value = "/manageList.do")
	public String manageList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") UserVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if("null".equals(String.valueOf(pageVO.getSearchKeyword1()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{
			pageVO.setCenterCd(pageVO.getSearchKeyword1());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysCenterService.selectUserList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", centerList);
		model.addAttribute("rslist", rslist);
		return "cmm/sys/center/manageList.ncts_content";
	}
	
	@PreAuth(menuCd="90020402", pageType=PageType.FORM)
	@RequestMapping(value = "/manageForm.do")
	public String manageForm(ModelMap model, @ModelAttribute("common") UserVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		List<HashMap<String, Object>> authList = (List<HashMap<String, Object>>) sysCenterService.selectAuthList();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		codeMap.put("SYS02", commonCodeService.getCodeByGroup("SYS02"));
		codeMap.put("SYS03", commonCodeService.getCodeByGroup("SYS03"));
		codeMap.put("NCTS10", commonCodeService.getCodeByGroup("NCTS10"));
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysCenterService.selectUserDetail(param);
			model.addAttribute("result", result);
		}
		model.addAttribute("authList", authList);
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("centerList", centerList);
		return "cmm/sys/center/manageForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90020402")
	@RequestMapping(value = "/deletemanageList.do")
	public @ResponseBody HashMap<String, Object> deletemanageList(ModelMap model, @ModelAttribute UserVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		try {
			sysCenterService.userProcess(param);
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
	
	@AuthCheck(menuCd="90020402")
	@RequestMapping(value = "/manageProcess.do")
	public @ResponseBody HashMap<String, Object> manageProcess(ModelMap model, @ModelAttribute UserVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		try {
			sysCenterService.userProcess(param);
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
	
	@RequestMapping(value="/selectUserIdDupChk.do")
	public @ResponseBody HashMap<String, Object> selectreginoDupChk(HttpServletRequest request, ModelMap model,@ModelAttribute UserVO param ) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			 HashMap<String, Object> rs = sysCenterService.selectUserIdDupChk(param);
			  if(null == rs){
			    	 result.put("rsType", "01");
		     }else {
		    	 result.put("rsType", "02");
		     }
			 result.put("rs", rs);
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
