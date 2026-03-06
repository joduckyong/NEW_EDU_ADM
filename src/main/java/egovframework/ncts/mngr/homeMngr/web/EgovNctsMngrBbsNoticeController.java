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
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrBbsNoticeService;
import egovframework.ncts.mngr.homeMngr.vo.MngrBbsNoticeVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrBbsNoticeController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrBbsNoticeController.class);
    
    @Autowired
    private EgovNctsMngrBbsNoticeService egovNctsMngrBbsNoticeService;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110050201", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrBbsNoticeList.do")
    public String selectBbsNoticeList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) if(null != user) pageVO.setCenterCd(user.getCenterId());        
    	
    	List<HashMap<String, Object>> list = null;

        list = egovNctsMngrBbsNoticeService.selectMngrBbsNoticeList(pageVO);
        List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        model.addAttribute("list", list);
        model.addAttribute("centerList", centerList);

        return "mngr/homeMngr/mngrBbsNoticeList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrBbsNoticeDetail.do")
    public @ResponseBody HashMap<String, Object> selectBbsNoticeDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> de = egovNctsMngrBbsNoticeService.selectBbsNoticeDetail(param);

        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    
    @AuthCheck(menuCd="110050201")
    @RequestMapping(value = "/mngrDeleteBbsNotice.do")
    public @ResponseBody HashMap<String, Object> delBbsNotice(HttpServletRequest request,ModelMap model, @ModelAttribute MngrBbsNoticeVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	CustomUser user = SessionUtil.getProperty(request);
    		if(null != user) param.setLastUpdusrId(user.getUserId());
        	
            egovNctsMngrBbsNoticeService.delBbsNotice(param);
            
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
    
    @PreAuth(menuCd="110050201", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrBbsNoticeForm.do")
    public String mngrBbsNoticeForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrBbsNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        String atchFileId = "";
        HashMap<String, Object> result = new HashMap<>();
        if (ProcType.UPDATE.equals(procType)) {
            result = egovNctsMngrBbsNoticeService.selectBbsNoticeDetail(param);
            atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
            model.addAttribute("result", result);
        }
        
        List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        model.addAttribute("centerList", centerList);
        
        StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();
        model.addAttribute("markup", markup);
        
        return "mngr/homeMngr/mngrBbsNoticeForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110050201")
    @RequestMapping(value = "/mngrProgressBbsNotice.do")
    public @ResponseBody HashMap<String, Object> mngrProgressBbsNotice(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrBbsNoticeVO param) throws Exception{
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
            
            egovNctsMngrBbsNoticeService.mngrProgressBbsNotice(request, param);
            
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
    
    @RequestMapping(value = "/updateBbsNotag.do")
    public @ResponseBody HashMap<String, Object> updateBbsNotag (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrBbsNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> result = new HashMap<>();
    	 try {
    		 egovNctsMngrBbsNoticeService.updateBbsNotag(param);
    		 result.put("success", "success");
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