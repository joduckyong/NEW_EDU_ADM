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
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrVideoNoticeService;
import egovframework.ncts.mngr.homeMngr.vo.MngrVideoNoticeVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrVideoNoticeController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrVideoNoticeController.class);
    
    @Autowired
    private EgovNctsMngrVideoNoticeService egovNctsMngrVideoNoticeService;
    
    @PreAuth(menuCd="110050801", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrVideoNoticeList.do")
    public String selectVideoNoticeList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrVideoNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        pageVO.setBbsTypeCd("10");
        List<HashMap<String, Object>> list = egovNctsMngrVideoNoticeService.selectMngrVideoNoticeList(pageVO);
        model.addAttribute("list", list);
        return "mngr/homeMngr/mngrVideoNoticeList.ncts_content";
    }
   
    @RequestMapping(value = "/mngrVideoNoticeDetail.do")
    public @ResponseBody HashMap<String, Object> selectVideoNoticeDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrVideoNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrVideoNoticeService.selectVideoNoticeDetail(param);

        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @PreAuth(menuCd="110050801", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrVideoNoticeForm.do")
    public String mngrVideoNoticeForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrVideoNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        String atchFileId = "";
        HashMap<String, Object> result = new HashMap<>();
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrVideoNoticeService.selectVideoNoticeDetail(param);
            atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
            model.addAttribute("result", result);
        }
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(false)
                .atchFileId(atchFileId)
                .fileTotal(1)
                .build();
        model.addAttribute("markup", markup);
        
        return "mngr/homeMngr/mngrVideoNoticeForm.ncts_content";
    }
    
    @RequestMapping(value = "/mngrProgressVideoNotice.do")
    public @ResponseBody HashMap<String, Object> mngrProgressVideoNotice(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrVideoNoticeVO param) throws Exception{
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
            
            egovNctsMngrVideoNoticeService.mngrProgressVideoNotice(request, param);
            
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
    
    
    @RequestMapping(value = "/mngrDeleteVideoNotice.do")
    public @ResponseBody HashMap<String, Object> delVideoNotice(HttpServletRequest request,ModelMap model, @ModelAttribute MngrVideoNoticeVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) param.setLastUpdusrId(user.getUserId());
    		
            egovNctsMngrVideoNoticeService.delVideoNotice(param);
            
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