package egovframework.com.security;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.Sha256Crypto;
import egovframework.com.security.vo.CustomUser;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;

public class UserLoginSuccessHandler implements AuthenticationSuccessHandler {

	private static final Logger logger = LoggerFactory.getLogger(UserLoginSuccessHandler.class);

	private static final int TIME = 60 * 60; // 1시간
	
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;	

	@Override
	public void onAuthenticationSuccess(HttpServletRequest req, HttpServletResponse res, Authentication auth)
			throws IOException, ServletException {
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			CustomUser user = (CustomUser) auth.getPrincipal();
			HttpSession session = req.getSession();
			
			// 사용자 비밀번호 실패건수 update
			user.setFailrCnt("0");
			egovNctsLoginService.updateFailrCnt(user);
			
			
			
			/*session.setMaxInactiveInterval(TIME);
			session.setAttribute("userinfo", auth.getPrincipal());*/
			// master일 경우는 인증서 pass처리 main으로 바로 접속 
			//if("master".equals(user.getUserId()) || "kmlw".equals(user.getUserId())) {
				session.setMaxInactiveInterval(TIME);
				session.setAttribute("userinfo", auth.getPrincipal());
			//}
			
			String pwChgYn = "N";
			// 사용자 비밀번호가 초기비밀번호(1111)일 경우 세션을 지워준다(지우지 않을 경우 시스템 오류 발생)
			if (Sha256Crypto.authenticate("1111", user.getUserPw())) {
				pwChgYn = "Y";
				session.invalidate();
			}
			
			
			
							
			map.put("result", "success");
			map.put("pwChgYn", pwChgYn);
			map.put("userId", user.getUserId());
			map.put("targetUrl", "/ncts/egovNctsMain.do");
			
			ObjectMapper om = new ObjectMapper();
			String jsonString = om.writeValueAsString(map);
			OutputStream out = res.getOutputStream();
			out.write(jsonString.getBytes());			
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}
	
	}

}
