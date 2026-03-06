package egovframework.ncts.mngr.eduReqstMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
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
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrEduProgressController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduProgressController.class);
	
	@Autowired
	private EgovNctsMngrEduProgressService mngrEduProgressService;
	
	@Autowired
	private EgovNctsMngrEduService mngrEduService;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;		
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@PreAuth(menuCd="110020102", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrEduProgressList.do")
	public String mngrEduProgressList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduProgressVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) mngrEduProgressService.selectMngrEduProgressList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14"));//교육과정		
		
		model.addAttribute("centerList", CenterList);
		model.addAttribute("rslist", rslist);
		model.addAttribute("codeMap", codeMap);
		return "mngr/eduReqstMngr/mngrEduProgressList.ncts_content";
	}
	
	@RequestMapping(value = "/selectMngrEduProgressDetail.do")
	public @ResponseBody HashMap<String, Object> selectMngrEduProgressDetail(ModelMap model, @ModelAttribute MngrEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> rs = mngrEduProgressService.selectMngrEduProgressDetail(param);
			List<HashMap<String, Object>> rsList = mngrEduProgressService.selectMngrEduApplicantList(param);

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
	
	@PreAuth(menuCd="110020102", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrEduProgressForm.do")
	public String mngrEduProgressInsert(ModelMap model, @ModelAttribute("common") MngrEduProgressVO param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		
		String atchFileId = "";
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			result=mngrEduProgressService.selectMngrEduProgressDetail(param);
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();
		
		model.addAttribute("centerList", egovNctsSysDeptService.selectCenterList());
		model.addAttribute("markup", markup);
		return "mngr/eduReqstMngr/mngrEduProgressForm.ncts_content";
	}
	
	@PreAuth(menuCd="110020102", pageType=PageType.LIST)
	@RequestMapping(value = "/selectMngrEduListPopup.do")
	public String reseListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) mngrEduService.selectMngrEduList(pageVO);
		
		model.addAttribute("rslist", rslist);
		return "mngr/eduReqstMngr/mngrEduListPopup.ncts_popup";
	}
	
	@AuthCheck(menuCd="110020102")
	@RequestMapping(value = "/mngrEduProgressProcess.do")
	public @ResponseBody HashMap<String, Object> mngrEduProgressProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			if (ProcType.isFindFileUpload(param.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("eduProgress")     // 저장위치
						.keyStr("eduProgress_") // 파일명키
						.procType(ProcType.findByProcType(param.getProcType()))
						.atchFileId(param.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
			}
			
			mngrEduProgressService.mngrEduProgressProcess(param);
			
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
	
	@AuthCheck(menuCd="110020102")
	@RequestMapping(value = "/mngrDeleteEduProgress.do")
	public @ResponseBody HashMap<String, Object> mngrDeleteEduProgress(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			mngrEduProgressService.mngrEduProgressProcess(param);
			
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
	
	@AuthCheck(menuCd="110020102")
	@RequestMapping(value = "/updateComplProgress.do")
	public @ResponseBody HashMap<String, Object> updateComplProgress(HttpServletRequest reqeust, ModelMap model, @ModelAttribute MngrEduProgressVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
	    CustomUser customUser = SessionUtil.getProperty(reqeust);
	    if(null != customUser) param.setUserId(customUser.getUserId());
		try {
			mngrEduProgressService.updateComplProgress(param);
			
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
}
