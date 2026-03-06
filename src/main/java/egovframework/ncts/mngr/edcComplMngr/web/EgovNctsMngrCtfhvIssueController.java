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
import org.springframework.web.util.CookieGenerator;

import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsMngrCtfhvIssueService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrCtfhvIssueVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcComplMngr")
public class EgovNctsMngrCtfhvIssueController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrCtfhvIssueController.class);
    
    @Autowired
    private EgovNctsMngrCtfhvIssueService egovNctsMngrCtfhvIssueService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110040501", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrCtfhvIssueList.do")
    public String selectCtfhvIssueList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCtfhvIssueVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        List<HashMap<String, Object>> commonList  = null;
        
        commonList = commonCodeService.getCodeByGroup("DMH04");
        for(int i = 0; i < commonList.size() ; i++){
            if(4 <= Integer.parseInt((String) commonList.get(i).get("CODE"))){
                commonList.remove(i);
            }
        }
        
        codeMap.put("DMH04", commonList);
        codeMap.put("DMH19", commonCodeService.getCodeByGroup("DMH19"));
        codeMap.put("DMH29", commonCodeService.getCodeByGroup("DMH29"));
        list = egovNctsMngrCtfhvIssueService.selectMngrCtfhvIssueList(pageVO);
        
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        return "mngr/edcComplMngr/mngrCtfhvIssueList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrCtfhvIssueDetail.do")
    public @ResponseBody HashMap<String, Object> selectCtfhvIssueDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrCtfhvIssueVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrCtfhvIssueService.selectCtfhvIssueDetail(param);

        result.put("de", de);
        result.put("success", "success");
        return result;
    }
   
    @AuthCheck(menuCd="110040501")
    @RequestMapping(value = "/mngrDeleteCtfhvIssue.do")
    public @ResponseBody HashMap<String, Object> delCtfhvIssue(HttpServletRequest request,ModelMap model, @ModelAttribute MngrCtfhvIssueVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsMngrCtfhvIssueService.delCtfhvIssue(param);
            
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
    
    @RequestMapping(value = "/mngrCtfhvIssueDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsMngrCtfhvIssueService.selectCommonExcel(pageVO);
        
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