package egovframework.ncts.mngr.common.web;

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

import egovframework.com.SessionUtil;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.mlbxMngr.vo.MngrMailBoxVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;


@Controller
@RequestMapping(value = "/ncts/mngr/common")
public class EgovNctsMngrCommonController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrCommonController.class);
	
	@Autowired
	private EgovNctsMngrCommonService egovNctsMngrCommonService;
	@Autowired
	private EgovNctsMngrMemberService egovNctsMngrMemberService;
	
	@Autowired
    private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/stddLecListPopup.do")
	public String replcLecListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrCommonVO param) throws Exception {
		List<HashMap<String, Object>> list = null;
		List<HashMap<String, Object>> commonList  = null;
		
		commonList = commonCodeService.getCodeByGroup("DMH14");
        list = egovNctsMngrCommonService.selectLectureList(param);
		
		model.addAttribute("list", list);
		model.addAttribute("codeMap", commonList);
		
		return "mngr/common/stddLecListPopup.ncts_popup";
	}
	
    @RequestMapping(value = "/getMailList.do")
    public @ResponseBody HashMap<String, Object> getMailList(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrCommonVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsMngrCommonService.selectMailList();
            
            result.put("success", "success");
            result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
        } catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        } catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}

        return result;
    }
	
    @RequestMapping(value = "/selectEduMemberDetailPopup.do")
    public String selectEduMemberDetailPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrCommonVO param) throws Exception {
    	HashMap<String, Object> codeMap = new HashMap<>();
    	codeMap.put("DMH24", commonCodeService.getCodeByGroup("DMH24")); 
    	codeMap.put("DMH30", commonCodeService.getCodeByGroup("DMH30")); 
    	
    	model.addAttribute("result", egovNctsMngrCommonService.selectMemberCoreDetail(param));
    	model.addAttribute("codeMap", codeMap);
    	return "mngr/common/selectEduMemberDetailPopup.ncts_popup";
    }
	
}
