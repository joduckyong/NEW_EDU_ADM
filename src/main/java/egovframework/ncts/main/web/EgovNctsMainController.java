package egovframework.ncts.main.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.SessionUtil;
import egovframework.com.Sha256Crypto;
import egovframework.com.auth.PreAuth;
import egovframework.com.security.CustomizeUserDetailService;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.main.service.EgovNctsEduMainService;
import egovframework.ncts.main.service.EgovNctsMainService;
import egovframework.ncts.main.vo.MainVO;

@Controller
@RequestMapping(value="/ncts")
public class EgovNctsMainController {

	private static final Logger log = LoggerFactory.getLogger(EgovNctsMainController.class);
	
	@Autowired
	private CustomizeUserDetailService customizeUserDetailService;
	
	@Autowired
	private EgovNctsMainService egovNctsMainService;
	
	@Autowired
	private EgovNctsEduMainService egovNctsEduMainService;
	
	@Autowired
	private CommonCodeService commonCodeService;	
	
	@PreAuth(menuCd="00000000", pageType=PageType.MAIN)
	@RequestMapping(value = "/egovNctsMain.do")
	public String egovNctsMain(ModelMap model,  HttpServletRequest request, @ModelAttribute MainVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request);
		/*if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))*/
		
		pageVO.setCenterCd(user.getCenterId());	
		param.setFrstRegisterId(user.getUserNm());
		
