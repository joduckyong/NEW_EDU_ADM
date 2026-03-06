package egovframework.ncts.mngr.homeMngr.web;

import java.io.IOException;
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
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrFaqRegistService;
import egovframework.ncts.mngr.homeMngr.vo.MngrFaqRegistVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrFaqRegistController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsNoticeController.class);
    
    @Autowired
    private EgovNctsMngrFaqRegistService egovNctsMngrFaqRegistService;
    
    @PreAuth(menuCd="110050601", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrFaqRegistList.do")
    public String selectFaqRegistList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrFaqRegistVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;

        list = egovNctsMngrFaqRegistService.selectMngrFaqRegistList(pageVO);

        model.addAttribute("list", list);

        return "mngr/homeMngr/mngrFaqRegistList.ncts_content";
    }
   
    @RequestMapping(value = "/mngrFaqRegistDetail.do")
    public @ResponseBody HashMap<String, Object> selectFaqRegistDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrFaqRegistVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrFaqRegistService.selectFaqRegistDetail(param);

        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110050601", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrFaqRegistForm.do")
    public String mngrFaqRegistForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrFaqRegistVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        String atchFileId = "";
        HashMap<String, Object> result = new HashMap<>();
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrFaqRegistService.selectFaqRegistDetail(param);
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
        
        return "mngr/homeMngr/mngrFaqRegistForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110050601")
    @RequestMapping(value = "/mngrProgressFaqRegist.do")
    public @ResponseBody HashMap<String, Object> mngrProgressFaqRegist(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrFaqRegistVO param) throws Exception{
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
            
            egovNctsMngrFaqRegistService.mngrProgressFaqRegist(request, param);
            
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
    
    
    @AuthCheck(menuCd="110050601")
    @RequestMapping(value = "/mngrDeleteFaqRegist.do")
    public @ResponseBody HashMap<String, Object> delFaqRegist(HttpServletRequest request,ModelMap model, @ModelAttribute MngrFaqRegistVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) param.setLastUpdusrId(user.getUserId());
    		
            egovNctsMngrFaqRegistService.delFaqRegist(param);
            
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
}