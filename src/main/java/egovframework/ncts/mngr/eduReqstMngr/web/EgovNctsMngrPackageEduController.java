package egovframework.ncts.mngr.eduReqstMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsLctreOffService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrPackageEduController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrPackageEduController.class);
	
	@Autowired
	private EgovNctsMngrEduService mngrEduService;
	
	@Autowired
    private EgovNctsLctreOffService egovNctsLctreOffService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	
	
	@Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
	
	@Autowired
	private EgovNctsMngrEdcRequestService egovNctsMngrEdcRequestService;
	
	@Autowired
    private ExcelDownloadView excelDownloadView;
	
	@PreAuth(menuCd="110020101", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrPackageEduList.do")
	public String mngrPackageEduList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) mngrEduService.selectMngrEduList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		
		HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14"));//교육과정
		
		model.addAttribute("centerList", CenterList);
		model.addAttribute("rslist", rslist);
		model.addAttribute("codeMap", codeMap);
		return "mngr/eduReqstMngr/mngrEduList.ncts_content";
	}
	
	@PreAuth(menuCd="110020101", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrPackageEduForm.do")
	public String mngrEduInsert(ModelMap model, @ModelAttribute("common") MngrEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> eduResult = null;
		HashMap<String, Object> codeMap = new HashMap<>();
		
		eduResult = mngrEduService.selectEduList();
		//eduResult = egovNctsLctreOffService.selectLctreList(pageVO);
		
		
		String atchFileId = "";
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			result=mngrEduService.selectMngrEduDetail(param);
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();

		codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14"));//교육과정
		codeMap.put("NCTS50", commonCodeService.getCodeByGroup("NCTS50"));//교육주관
		model.addAttribute("eduResult", eduResult);
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("centerList", egovNctsSysDeptService.selectCenterList());
		model.addAttribute("markup", markup);
		return "mngr/eduReqstMngr/mngrPackageEduForm.ncts_content";
	}
	
}
