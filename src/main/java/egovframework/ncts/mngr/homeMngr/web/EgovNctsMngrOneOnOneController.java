package egovframework.ncts.mngr.homeMngr.web;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrOneOnOneService;
import egovframework.ncts.mngr.homeMngr.vo.MngrOneOnOneVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrOneOnOneController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrOneOnOneController.class);
    
    @Autowired
    private EgovNctsMngrOneOnOneService egovNctsMngrOneOnOneService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110050701", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrOneOnOneList.do")
    public String selectOneOnOneList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrOneOnOneVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) if(null != user) pageVO.setCenterCd(user.getCenterId());
		
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		
        List<HashMap<String, Object>> list = null;
        List<HashMap<String, Object>> commonList  = null;
        commonList = commonCodeService.getCodeByGroup("DMH13");
        
        for(int i = 0; i < commonList.size() ; i++){
            if(1 >= Integer.parseInt((String) commonList.get(i).get("CODE"))){
                commonList.remove(i);
            }
        }
        try{
            list = egovNctsMngrOneOnOneService.selectOneOnOneList(pageVO);
        }catch(IOException e){
            LOGGER.debug(e.getMessage());
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
        }
        
        model.addAttribute("list", list);
        model.addAttribute("code", commonList);
        model.addAttribute("centerList", centerList);

        return "mngr/homeMngr/mngrOneOnOneList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrOneOnOneDetail.do")
    public @ResponseBody HashMap<String, Object> selectOneOnOneDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrOneOnOneVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            HashMap<String, Object> de = egovNctsMngrOneOnOneService.selectOneOnOneDetail(param);
            result.put("de", de);
            result.put("success", "success");
        } catch (IOException e) {
        	LOGGER.debug(e.getMessage());
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
        }
        
        return result;
    }
    
    @RequestMapping(value = "/mngrOneOnOneAnswer.do")
    public @ResponseBody HashMap<String, Object> mngrBbsAnswerManage(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrOneOnOneVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            egovNctsMngrOneOnOneService.mngrOneOnOneAnswer(request, param);
            
            result.put("success", "success");
            result.put("msg", "저장되었습니다.");
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }

        return result;
    }
    
    
    @AuthCheck(menuCd="110050701")
    @RequestMapping(value = "/mngrDeleteOneOnOne.do")
    public @ResponseBody HashMap<String, Object> delBbsManage(HttpServletRequest request,ModelMap model, @ModelAttribute MngrOneOnOneVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrOneOnOneService.delAnswerManage(param);
            
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
    
    
    @PreAuth(menuCd="110050701", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrOneOnOneForm.do")
    public String mngrBbsManageForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrOneOnOneVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        String atchFileId = "";
        HashMap<String, Object> result = new HashMap<>();
        
        List<HashMap<String, Object>> commonList  = null;
        commonList = commonCodeService.getCodeByGroup("DMH13");
        
        for(int i = 0; i < commonList.size() ; i++){
            if(1 >= Integer.parseInt((String) commonList.get(i).get("CODE"))){
                commonList.remove(i);
            }
        }
        
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrOneOnOneService.selectOneOnOneDetail(param);
            atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
            model.addAttribute("result", result);
        }
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();
        model.addAttribute("markup", markup);
        result.put("DMH13", commonList);
        return "mngr/homeMngr/mngrOneOnOneForm.ncts_content";
    }
    
    
    @AuthCheck(menuCd="110050701")
    @RequestMapping(value = "/mngrProgressOneOnOne.do")
    public @ResponseBody HashMap<String, Object> mngrProgressOneOnOne(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrOneOnOneVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            if (ProcType.isFindFileUpload(param.getProcType())) {
                String atchFileId = FileUploadBuilder
                        .getInstance()
                        .multiRequest(multiRequest)
                        .storePath("mngr")     // 저장위치
                        .keyStr("mngr_") // 파일명키
                        .procType(ProcType.findByProcType(param.getProcType()))
                        .atchFileId(param.getAtchFileId())
                        .fileKey(0)
                        .build();
                
                if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
            }
            
            egovNctsMngrOneOnOneService.mngrProgressOneOnOne(request, param);
            
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
    
    @RequestMapping(value = "/selectInquiryCode.do")
	public @ResponseBody HashMap<String, Object> selectInquiryCode(ModelMap model, @ModelAttribute MngrOneOnOneVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception{
		HashMap<String, Object> rs = new HashMap<>();
		List<HashMap<String, Object>> codeList = new ArrayList<HashMap<String, Object>>();
		List<HashMap<String, Object>> inquiryCodeList = commonCodeService.getCodeByGroup("DMH16");
		String sGubun2 = pageVO.getsGubun2();
		if(!(null == sGubun2 || "".equals(sGubun2))) {
			if("edu".equals(sGubun2)) {
				codeList = inquiryCodeList.subList(0,2);
			} else if("user".equals(sGubun2)) {
				codeList = inquiryCodeList.subList(2,4);
			} else if("instrctr".equals(sGubun2)) {
				codeList = inquiryCodeList.subList(4,6);
			}
		} 
		
		rs.put("codeList", codeList);
		rs.put("success", "success");
		return rs;
	}
    /*
    @RequestMapping(value = "/mngrBbsManageDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrBbsManageVO vo) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrBbsManageService.selectCommonExcel(vo);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    

    */
}