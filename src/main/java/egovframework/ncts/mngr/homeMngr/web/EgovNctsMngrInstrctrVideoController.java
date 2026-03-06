package egovframework.ncts.mngr.homeMngr.web;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.com.auth.PreAuth;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.homeMngr.service.EgovNctsMngrVideoNoticeService;
import egovframework.ncts.mngr.homeMngr.vo.MngrVideoNoticeVO;

@Controller
@RequestMapping(value = "/ncts/mngr/homeMngr")
public class EgovNctsMngrInstrctrVideoController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrInstrctrVideoController.class);
    
    @Autowired
    private EgovNctsMngrVideoNoticeService egovNctsMngrVideoNoticeService;
    
    @PreAuth(menuCd="110050901", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrInstrctrVideoList.do")
    public String selectInstrctrVideoList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrVideoNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        pageVO.setBbsTypeCd("11");
        List<HashMap<String, Object>> list = egovNctsMngrVideoNoticeService.selectMngrVideoNoticeList(pageVO);
        model.addAttribute("list", list);

        return "mngr/homeMngr/mngrInstrctrVideoList.ncts_content";
    }
   
    @PreAuth(menuCd="110050901", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrInstrctrVideoForm.do")
    public String mngrInstrctrVideoForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrVideoNoticeVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
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
        
        return "mngr/homeMngr/mngrInstrctrVideoForm.ncts_content";
    }

}