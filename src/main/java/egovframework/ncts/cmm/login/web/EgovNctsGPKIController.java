package egovframework.ncts.cmm.login.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gpki.gpkiapi.cert.X509Certificate;
import com.gpki.gpkiapi.exception.GpkiApiException;
import com.gpki.servlet.GPKIHttpServletRequest;
import com.gpki.servlet.GPKIHttpServletResponse;

import egovframework.com.Sha256Crypto;
import egovframework.com.security.CustomizeUserDetailService;
import egovframework.com.security.vo.CustomUser;
import egovframework.ncts.cmm.login.service.EgovNctsGPKIService;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;

@Controller
@RequestMapping(value="/ncts/gpik")
public class EgovNctsGPKIController {

	private static final Logger log = LoggerFactory.getLogger(EgovNctsGPKIController.class);
	
	private static final int TIME = 60 * 60; // 1시간
	
	@Autowired
	private EgovNctsGPKIService egovNctsGPKIService;
	
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;
	
	@Autowired
	private CustomizeUserDetailService customizeUserDetailService;
	
	@RequestMapping(value = "/loginProcess.do")
	public String loginProcess(ModelMap model,  HttpServletRequest request, HttpServletResponse response,RedirectAttributes redirectAttributes) {
		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest = null;
		String url = "redirect:/ncts/login/egovLoginForm.do";
		String userId = request.getParameter("gpkiUserId");
		log.debug("userId ::: " + userId);
		try {
			
			gpkiresponse = new GPKIHttpServletResponse(response);
			log.debug("@ gpkiresponse @");
			gpkirequest  = new GPKIHttpServletRequest(request);
			log.debug("@ gpkirequest @");
			gpkiresponse.setRequest(gpkirequest);
			log.debug("@ setRequest @");
			
			X509Certificate cert      = null; 
			byte[]  signData          = null;
			byte[]  privatekey_random = null;
			String  signType          = null;
			String  subDN             = null;
			String  queryString       = "";
			boolean checkPrivateNum   = false;
			
			java.math.BigInteger b = new java.math.BigInteger("-1".getBytes()); 
	
			int message_type =  gpkirequest.getRequestMessageType();
			
			if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
				message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){
	
				cert              = gpkirequest.getSignerCert(); 
				subDN             = cert.getSubjectDN();
				b                 = cert.getSerialNumber();
				signData          = gpkirequest.getSignedData();
				privatekey_random = gpkirequest.getSignerRValue();
				signType          = gpkirequest.getSignType();
			}
			log.debug("gpkirequest cert::: " + cert);
			log.debug("gpkirequest subDN::: " + subDN);
			log.debug("gpkirequest b::: " + b);
			log.debug("gpkirequest signData::: " + signData);
			log.debug("gpkirequest privatekey_random::: " + privatekey_random);
			log.debug("gpkirequest signType::: " + privatekey_random);
			log.debug(subDN);
			
			HttpSession session = request.getSession(true);
			CustomUser userInfo = new CustomUser();
			userInfo.setDn(subDN);
			userInfo.setUserId(userId);
			CustomUser userDN = egovNctsGPKIService.selectUserDN(userInfo);
			
			if(null == userDN) {
				
				redirectAttributes.addFlashAttribute("gpkiErrorCd", "ERROR001"); 
				redirectAttributes.addFlashAttribute("gpkiMsg", "공인인증서가 등록되지 않았습니다.");
				session.invalidate();
			}
			else if(null != userDN.getLockAt() && "Y".equals(userDN.getLockAt())) {
				redirectAttributes.addFlashAttribute("gpkiMsg", "로그인 5회 이상 실패로 잠긴 계정입니다. 전산담당자 변현정선생님께 연락 부탁드립니다.");  
				session.invalidate();
			}
			else if(null != userDN.getMacUseableAt() && "Y".equals(userDN.getMacUseableAt())) {
				redirectAttributes.addFlashAttribute("gpkiResult", "macCheck"); 
				redirectAttributes.addFlashAttribute("gpkiUser", userDN.getUserId()); 
			}
			else {
				CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(userDN.getUserId());
				Authentication authentication  = new UsernamePasswordAuthenticationToken(user, user.getPassword(), user.getAuthorities());
				SecurityContext securityContext = SecurityContextHolder.getContext();
				securityContext.setAuthentication(authentication);
				
				session.setMaxInactiveInterval(TIME);
				session.setAttribute("SPRING_SECURITY_CONTEXT",securityContext);   // 세션에 spring security context 넣음
				session.setAttribute("userinfo", authentication.getPrincipal());
				
				url = "redirect:/ncts/egovNctsMain.do";
			}
		} catch (Exception e) {
			if("00".equals(e.getMessage())) {
				redirectAttributes.addFlashAttribute("gpkiErrorCd", "ERROR001");
				redirectAttributes.addFlashAttribute("msg", "공인인증서가 등록되지 않았습니다.");
			}
			else if("01".equals(e.getMessage())) redirectAttributes.addFlashAttribute("msg", "로그인 5회 이상 실패로 잠긴 계정입니다. \n전산담당자 변현정선생님께 연락 부탁드립니다.");
			else log.debug(e.getMessage());	
		}
		
