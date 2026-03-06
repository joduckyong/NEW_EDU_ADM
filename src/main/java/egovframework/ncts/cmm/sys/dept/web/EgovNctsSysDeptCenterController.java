package egovframework.ncts.cmm.sys.dept.web;

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
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptCenterService;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/dept")
public class EgovNctsSysDeptCenterController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysDeptCenterController.class); 
	
	@Autowired
	private EgovNctsSysDeptCenterService sysDeptCenterService;
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="90020101", pageType=PageType.LIST)
	@RequestMapping(value = "/deptCenterList.do")
	public String deptCenterList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") DeptVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysDeptCenterService.selectDeptCenterList(pageVO);
		
		model.addAttribute("rslist", rslist);
		return "cmm/sys/dept/deptCenterList.ncts_content";
	}
	
	@PreAuth(menuCd="90020101", pageType=PageType.FORM)
	@RequestMapping(value = "/deptCenterForm.do")
	public String deptCenterForm(ModelMap model, @ModelAttribute("common") DeptVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysDeptCenterService.selectDeptCenterDetail(param);
			model.addAttribute("result", result);
		}
		model.addAttribute("codeMap", codeMap);
		return "cmm/sys/dept/deptCenterForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90020101")
	@RequestMapping(value = "/deptCenterProcess.do")
	public @ResponseBody HashMap<String, Object> deptCenterProcess(@ModelAttribute DeptVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysDeptCenterService.deptCenterProcess(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
}
