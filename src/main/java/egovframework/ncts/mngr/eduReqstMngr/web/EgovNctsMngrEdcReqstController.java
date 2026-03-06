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
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduRequstApplicantVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrEdcReqstController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEdcReqstController.class);
    
    @Autowired
    private EgovNctsMngrEdcRequestService egovNctsMngrEdcRequestService;
    
    @Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @Autowired
	private CommonCodeService commonCodeService;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110020201", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrEdcReqstList.do")
    public String selectMngrEdcReqstList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) if(null != user) pageVO.setCenterCd(user.getCenterId());	    	
        List<HashMap<String, Object>> list = null;
        list = egovNctsMngrEdcRequestService.selectMngrEdcRequestList(pageVO);
        List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        model.addAttribute("list", list);
        model.addAttribute("centerList", centerList);
        return "mngr/eduReqstMngr/mngrEdcReqstList.ncts_content";
    }
    
   @RequestMapping(value = "/mngrEdcReqstDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrEdcReqstDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrEdcRequestService.selectMngrEdcReqstDetail(param);
        List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequestService.selectMngrEduReqstApplicantList(param);
        /*param.setPageType("F");
        List<HashMap<String, Object>> rslist2 = egovNctsMngrEdcRequestService.selectMngrEduReqstApplicantList(param);*/
        result.put("de", de);
        result.put("rslist", rslist);
        /*result.put("rslist2", rslist2);*/
        result.put("success", "success");
        
        return result;
    }
   
   @PreAuth(menuCd="110020201", pageType=PageType.FORM)
	@RequestMapping(value = "/mngrEdcReqstForm.do")
	public String mngrEdcReqstForm(ModelMap model, @ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> codeMap = new HashMap<>();
		
		String referMatterFile = "";
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		List<HashMap<String, Object>> codeList = egovNctsMngrEdcRequestService.selectIrregEduList();
		if (ProcType.UPDATE.equals(procType)) {
			result=egovNctsMngrEdcRequestService.selectMngrEdcReqstDetail(param);
			referMatterFile = StringUtils.defaultIfEmpty((String) result.get("REFER_MATTER_FILE"), "");
			model.addAttribute("result", result);
		}
		
		StringBuffer markup = FileUploadMarkupBuilder.newInstance()
               .fileDownYn(true)
               .btnYn(true)
               .atchFileId(referMatterFile)
               .fileTotal(5)
               .build();
		
		codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));

		model.addAttribute("codeMap", codeMap);
		model.addAttribute("codeList", codeList);
		model.addAttribute("centerList", egovNctsSysDeptService.selectCenterList());
		model.addAttribute("markup", markup);
		return "mngr/eduReqstMngr/mngrEdcReqstForm.ncts_content";
	}
   
    @AuthCheck(menuCd="110020201")
    @RequestMapping(value = "/mngrEduReqstProcess.do")
