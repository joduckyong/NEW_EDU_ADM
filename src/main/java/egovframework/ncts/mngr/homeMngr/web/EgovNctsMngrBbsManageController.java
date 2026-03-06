package egovframework.ncts.mngr.homeMngr.web;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrBbsManageService;
import egovframework.ncts.mngr.homeMngr.vo.MngrBbsManageVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrBbsManageController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsManageController.class);
    
    @Autowired
    private EgovNctsMngrBbsManageService egovNctsMngrBbsManageService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110050101", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrBbsManageList.do")
    public String selectBbsManageList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        List<HashMap<String, Object>> commonList  = null;
        commonList = commonCodeService.getCodeByGroup("DMH13");
        
        for(int i = 0; i < commonList.size() ; i++){
            if(1 == Integer.parseInt((String) commonList.get(i).get("CODE"))){
                commonList.remove(i);
            }
        }
        list = egovNctsMngrBbsManageService.selectMngrBbsManageList(pageVO);
        
        model.addAttribute("list", list);
        model.addAttribute("code", commonList);

        return "mngr/homeMngr/mngrBbsManageList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrBbsManageDetail.do")
    public @ResponseBody HashMap<String, Object> selectBbsManageDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            HashMap<String, Object> de = egovNctsMngrBbsManageService.selectBbsManageDetail(param);
            result.put("de", de);
            result.put("success", "success");
        } catch (IOException e) {
        	LOGGER.debug(e.getMessage());
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
        }
        
        return result;
    }
    
    @AuthCheck(menuCd="110050101")
    @RequestMapping(value = "/mngrDeleteBbsManage.do")
    public @ResponseBody HashMap<String, Object> delBbsManage(HttpServletRequest request,ModelMap model, @ModelAttribute MngrBbsManageVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) param.setLastUpdusrId(user.getUserId());
        	
            egovNctsMngrBbsManageService.delBbsManage(param);
            
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
    
    @PreAuth(menuCd="110050101", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrBbsManageForm.do")
    public String mngrBbsManageForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrBbsManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        String atchFileId = "";
        HashMap<String, Object> result = new HashMap<>();
        
        List<HashMap<String, Object>> commonList  = null;
        commonList = commonCodeService.getCodeByGroup("DMH13");
        
        for(int i = 0; i < commonList.size() ; i++){
            if(1 == Integer.parseInt((String) commonList.get(i).get("CODE"))){
                commonList.remove(i);
            }
        }
        
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrBbsManageService.selectBbsManageDetail(param);
            result.put("inUp", "U");
            atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
        } else {
            result.put("inUp", "I");
        }
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();
        model.addAttribute("markup", markup);
        result.put("DMH13", commonList);
        model.addAttribute("result", result);
        return "mngr/homeMngr/mngrBbsManageForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110050101")
    @RequestMapping(value = "/mngrProgressBbsManage.do")
    public @ResponseBody HashMap<String, Object> mngrProgressBbsManage(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrBbsManageVO param) throws Exception{
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
            
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) {
    			param.setFrstRegisterId(user.getUserId());
    			param.setLastUpdusrId(user.getUserId());
    		}            
            
            egovNctsMngrBbsManageService.mngrProgressBbsManage(request, param);
            
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
    
    @RequestMapping(value = "/mngrBbsManageDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrBbsManageService.selectCommonExcel(pageVO);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
    

    @RequestMapping(value = "/mngrBbsAnswerManage.do")
    public @ResponseBody HashMap<String, Object> mngrBbsAnswerManage(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        
        try {
            egovNctsMngrBbsManageService.mngrBbsAnswerManage(request, param);
            
            result.put("success", "success");
            result.put("msg", "저장되었습니다.");
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg("INSERT"));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg("INSERT"));
        }

        return result;
    }
}