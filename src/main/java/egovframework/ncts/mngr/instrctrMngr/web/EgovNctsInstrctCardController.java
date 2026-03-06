package egovframework.ncts.mngr.instrctrMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrCardService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrCardVO;

@Controller
@RequestMapping(value = "/ncts/mngr/instrctrMngr")
public class EgovNctsInstrctCardController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctCardController.class);
    
    @Autowired
    private EgovNctsInstrctrCardService egovNctsInstrctrCardService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110010201", pageType=PageType.LIST)
    @RequestMapping(value = "/instrctrCardList.do")
    public String instrctrMngrList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrCardVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급
        
        list = egovNctsInstrctrCardService.selectInstrctrCardList(pageVO);
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(false)
                //.atchFileId(atchFileId)
                .fileTotal(1)
                .build();
        model.addAttribute("markup", markup);
        return "mngr/instrctrMngr/instrctrCardList.ncts_content";
    }
    
    @RequestMapping(value = "/instrctrCardDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrMemberDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrCardVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsInstrctrCardService.selectInstrctrCardDetail(param);
        
        result.put("de", de);
        
        result.put("success", "success");
        return result;
    }
    /*
    @PreAuth(menuCd="110010201", pageType=PageType.FORM)
    @RequestMapping(value = "/instrctrForm.do")
    public String instrctrForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrInstrctrActVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH04", commonCodeService.getCodeByGroup("DMH23"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH08", commonCodeService.getCodeByGroup("DMH08"));
        
        if (ProcType.UPDATE.equals(procType)) {
            HashMap<String, Object> result = new HashMap<>();

            result = egovNctsInstrctrMngrService.selectInstrctrMngrDetail(param);
            
            model.addAttribute("result", result);
        }
        
        model.addAttribute("codeMap", codeMap);
        return "mngr/instrctrMngr/instrctrForm.ncts_content";
    }
    */
    
    @RequestMapping(value = "/cardProc.do")
    public @ResponseBody HashMap<String, Object> actProc(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrInstrctrCardVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	String userId = user.getUserId();
        	param.setUserId(userId);
        }
        
        try {
            egovNctsInstrctrCardService.cardProc(param);
            
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
    
    @RequestMapping(value = "/updateFile.do")
    public @ResponseBody HashMap<String, Object> updateFile(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrInstrctrCardVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        
        try {
                String atchFileId = FileUploadBuilder
                        .getInstance()
                        .multiRequest(multiRequest)
                        .storePath("mngr")     // 저장위치
                        .keyStr("mngr_") // 파일명키
                        //.procType(ProcType.findByProcType(param.getProcType()))
                        .atchFileId(param.getAtchFileId())
                        .fileKey(0)
                        .build();
                
                if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);

            
                egovNctsInstrctrCardService.updateFile(request, param);
            
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
    
    /*
    @RequestMapping(value = "/instrctrExcelDownload.do")
    public void instrctrExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrInstrctrActVO vo) throws Exception {
        HashMap<String, Object> rsMap = egovNctsInstrctrMngrService.selectCommonExcel(vo);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }*/
}