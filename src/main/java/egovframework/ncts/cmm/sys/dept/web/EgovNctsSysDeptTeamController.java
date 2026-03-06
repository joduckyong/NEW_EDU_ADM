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
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptTeamService;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/dept")
public class EgovNctsSysDeptTeamController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysDeptTeamController.class); 
	
	@Autowired
	private EgovNctsSysDeptTeamService sysDeptTeamService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="90020103", pageType=PageType.LIST)
	@RequestMapping(value = "/deptTeamList.do")
	public String deptTeamList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") DeptVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if("null".equals(String.valueOf(pageVO.getSearchKeyword2()))){
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
				pageVO.setCenterCd(user.getCenterId());	
		}else{ 
			pageVO.setCenterCd(pageVO.getSearchKeyword2());
		}
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysDeptTeamService.selectDeptTeamList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
		
		model.addAttribute("centerList", CenterList);
		model.addAttribute("rslist", rslist);
		return "cmm/sys/dept/deptTeamList.ncts_content";
	}
	
	@PreAuth(menuCd="90020103", pageType=PageType.FORM)
	@RequestMapping(value = "/deptTeamForm.do")
	public String deptInsert(ModelMap model, @ModelAttribute("common") DeptVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("SYS01", commonCodeService.getCodeByGroup("SYS01"));
		
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=sysDeptTeamService.selectDeptTeamDetail(param);
			model.addAttribute("result", result);
		}
		model.addAttribute("codeMap", codeMap);
		
		return "cmm/sys/dept/deptTeamForm.ncts_content";
	}
	
	@AuthCheck(menuCd="90020103")
	@RequestMapping(value = "/deptTeamProcess.do")
	public @ResponseBody HashMap<String, Object> deptTeamProcess(@ModelAttribute DeptVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysDeptTeamService.deptTeamProcess(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/selectDeptOptionList.do")
	public @ResponseBody List<HashMap<String, Object>> selectDeptOptionList(@ModelAttribute DeptVO param) {
		List<HashMap<String, Object>> rslist = null;
		
		try {
			
			rslist = (List<HashMap<String, Object>>) sysDeptTeamService.selectDeptOptionList(param);
			
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return rslist;
	}
	
	
}
