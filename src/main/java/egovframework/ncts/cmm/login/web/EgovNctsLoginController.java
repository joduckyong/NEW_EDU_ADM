package egovframework.ncts.cmm.login.web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gpki.servlet.GPKIHttpServletRequest;
import com.gpki.servlet.GPKIHttpServletResponse;

import egovframework.com.SessionUtil;
import egovframework.com.ipcheck;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonIpChkService;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

@Controller
@RequestMapping(value="/ncts/login")
public class EgovNctsLoginController {

	private static final Logger log = LoggerFactory.getLogger(EgovNctsLoginController.class);

	@Autowired
	private CommonIpChkService ipService;
	
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;
	
	@RequestMapping(value = "/egovLoginForm.do")
	public String egovLoginForm(ModelMap model,  HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		
		ipAuthVO vo2 = new ipAuthVO();
		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest = null;
		// 운영여부 확인
		if(request.getServerName().equals("eduadm.nct.go.kr")
		|| request.getServerName().equals("test.nct.go.kr")
		|| request.getServerName().indexOf("175.106.93.65") > -1 
		|| request.getServerName().indexOf("10.37.43.162") > -1) {
			model.addAttribute("operYn", "Y");
		}
		
		if (authentication != null && authentication.isAuthenticated()) {
			HttpSession session = request.getSession(true);
			String loginCheck = (String) session.getAttribute("loginCheck");
			
			if(loginCheck != null && "Y".equals(loginCheck)) {
				return "redirect:/ncts/egovNctsMain.do";
			}else {
				session.invalidate();
				return "redirect:/ncts/login/egovLoginForm.do";
			}
		}
		
		try {
			gpkiresponse = new GPKIHttpServletResponse(response);
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);
			
			StringBuffer url = request.getRequestURL();
			SessionUtil.setProperty(request,"currentpage",url.toString());
			
			model.addAttribute("challenge", gpkiresponse.getChallenge());
			model.addAttribute("sessionid", gpkirequest.getSession().getId());
		
		 } catch (IOException e) {
			 if(log.isDebugEnabled()) log.debug(e.getMessage());
		} catch (Exception e) {
			if(log.isDebugEnabled()) log.debug(e.getMessage());
		}
		vo2.setIpAdress(ipcheck.getClientIP());
//		log.info(ipcheck.getClientIP());
//		int ipChk2 = ipService.selectIpChk2(vo2);
//		int ipChk = ipService.selectIpChk(vo2);
//		if(ipChk2 == 0 && ipChk == 0){
//			return "cmm/sys/ipAccess.ncts_login";
//		}else{
			return "cmm/login/egovLoginForm.ncts_login";
//		}
		
	}
	
	@RequestMapping(value = "/egovGpkiLoginForm.do")
	public String egovGpkiLoginForm(ModelMap model,  HttpServletRequest request, HttpServletResponse response) {
		
		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest = null;
		
		try {
				
			gpkiresponse = new GPKIHttpServletResponse(response);
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);
			
			StringBuffer url = request.getRequestURL();
			SessionUtil.setProperty(request,"currentpage",url.toString());
			
			model.addAttribute("challenge", gpkiresponse.getChallenge());
			model.addAttribute("sessionid", gpkirequest.getSession().getId());
			
		 } catch (IOException e) {
			 if(log.isDebugEnabled()) log.debug(e.getMessage());
		} catch (Exception e) {
			if(log.isDebugEnabled()) log.debug(e.getMessage());
		}
		
		return "cmm/login/egovGpkiLoginForm.ncts_login";
	}	
	
	@RequestMapping(value = "/extendSession.do")
	public @ResponseBody HashMap<String, Object> extendSession() throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		result.put("success", "success");
		
		return result;
	}
	
	@RequestMapping(value = "/msg.do")
	public String msg(ModelMap model,  HttpServletRequest request, HttpServletResponse response) throws Exception {
		
	    return "cmm/login/msg.ncts_login";
	}
	
	@RequestMapping(value = "/logout.do")
	public String logout(ModelMap model,  HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		
			log.info("userId : " + request.getParameter("userId"));
	    	String userId = request.getParameter("userId");
	        if (userId != null) {
	        	
				CustomUser cu = new CustomUser();
				cu.setUserId(userId);
				cu.setIp(ipcheck.getClientIP(request));
				cu.setIoStat("O");
				egovNctsLoginService.insertVisit(cu);	        	
				egovNctsLoginService.deleteUserSession(userId);
				
	        }
	        
	    return "/ncts/login/egovLoginForm.do";
	}
}





