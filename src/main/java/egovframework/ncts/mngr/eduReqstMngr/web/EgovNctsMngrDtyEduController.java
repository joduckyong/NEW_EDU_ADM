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
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrDtyEduController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDtyEduController.class);
	
	@Autowired
	private EgovNctsMngrDtyEduService egovNctsMngrDtyEduService;
	
	@Autowired
	private EgovNctsMngrEduService egovNctsMngrEduService;
	
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
	
	@PreAuth(menuCd="110120101", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrDtyEduList.do")
	public String mngrDtyEduList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrDtyEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) egovNctsMngrDtyEduService.selectMngrDtyEduList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		List<HashMap<String, Object>> packageList = (List<HashMap<String, Object>>) egovNctsMngrDtyEduService.selectDtyEduList();
		
		HashMap<String, Object> codeMap = new HashMap<>();
		
		model.addAttribute("centerList", CenterList);
		model.addAttribute("rslist", rslist);
		model.addAttribute("packageList", packageList);
		model.addAttribute("codeMap", codeMap);
		return "mngr/eduReqstMngr/mngrDtyEduList.ncts_content";
	}
	
	@RequestMapping(value = "/selectMngrDtyEduDetail.do")
	public @ResponseBody HashMap<String, Object> selectMngrDtyEduDetail(ModelMap model, @ModelAttribute MngrDtyEduVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		MngrDtyEduApplicantVO param2 = new MngrDtyEduApplicantVO();
		try {
			HashMap<String, Object> rs = egovNctsMngrDtyEduService.selectMngrDtyEduDetail(param);
			param2.setEduSeq(param.getEduSeq());
			List<HashMap<String, Object>> rsList = egovNctsMngrDtyEduService.selectMngrDtyEduApplicantList(param2);
			
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
	
	@PreAuth(menuCd="110120101", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrDtyEduForm.do")
	public String mngrEduInsert(ModelMap model, @ModelAttribute("common") MngrDtyEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> eduResult = null;
		HashMap<String, Object> codeMap = new HashMap<>();
		
		eduResult = egovNctsMngrDtyEduService.selectDtyEduList();
		//eduResult = egovNctsLctreOffService.selectLctreList(pageVO);
		
		
		String atchFileId = "";
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			result=egovNctsMngrDtyEduService.selectMngrDtyEduDetail(param);
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();

		codeMap.put("NCTS50", commonCodeService.getCodeByGroup("NCTS50"));//교육주관
		model.addAttribute("eduResult", eduResult);
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("centerList", egovNctsSysDeptService.selectCenterList());
		model.addAttribute("markup", markup);
		return "mngr/eduReqstMngr/mngrDtyEduForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectMngrDtyEduApplicantList.do")
	public @ResponseBody HashMap<String, Object> selectMngrDtyEduApplicantList(ModelMap model, @ModelAttribute MngrDtyEduApplicantVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> rsList =egovNctsMngrDtyEduService.selectMngrDtyEduApplicantList(param);

			result.put("rsList", rsList);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	
	@AuthCheck(menuCd="110120101")
	@RequestMapping(value = "/mngrDtyEduProcess.do")
	public @ResponseBody HashMap<String, Object> mngrDtyEduProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrDtyEduVO param, @ModelAttribute MngrEdcInstrctrVO instrctrVO) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			if (ProcType.isFindFileUpload(param.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("edu")     // 저장위치
						.keyStr("edu_") // 파일명키
						.procType(ProcType.findByProcType(param.getProcType()))
						.atchFileId(param.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
			}
			
			egovNctsMngrDtyEduService.mngrDtyEduProcess(param);
			instrctrVO.setReqstSeq(Integer.parseInt(param.getEduSeq()));
			instrctrVO.setEduDivision(param.getEduDivision());
			instrctrVO.setOriEduDivision(param.getOriEduDivision());
			egovNctsMngrEduService.insertInstrctrAsign(instrctrVO);
			
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
	
	@AuthCheck(menuCd="110120101")
    @RequestMapping(value = "/updateDtyInstrctrOthbcYnProcess.do")
    public @ResponseBody HashMap<String, Object> updateDtyInstrctrOthbcYnProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrDtyEduVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsMngrDtyEduService.updateDtyInstrctrOthbcYnProcess(param);
            
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
	
	@AuthCheck(menuCd="110120101")
	@RequestMapping(value = "/mngrDtyDeleteEdu.do")
	public @ResponseBody HashMap<String, Object> mngrDtyDeleteEdu(HttpServletRequest request,ModelMap model, @ModelAttribute MngrDtyEduVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			egovNctsMngrDtyEduService.mngrDtyEduProcess(param);
			
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
	
	@RequestMapping(value = "/mngrDtyEduApplicantDownload.do")
    public void mngrDtyEduApplicantDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrDtyEduApplicantVO param) throws Exception {
    	HashMap<String, Object> rsMap = egovNctsMngrDtyEduService.mngrDtyEduApplicantDownload(param);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
}
