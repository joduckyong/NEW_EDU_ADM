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
import org.springframework.web.util.CookieGenerator;

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
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEdcComplVO;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduGnrlService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduGnrlVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrEduGnrlController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduGnrlController.class);
	
	@Autowired
	private EgovNctsMngrEduGnrlService mngrEduGnrlService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
	
	@Autowired
	private EgovNctsMngrEdcRequestService egovNctsMngrEdcRequestService;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	
	
	@Autowired
    private ExcelDownloadView excelDownloadView;
	
	@PreAuth(menuCd="110020301", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrEduGnrlList.do")
	public String mngrEduGnrlList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduGnrlVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if(null != user) pageVO.setCenterCd(user.getCenterId());	
		
		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>) mngrEduGnrlService.selectMngrEduGnrlList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		
		model.addAttribute("centerList", CenterList);		
		model.addAttribute("rslist", rslist);
		return "mngr/eduReqstMngr/mngrEduGnrlList.ncts_content";
	}
	
	
	@RequestMapping(value = "/selectMngrEduGnrlDetail.do")
	public @ResponseBody HashMap<String, Object> selectMngrEduGnrlDetail(ModelMap model, @ModelAttribute MngrEduGnrlVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> rs =mngrEduGnrlService.selectMngrEduGnrlDetail(param);
			result.put("rs", rs);
			result.put("success", "success");
		}catch (IOException e) {
			LOGGER.debug(e.getMessage());
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return result;
	}
	
	@PreAuth(menuCd="110020301", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrEduGnrlForm.do")
	public String mngrEduGnrlForm(ModelMap model, @ModelAttribute("common") MngrEduGnrlVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> eduResult = null;
		HashMap<String, Object> codeMap = new HashMap<>();
		
		eduResult = mngrEduGnrlService.selectEduGnrlList();
		//eduResult = egovNctsLctreOffService.selectLctreList(pageVO);
		
		
		String atchFileId = "";
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) {
			result=mngrEduGnrlService.selectMngrEduGnrlDetail(param);
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
		return "mngr/eduReqstMngr/mngrEduGnrlForm.ncts_content";
	}
	
	@AuthCheck(menuCd="110020301")
	@RequestMapping(value = "/mngrEduGnrlProcess.do")
	public @ResponseBody HashMap<String, Object> mngrEduGnrlProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduGnrlVO param, @ModelAttribute MngrEdcInstrctrVO instrctrVO) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		CustomUser user = SessionUtil.getProperty(request);
		if(null != user) {
			param.setFrstRegisterId(user.getUserId());
			param.setLastUpdusrId(user.getUserId());
		}
		
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
			
			mngrEduGnrlService.mngrEduGnrlProcess(param);
			instrctrVO.setReqstSeq(Integer.parseInt(param.getGnrlEduSeq()));
			instrctrVO.setEduDivision(param.getEduDivision());
			mngrEduGnrlService.insertInstrctrAsign(instrctrVO);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		} catch(IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		} catch(Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}
	
	@AuthCheck(menuCd="110020301")
    @RequestMapping(value = "/updateGnrlInstrctrOthbcYnProcess.do")
    public @ResponseBody HashMap<String, Object> updateGnrlInstrctrOthbcYnProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduGnrlVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	mngrEduGnrlService.updateGnrlInstrctrOthbcYnProcess(param);
            
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
	
	@AuthCheck(menuCd="110020301")
	@RequestMapping(value = "/mngrDeleteGnrlEdu.do")
	public @ResponseBody HashMap<String, Object> mngrDeleteGnrlEdu(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduGnrlVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			mngrEduGnrlService.mngrEduGnrlProcess(param);
			
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
	
	/*@AuthCheck(menuCd="110020301")
	   @RequestMapping(value = "/tempInstrctrAsignProcess.do")
	   public @ResponseBody HashMap<String, Object> tempInstrctrAsignProcess(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrEdcTempInstrctrVO param) throws Exception{
	       HashMap<String, Object> result = new HashMap<>();
	       try {
	    	   HashMap<String, Object> rs = mngrEduGnrlService.tempInstrctrAsignProcess(param);
	    	   result.put("rs", rs);
	           result.put("success", "success");
	           result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
	       }catch (Exception e) {
	           LOGGER.debug(e.getMessage());
	           result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
	       }
		   return result;
	}*/
	

    @RequestMapping(value = "/mngrGnrlExcelDownload.do")
    public void mngrGnrlExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = mngrEduGnrlService.selectMngrGnrlExcelDownload(pageVO);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }	
    
	
}
