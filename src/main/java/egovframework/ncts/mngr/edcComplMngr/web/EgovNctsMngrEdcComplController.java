package egovframework.ncts.mngr.edcComplMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.CookieGenerator;

import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsMngrEdcComplService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEdcComplVO;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;

@Controller
@RequestMapping(value = "/ncts/mngr/edcComplMngr")
public class EgovNctsMngrEdcComplController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEdcComplController.class);
    
    @Autowired
    private EgovNctsMngrEdcComplService egovNctsMngrEdcComplService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private EgovNctsMngrEduService mngrEduService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110040301", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrEdcCompList.do")
    public String selectEdcComplList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcComplVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        List<HashMap<String, Object>> eduResult = null;
       
        eduResult = mngrEduService.selectEduList();
        // codeMap.put("DMH12", commonCodeService.getCodeByGroup("DMH12"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH19", commonCodeService.getCodeByGroup("DMH19"));
        list = egovNctsMngrEdcComplService.selectMngrEdcCompList(pageVO);
        
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        model.addAttribute("eduResult", eduResult);
        return "mngr/edcComplMngr/mngrEdcCompList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrEdcCompDetail.do")
    public @ResponseBody HashMap<String, Object> selectEdcComplDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEdcComplVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrEdcComplService.selectEdcComplDetail(param);

        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110040301", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrEdcCompForm.do")
    public String mngrEdcCompForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrEdcComplVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
       
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrEdcComplService.selectEdcComplDetail(param);

            model.addAttribute("result", result);
        }
        codeMap.put("DMH12", commonCodeService.getCodeByGroup("DMH12"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        model.addAttribute("codeMap", codeMap);
        return "mngr/edcComplMngr/mngrEdcCompForm.ncts_content";
    }
   
    /*@AuthCheck(menuCd="110030201")
    @RequestMapping(value = "/mngrEdcCompProc.do")
    public @ResponseBody HashMap<String, Object> mngrEdcCompProc(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrEdcComplVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrEdcComplService.saveMngrEdcCompProc(param);
            
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
    }*/
   
    @AuthCheck(menuCd="110040301")
    @RequestMapping(value = "/mngrDeleteEdcComp.do")
    public @ResponseBody HashMap<String, Object> delEdcRequset(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEdcComplVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrEdcComplService.delEdcCompl(param);
            
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
    
    @RequestMapping(value = "/mngrEdcComplDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrEdcComplService.selectCommonExcel(pageVO);
        
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