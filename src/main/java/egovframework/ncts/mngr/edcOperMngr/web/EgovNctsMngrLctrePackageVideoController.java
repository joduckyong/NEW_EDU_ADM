package egovframework.ncts.mngr.edcOperMngr.web;

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

import egovframework.com.auth.PreAuth;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsLctreOffService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreOffVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcOperMngr")
public class EgovNctsMngrLctrePackageVideoController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrLctrePackageVideoController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private EgovNctsLctreOffService egovNctsLctreOffService;
    
    @PreAuth(menuCd="110030601", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrLctrePackageVideoList.do")
    public String mngrLctrePackageVideoList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrLctreOffVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        pageVO.setSearchCondition1("Y");
        pageVO.setSearchCondition2("Y");
        pageVO.setsGubun1("10");
        list = egovNctsLctreOffService.selectLctreList(pageVO);
        
        HashMap<String, Object> codeMap = new HashMap<>();
		codeMap.put("DMH14", commonCodeService.getCodeByGroup("DMH14"));//교육과정
        
        model.addAttribute("codeMap", codeMap);
        model.addAttribute("list", list);
        model.addAttribute("searchCondition1", pageVO.getSearchCondition1());
        model.addAttribute("searchCondition2", pageVO.getSearchCondition2());
        model.addAttribute("sGubun1", pageVO.getsGubun1());
        
        return "mngr/edcComplMngr/mngrLctreOffList.ncts_content";
    }
    
    
}