package egovframework.ncts.mngr.eduReqstMngr.web;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrDtyEduProgressController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDtyEduProgressController.class);
	
	@Autowired
	private EgovNctsMngrDtyEduProgressService mngrDtyEduProgressService;
	
	@Autowired
	private EgovNctsMngrDtyEduService egovNctsMngrDtyEduService;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;		
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="110120102", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrDtyEduProgressList.do")
	public String mngrDtyEduProgressList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrDtyEduProgressVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) mngrDtyEduProgressService.selectMngrDtyEduProgressList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		List<HashMap<String, Object>> packageList = (List<HashMap<String, Object>>) egovNctsMngrDtyEduService.selectDtyEduList();
		
		HashMap<String, Object> codeMap = new HashMap<>();
		
		model.addAttribute("rslist", rslist);
		model.addAttribute("centerList", centerList);
		model.addAttribute("packageList", packageList);
		model.addAttribute("codeMap", codeMap);
		return "mngr/eduReqstMngr/mngrDtyEduProgressList.ncts_content";
	}
	
	@RequestMapping(value = "/selectMngrDtyEduProgressDetail.do")
	public @ResponseBody HashMap<String, Object> selectMngrDtyEduProgressDetail(ModelMap model, @ModelAttribute MngrDtyEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> rs = mngrDtyEduProgressService.selectMngrDtyEduProgressDetail(param);
			if(null == param.getLectureId() || "".equals(param.getLectureId())) {
				String lectureId = String.valueOf(rs.get("LECTURE_ID")).split("[|]")[0];
				param.setLectureId(lectureId);
			}
			param.setPackageNo(String.valueOf(rs.get("PACKAGE_NO")));
			List<HashMap<String, Object>> rsList = mngrDtyEduProgressService.selectMngrDtyEduApplicantList(param);

			result.put("rs", rs);
			result.put("rsList", rsList);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="110120102")
	@RequestMapping(value = "/updateDtyComplProgress.do")
	public @ResponseBody HashMap<String, Object> updateDtyComplProgress(HttpServletRequest reqeust, ModelMap model, @ModelAttribute MngrDtyEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
	    CustomUser customUser = SessionUtil.getProperty(reqeust);
	    if(null != customUser) param.setUserId(customUser.getUserId());		
		try {
			mngrDtyEduProgressService.updateDtyComplProgress(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="110120102")
	@RequestMapping(value = "/packageCertificateProgress.do")
	public @ResponseBody HashMap<String, Object> packageCertificateProgress(HttpServletRequest reqeust, ModelMap model, @ModelAttribute MngrDtyEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		CustomUser customUser = SessionUtil.getProperty(reqeust);
		if(null != customUser) param.setUserId(customUser.getUserId());		
		param.setActiveType("COMPL");
		try {
			mngrDtyEduProgressService.packageCertificateProgress(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/complAutoCheck.do")
	public @ResponseBody HashMap<String, Object> complAutoCheck(HttpServletRequest reqeust, ModelMap model, @ModelAttribute MngrDtyEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		CustomUser customUser = SessionUtil.getProperty(reqeust);
		if(null != customUser) param.setUserId(customUser.getUserId());		
		try {
			List<HashMap<String, Object>> rslist = mngrDtyEduProgressService.complAutoCheck(param);
			
			result.put("success", "success");
			result.put("rslist", rslist);
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
}