		return url;
	}
	
	
	
	@RequestMapping(value = "/registerDNProcess.do")
	public String registerDNProcess(ModelMap model,  HttpServletRequest request, HttpServletResponse response,RedirectAttributes redirectAttributes,@ModelAttribute CustomUser param) throws Exception {
		
		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest = null;
		
		if(request.getParameter("pwCheckCode").equals("0")){
			try {
				gpkiresponse = new GPKIHttpServletResponse(response);
				System.out.println("@ gpkiresponse @");
				gpkirequest  = new GPKIHttpServletRequest(request);
				System.out.println("@ gpkirequest @");
				gpkiresponse.setRequest(gpkirequest);
				System.out.println("@ setRequest @");
				
				X509Certificate cert      = null; 
				byte[]  signData          = null;
				byte[]  privatekey_random = null;
				String  signType          = null;
				String  subDN             = null;
				String  queryString       = "";
				boolean checkPrivateNum   = false;
				
				java.math.BigInteger b = new java.math.BigInteger("-1".getBytes()); 
		
				int message_type =  gpkirequest.getRequestMessageType();
		
				if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
					message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){
		
					cert              = gpkirequest.getSignerCert(); 
					subDN             = cert.getSubjectDN();
					//b                 = cert.getSerialNumber();
					//signData          = gpkirequest.getSignedData();
					//privatekey_random = gpkirequest.getSignerRValue();
					//signType          = gpkirequest.getSignType();
					
					param.setDn(StringUtils.trim(subDN) );
					egovNctsGPKIService.insertDn(param);
				}else{
					throw new Exception();
				}
				
				queryString = gpkirequest.getQueryString();
				Enumeration params = gpkirequest.getParameterNames(); 
				while (params.hasMoreElements()) {
					String paramName = (String)params.nextElement(); 
					String paramValue = gpkirequest.getParameter(paramName);
					
					if(paramName.trim().equalsIgnoreCase("ssn") && (null != paramValue) && (!"".equals(paramValue)) && privatekey_random != null) {
						try {
							cert.verifyVID(paramValue,privatekey_random);
							checkPrivateNum = true;
						} catch (GpkiApiException ex) {
							// 개인 식별 번호가 다른경우 예외처리
							com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
							StringBuffer sb = new StringBuffer(1500);
							sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
							sb.append("?errmsg=");
							sb.append(URLEncoder.encode("ssn parameter is different in certificate ! check ssn number","UTF-8"));
							response.sendRedirect(sb.toString());
						}
					}
					System.out.println(paramName+"="+((paramName.equals("challenge"))?paramValue:URLDecoder.decode(paramValue,"UTF-8"))+"<br>");
				}
						
			} catch (Exception e) {
				log.debug(e.getMessage());	
				redirectAttributes.addFlashAttribute("ErrorMsg", "관리자에게 문의하세요.");
			}
		} else {
			System.out.println("@ pwCheckCode!= 0 @");
			if(!(null == request.getParameter("userId") || "".equals(request.getParameter("userId")))) {
				egovNctsLoginService.updateLockAt(request.getParameter("userId"));
				redirectAttributes.addFlashAttribute("ErrorMsg", "로그인 5회 이상 실패로 잠긴 계정입니다. \n전산담당자 변현정선생님께 연락 부탁드립니다.");
			}
		}
		return "redirect:/ncts/login/egovLoginForm.do";
	}
	
	@RequestMapping(value = "/selectCheckedDN.do")
	public @ResponseBody HashMap<String, Object> selectCheckedDN(ModelMap model, @ModelAttribute CustomUser param) throws Exception{
		
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			
			CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(param.getUserId());
			String user_pw = (String) param.getUserPw();
				
			if(null == user)                         throw new Exception("00");
			else if("Y".equals(user.getLockAt()))          throw new Exception("05");
			else if (!Sha256Crypto.authenticate(user_pw, user.getUserPw())) throw new Exception("02");
			else if("N".equals(user.getUseYn()))          throw new Exception("01");
			else if(!StringUtils.isEmpty(user.getDn())) throw new Exception("04");
				
			Collection<? extends GrantedAuthority> authorities = user.getAuthorities();
			if(authorities.size() <=0)               throw new Exception("03");

			result.put("success", "success");
		}catch (Exception e) {
			if("00".equals(e.getMessage())) result.put("msg", "등록된 회원정보가 없습니다.");
			else if("01".equals(e.getMessage())) result.put("msg", "사용이 중지된 회원입니다.");
			else if("05".equals(e.getMessage())) result.put("msg", "로그인 5회 이상 실패로 잠긴 계정입니다. \n전산담당자 변현정선생님께 연락 부탁드립니다.");
			else if("02".equals(e.getMessage())) result.put("msg", "비밀번호가 일치하지 않습니다.");
			else if("03".equals(e.getMessage())) result.put("msg", "권한이 존재하지 않습니다.");
			else if("04".equals(e.getMessage())) result.put("msg", "이미 등록된 사용자입니다.");
			else  result.put("msg", "관리자에게 문의하세요.");
			
			result.put("success", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value = "/initGpki.do")
	public @ResponseBody HashMap<String, Object> initGpki(ModelMap model, @ModelAttribute CustomUser param) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		try {
			param.setDn(null);
			egovNctsGPKIService.insertDn(param);
			result.put("success", "success");
			result.put("msg", "인증서를 초기화했습니다.");
		}catch (Exception e) {
			log.debug(e.getMessage());
			result.put("msg", "인증서 초기화에 실패하였습니다.\n관리자에게 문의해주세요.");
		}
		
		return result;
	}	
	
	
	
}





