package egovframework.ncts.cmm.sys.user.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.vo.DeptVO;
import egovframework.ncts.cmm.sys.user.service.EgovNctsSysUserMappingService;
import egovframework.ncts.cmm.sys.user.vo.UserVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/user")
public class EgovNctsSysUserMappingController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysUserMappingController.class);
	
	@Autowired
	private EgovNctsSysUserMappingService sysUserMappingService;
	
	@PreAuth(menuCd="90020301", pageType=PageType.FORM, token=true)
	@RequestMapping(value = "/userMappingForm.do")
	public String userInsert(ModelMap model, @ModelAttribute("common") UserVO param) throws Exception {
		
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) sysUserMappingService.selectCenterList();
		model.addAttribute("centerList", CenterList);
		
		return "cmm/sys/user/userMappingForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectDeptList.do")
	public @ResponseBody HashMap<String, Object> selectDeptList(@ModelAttribute DeptVO param)  throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysUserMappingService.selectDeptList(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
			result.put("rslist", rslist);
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/selectUserList.do")
	public @ResponseBody HashMap<String, Object> selectUserList(@ModelAttribute PageInfoVO param)  throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysUserMappingService.selectUserList(param);
			
			result.put("success", "success");
			result.put("msg", "성공");
			result.put("rslist", rslist);
		} catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", "실패");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", "실패");
		}
		
		return result;
	}
	
	@RequestMapping(value = "/selectDeptUserList.do")
	public @ResponseBody HashMap<String, Object> selectDeptUserList(@ModelAttribute PageInfoVO param)  throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) sysUserMappingService.selectDeptUserList(param);
			
			result.put("success", "success");
			result.put("msg", "성공");
			result.put("rslist", rslist);
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("msg", "실패");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", "실패");
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="90020301")
	@RequestMapping(value = "/deptMappingUser.do")
	public @ResponseBody HashMap<String, Object> deptMappingUser(@ModelAttribute UserVO param)  throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysUserMappingService.updateMappingUser(param);
			
			
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
	
	@AuthCheck(menuCd="90020301")
	@RequestMapping(value = "/deptEmptyUser.do")
	public @ResponseBody HashMap<String, Object> deptEmptyUser(@ModelAttribute UserVO param)  throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			sysUserMappingService.updateEmptyUser(param);
			
			
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
