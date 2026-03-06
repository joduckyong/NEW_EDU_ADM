package egovframework.ncts.mngr.userMngr.web;

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

import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrDeleteCnfirmMemberService;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;


@Controller
@RequestMapping(value = "/ncts/mngr/userMngr")
public class EgovNctsMngrDeleteCnfirmMemberController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDeleteCnfirmMemberController.class);
    
    @Autowired
    private EgovNctsMngrDeleteCnfirmMemberService egovNctsMngrDeleteCnfirmMemberService;
    
    @Autowired
    private EgovNctsMngrMemberService egovNctsMngrMemberService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
    @PreAuth(menuCd="110060401", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrDeleteCnfirmMemberList.do")
    public String mngrDeleteCnfirmMemberList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        HashMap<String, Object> codeMap = new HashMap<>();
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH23", commonCodeService.getCodeByGroup("DMH23")); // 세부등급
        codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); // 강사등급        
        list = egovNctsMngrDeleteCnfirmMemberService.selectMngrDeleteCnfirmMemberList(pageVO);
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        return "mngr/userMngr/mngrDeleteCnfirmMemberList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrDeleteCnfirmMemberDetail.do")
    public @ResponseBody HashMap<String, Object> selectDeleteCnfirmMngrMemberDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> seList = null;
        List<HashMap<String, Object>> seVideoList = null;
        HashMap<String, Object> de = egovNctsMngrDeleteCnfirmMemberService.selectMngrDeleteCnfirmMemberDetail(param);
        seList = egovNctsMngrMemberService.selectMngrMemberSeDetail(param);
        seVideoList = egovNctsMngrMemberService.selectMngrMemberSeVideoDetail(param);
        
        result.put("de", de);
        result.put("se", seList);
        result.put("seVideo", seVideoList);
        result.put("success", "success");
        return result;
    }
    
    @AuthCheck(menuCd="110060401")
    @RequestMapping(value = "/deleteMngrDeleteCnfirmMember.do")
    public @ResponseBody HashMap<String, Object> deleteMngrDeleteCnfirmMember(HttpServletRequest request,ModelMap model, @ModelAttribute MngrMemberVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsMngrDeleteCnfirmMemberService.deleteMngrDeleteCnfirmMember(param);
            
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