//	public @ResponseBody HashMap<String, Object> mngrEduReqstProcess(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute MngrEdcRequestVO param) throws Exception{
   	public @ResponseBody HashMap<String, Object> mngrEduReqstProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEdcRequestVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		
		try {
//			if (ProcType.isFindFileUpload(param.getProcType())) {
//				String referMatterFile = FileUploadBuilder
//						.getInstance()
//						.multiRequest(multiRequest)
//						.storePath("edu")     // 저장위치
//						.keyStr("edu_") // 파일명키
//						.procType(ProcType.findByProcType(param.getProcType()))
//						.atchFileId(param.getReferMatterFile())
//						.fileKey(0)
//						.build();
//				
//				if(!"".equals(referMatterFile)) param.setReferMatterFile(referMatterFile);
//			}
			egovNctsMngrEdcRequestService.mngrEduReqstProcess(param);
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
   
   @RequestMapping(value = "/mngrEduReqstListPopup.do")
    public String mngrEduReqstListPopup (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcRequestVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
	   //pageVO.setsGubun1("04");
	   pageVO.setEduSeq(param.getReqstSeq());
	   List<HashMap<String, Object>> list = egovNctsMngrEdcRequestService.selectMngrEdcInstrctrAsignList(pageVO);
	   model.addAttribute("list",list);
	   return "mngr/eduReqstMngr/mngrEduReqstListPopup.ncts_popup";
    }
   
   /*@AuthCheck(menuCd="110020201")*/
   @RequestMapping(value = "/instrctrAsignProcess.do")
   public @ResponseBody HashMap<String, Object> instrctrAsignProcess(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrEdcInstrctrVO param) throws Exception{
       HashMap<String, Object> result = new HashMap<>();
       try {
    	   HashMap<String, Object> rs = egovNctsMngrEdcRequestService.instrctrAsignProcess(param);
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
   
   @AuthCheck(menuCd="110020201")
   @RequestMapping(value = "/mngrEduReqstApplicantProcess.do")
   public @ResponseBody HashMap<String, Object> MngrEduReqstApplicantProcess(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrEduRequstApplicantVO param) throws Exception{
	   HashMap<String, Object> result = new HashMap<>();
	   
	   try {
		   ProcType procType = ProcType.findByProcType(param.getProcType());
		   String msg = ProcessMessageSource.newInstance().getMsg(param.getProcType());
		   
		   if(ProcType.UPDATE.equals(procType)) {
			   if("Y".equalsIgnoreCase(param.getApplStat())){
				   param.setApplStat("F");
				   msg = "불참으로 변경하였습니다.";
			   } else if("F".equalsIgnoreCase(param.getApplStat())){
				   param.setApplStat("Y");
				   msg = "참석으로 변경하였습니다.";
			   } else {
				   msg = ProcessMessageSource.newInstance().getMsg(param.getProcType());
			   }
		   } 
		   egovNctsMngrEdcRequestService.MngrEduReqstApplicantProcess(param);
		   
		   result.put("msg", msg);
		   result.put("success", "success");
	   }catch (IOException e) {
		   LOGGER.debug(e.getMessage());
		   if(e.getMessage().equals("01")) result.put("msg", "일치하는 회원이 없습니다.");
		   else result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
	   }catch (Exception e) {
		   LOGGER.debug(e.getMessage());
		   if(e.getMessage().equals("01")) result.put("msg", "일치하는 회원이 없습니다.");
		   else result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
       }
	   return result;
   }
    
    
    @AuthCheck(menuCd="110020201")
    @RequestMapping(value = "/updateApplAtProcess.do")
    public @ResponseBody HashMap<String, Object> updateApplAtProcess(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEdcRequestVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrEdcRequestService.updateApplAtProcess(param);
            
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
    

    @RequestMapping(value = "/mngrEdcRequsetDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrEdcRequestVO vo) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrEdcRequestService.selectCommonExcel(vo);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    
    @RequestMapping(value = "/mngrEdcRequsetApplicantDownload.do")
    public void mngrEdcRequsetApplicantDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> rsMap = egovNctsMngrEdcRequestService.mngrEdcRequsetApplicantDownload(pageVO);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    
    @AuthCheck(menuCd="110020201")
	@RequestMapping(value = "/updateReqstComplProgress.do")
	public @ResponseBody HashMap<String, Object> updateReqstComplProgress(HttpServletRequest reqeust, ModelMap model, @ModelAttribute MngrEduRequstApplicantVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			egovNctsMngrEdcRequestService.updateReqstComplProgress(reqeust, param);
			
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
    
    @RequestMapping(value = "/mngrEdcRequsetUpdateCenterListPopup.do")
    public String mngrEdcRequsetUpdateCenterListPopup(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
	   List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequestService.selectReqstCenterRecordList(pageVO);
	   model.addAttribute("rslist",rslist);
	   return "mngr/eduReqstMngr/mngrEdcRequsetUpdateCenterListPopup.ncts_popup";
    }    
    
}