		if(null != pageVO.getCenterCd() && !"".equals(pageVO.getCenterCd())) {
			List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) commonCodeService.getCenterList();
			model.addAttribute("centerList", centerList);
		}
		
    	List<HashMap<String, Object>> mainNoticeList = new ArrayList<HashMap<String, Object>>();
    	HashMap<String, Object> mainSche = (HashMap<String, Object>) egovNctsMainService.selectMainSche(param);
    	
    	mainNoticeList = egovNctsEduMainService.selectNoticeList();
		HashMap<String, Object> homeUser = (HashMap<String, Object>) egovNctsEduMainService.selectHomeStatusUser();
    	HashMap<String, Object> visitUser = (HashMap<String, Object>) egovNctsEduMainService.selectVisitUser();
    	HashMap<String, Object> instrctrUser = (HashMap<String, Object>) egovNctsEduMainService.selectInstrctrUser();
    	
    	HashMap<String, Object> parameters = new HashMap<>();
    	parameters.put("gubun", "Y");
    	parameters.put("centerCd", null == pageVO.getSearchCondition2() ? pageVO.getCenterCd() : pageVO.getSearchCondition2());
    	HashMap<String, Object> oneOnOne = (HashMap<String, Object>) egovNctsEduMainService.selectOneOnOne(parameters);
    	HashMap<String, Object> selectEduProgress = (HashMap<String, Object>) egovNctsEduMainService.selectEdu(parameters);
    	parameters.put("gubun", "N");
    	HashMap<String, Object> selectEduTotal = (HashMap<String, Object>) egovNctsEduMainService.selectEdu(parameters);
    	HashMap<String, Object> selectApplicant = (HashMap<String, Object>) egovNctsEduMainService.selectApplicant(parameters);
    	HashMap<String, Object> selectApplicantTotal = (HashMap<String, Object>) egovNctsEduMainService.selectApplicantGroupBy(parameters);
    	model.addAttribute("homeUser", homeUser);
		model.addAttribute("visitUser", visitUser);
		model.addAttribute("instrctrUser", instrctrUser);
		model.addAttribute("oneOnOne", oneOnOne);
		model.addAttribute("selectEduProgress", selectEduProgress);
		model.addAttribute("selectEduTotal", selectEduTotal);
		model.addAttribute("selectApplicant", selectApplicant);
		model.addAttribute("selectApplicantTotal", selectApplicantTotal);
		
		model.addAttribute("mainSche", mainSche);
		model.addAttribute("mainNoticeList", mainNoticeList);
		model.addAttribute("main", "Y");
		return "main/egovNctsMain_edu.ncts_single";
	}
	
	@PreAuth(menuCd="00000000", pageType=PageType.MAIN)
	@RequestMapping(value = "/egovNctsMypage.do")
	public String egovNctsMypage(ModelMap model,  HttpServletRequest request) {
		HashMap<String, Object>       pstmenuInfo = new HashMap<String, Object>();
		pstmenuInfo.put("PARENT_NM_1", "mypage");
		pstmenuInfo.put("PARENT_NM_2", "mypage");
		pstmenuInfo.put("MENU_NM", "패스워드변경");
		pstmenuInfo.put("MENU_CD", "00000000_my");
		
		model.addAttribute("pageInfo", pstmenuInfo);
		return "main/egovNctsMypage.ncts_content";
	}
	
	@RequestMapping(value = "/procPasswordChange.do")
    public @ResponseBody HashMap<String, Object> grupRegisterDetail(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String, String> param) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        try {
        	CustomUser sessionUser = SessionUtil.getProperty(request); 
        	String password = param.get("password");
        	String newPassword1 = param.get("newPassword1");
        	String newPassword2 = param.get("newPassword2");
        	if(StringUtils.isEmpty(password) || StringUtils.isEmpty(newPassword1) || StringUtils.isEmpty(newPassword2)) throw new Exception("00");
        
        	CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(sessionUser.getUserId());
        	if(!Sha256Crypto.authenticate(password,user.getUserPw())) throw new Exception("01"); 
        	if(!newPassword1.equals(newPassword2)) throw new Exception("02");
        	
        	user.setUserPw(Sha256Crypto.encryption(newPassword1));
        	egovNctsMainService.updateUserPwd(user);
        	
            result.put("success", "success");
            result.put("msg", "다음 로그인부터 적용됩니다.");
        }catch (Exception e) {
            result.put("success", "error");
            System.out.println(e.getStackTrace());
            e.printStackTrace();
            if("00".equals(e.getMessage())) result.put("msg", "항목을 모두 입력하시기 바랍니다.");
            else if("01".equals(e.getMessage())) result.put("msg", "현재 비밀번호가 일치하지 않습니다.");
            else if("02".equals(e.getMessage())) result.put("msg", "새 암호화 암호확인이 일치하지 않습니다.");
        }
    
        return result;
    }
	/*로그인하기전 초기비밀번호 변경처리*/
	@RequestMapping(value = "/procPasswordChange2.do")
    public @ResponseBody HashMap<String, Object> procPasswordChange2(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String, String> param) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        try {
        	String password = param.get("password");
        	String newPassword1 = param.get("newPassword1");
        	String newPassword2 = param.get("newPassword2");
        	if(StringUtils.isEmpty(password) || StringUtils.isEmpty(newPassword1) || StringUtils.isEmpty(newPassword2)) throw new Exception("00");
        
        	CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(param.get("userId"));
        	if(!Sha256Crypto.authenticate(password,user.getUserPw())) throw new Exception("01"); 
        	if(!newPassword1.equals(newPassword2)) throw new Exception("02");
        	
        	//변경 로직 태우기
        	user.setUserPw(Sha256Crypto.encryption(newPassword1));
        	egovNctsMainService.updateUserPwd(user);
        	
            result.put("success", "success");
            result.put("msg", "다음 로그인부터 적용됩니다.");
        }catch (Exception e) {
            result.put("success", "error");
            System.out.println(e.getStackTrace());
            e.printStackTrace();
            if("00".equals(e.getMessage())) result.put("msg", "항목을 모두 입력하시기 바랍니다.");
            else if("01".equals(e.getMessage())) result.put("msg", "현재 비밀번호가 일치하지 않습니다.");
            else if("02".equals(e.getMessage())) result.put("msg", "새 암호화 암호확인이 일치하지 않습니다.");
        }
    
        return result;
    }	
}
