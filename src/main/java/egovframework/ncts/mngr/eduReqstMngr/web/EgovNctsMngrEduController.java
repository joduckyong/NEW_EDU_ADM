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
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrEduController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduController.class);
	
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
	private EgovNctsMngrDtyEduProgressService egovNctsMngrDtyEduProgressService;
	
	@Autowired
    private ExcelDownloadView excelDownloadView;
	
	@PreAuth(menuCd="110020101", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrEduList.do")
	public String mngrEduList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
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
	
	@RequestMapping(value = "/selectMngrEduDetail.do")
	public @ResponseBody HashMap<String, Object> selectMngrEduDetail(ModelMap model, @ModelAttribute MngrEduVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		MngrEduApplicantVO param2 = new MngrEduApplicantVO();
		try {
			HashMap<String, Object> rs =mngrEduService.selectMngrEduDetail(param);
			param2.setEduSeq(param.getEduSeq());
			List<HashMap<String, Object>> rsList =mngrEduService.selectMngrEduApplicantList(param2);
			
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
	
	@PreAuth(menuCd="110020101", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrEduForm.do")
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
		return "mngr/eduReqstMngr/mngrEduForm.ncts_content";
	}
	
	@RequestMapping(value = "/selectRegEduAplcStatus.do")
	public @ResponseBody HashMap<String, Object> selectRegEduAplcStatus(ModelMap model, @ModelAttribute MngrEduVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> rs = mngrEduService.selectRegEduAplcStatus(param);
			
			result.put("rs", rs);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	@RequestMapping(value = "/mngrEduAppliAddPopup.do")
	public String mngrEduAppliAddPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduApplicantVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> codeMap = new HashMap<>();
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		String atchFileId = "";
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(false)
                .atchFileId(atchFileId)
                .fileTotal(1)
                .build();
		model.addAttribute("markup", markup);
		
		codeMap.put("DMH07", egovNctsMngrMemberService.getCodeByGroupField("DMH07")); // 지역
		codeMap.put("DMH05", egovNctsMngrMemberService.getCodeByGroupLicense()); // 자격
		model.addAttribute("codeMap", codeMap);
		
		return "mngr/eduReqstMngr/mngrEduAppliAddPopup.ncts_popup";
	}
	
	@RequestMapping(value = "/mngrEduAppliListPopup.do")
    public String mngrEduAppliListPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
	   List<HashMap<String, Object>> list = egovNctsMngrMemberService.selectMngrMemberList(pageVO);
	   model.addAttribute("list",list);
	   return "mngr/eduReqstMngr/mngrEduAppliListPopup.ncts_popup";
    }
	
	@RequestMapping(value = "/selectMngrEduApplicantList.do")
	public @ResponseBody HashMap<String, Object> selectMngrEduApplicantList(ModelMap model, @ModelAttribute MngrEduApplicantVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> rsList =mngrEduService.selectMngrEduApplicantList(param);

			result.put("rsList", rsList);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	@RequestMapping(value = "/mngrEduInstrctrAppliListPopup.do")
	public String mngrEduInstrctrAppliListPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		/*pageVO.setBoardType("J");*/
		if(null != pageVO.getPageType() && "dtyEdu".equals(pageVO.getPageType())) {
				MngrDtyEduProgressVO dtyEduVO = new MngrDtyEduProgressVO();
				if(null != pageVO.getEduSeq() && !"".equals(pageVO.getEduSeq())) dtyEduVO.setEduSeq(pageVO.getEduSeq());
				else if(null != pageVO.getLectureId() && !"".equals(pageVO.getLectureId())) dtyEduVO.setLectureId(pageVO.getLectureId());
				
				List<HashMap<String, Object>> lectureIds = egovNctsMngrDtyEduProgressService.selectPackageDetailCodeList(dtyEduVO);
				model.addAttribute("lectureIds",lectureIds);
				
				if(null == pageVO.getCertCd() || "".equals(pageVO.getCertCd())) pageVO.setCertCd(lectureIds.get(0).get("LECTURE_ID").toString());
		}
		
		List<HashMap<String, Object>> list = egovNctsMngrEdcRequestService.selectMngrEdcInstrctrAsignList(pageVO);
		model.addAttribute("list",list);
		return "mngr/eduReqstMngr/mngrEduInstrctrAppliListPopup.ncts_popup";
	}
	
	@RequestMapping(value = "/selectInstrctrOriList.do")
	public @ResponseBody HashMap<String, Object> selectInstrctrOriList(ModelMap model, @ModelAttribute MngrEdcInstrctrVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> rslist = mngrEduService.selectInstrctrOriList(param);
			result.put("rslist", rslist);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	@RequestMapping(value = "/selectTempInstrctrList.do")
	public @ResponseBody HashMap<String, Object> selectTempInstrctrList(ModelMap model, @ModelAttribute MngrEdcTempInstrctrVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> rslist = mngrEduService.selectTempInstrctrList(param);
			result.put("rslist", rslist);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="110020101")
	@RequestMapping(value = "/mngrEduProcess.do")
	public @ResponseBody HashMap<String, Object> mngrEduProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduVO param, @ModelAttribute MngrEdcInstrctrVO instrctrVO) throws Exception{
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
			
			mngrEduService.mngrEduProcess(param);
			instrctrVO.setReqstSeq(Integer.parseInt(param.getEduSeq()));
			instrctrVO.setEduDivision(param.getEduDivision());
			mngrEduService.insertInstrctrAsign(instrctrVO);
			
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
	
	@AuthCheck(menuCd="110020101")
    @RequestMapping(value = "/updateInstrctrOthbcYnProcess.do")
    public @ResponseBody HashMap<String, Object> updateInstrctrOthbcYnProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	mngrEduService.updateInstrctrOthbcYnProcess(param);
            
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
	
	@AuthCheck(menuCd="110020101")
	@RequestMapping(value = "/mngrDeleteEdu.do")
	public @ResponseBody HashMap<String, Object> mngrDeleteEdu(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			mngrEduService.mngrEduProcess(param);
			
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
	
	@AuthCheck(menuCd="110020101")
	   @RequestMapping(value = "/tempInstrctrAsignProcess.do")
	   public @ResponseBody HashMap<String, Object> tempInstrctrAsignProcess(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrEdcTempInstrctrVO param) throws Exception{
	       HashMap<String, Object> result = new HashMap<>();
	       try {
	    	   HashMap<String, Object> rs = mngrEduService.tempInstrctrAsignProcess(param);
	    	   result.put("rs", rs);
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
	
	@RequestMapping(value = "/mngrEduApplicantProcess.do")
	public @ResponseBody HashMap<String, Object> mngrEduApplicantProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduApplicantVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		String msg = ProcessMessageSource.newInstance().getMsg(param.getProcType());
		try {
			if (ProcType.isFindFileUpload(param.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("eduAppli")     // 저장위치
						.keyStr("eduAppli_") // 파일명키
						.procType(ProcType.findByProcType(param.getProcType()))
						.atchFileId(param.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
			}
			
			String rs = mngrEduService.mngrEduApplicantProcess(param);
			
			if("N".equals(rs)) msg = "중복된 신청자입니다.";
			result.put("rs", rs);
			result.put("success", "success");
			result.put("msg", msg);
			
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/mngrEduApplicantUpdateProcess.do")
	public @ResponseBody HashMap<String, Object> mngrEduApplicantUpdateProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduApplicantVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			mngrEduService.mngrEduApplicantProcess(param);
			
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
	
	@RequestMapping(value = "/mngrEduApplicantDownload.do")
    public void mngrEduApplicantDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrEduApplicantVO param) throws Exception {
    	HashMap<String, Object> rsMap = mngrEduService.mngrEduApplicantDownload(param);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
}
