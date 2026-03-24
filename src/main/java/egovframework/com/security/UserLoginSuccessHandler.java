package egovframework.com.security;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import egovframework.com.ipcheck;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.sessionManager.SessionManager;
import egovframework.com.vo.UserSessionVO;
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
			
			String userId = user.getUserId();
			String ip = ipcheck.getClientIP(req);
			// 1. 기존 세션 조회
			List<UserSessionVO> activeSessions = egovNctsLoginService.selectActiveSessions(userId);
			
			String duplicationMsg = "";
			String newSessionId = session.getId();
			
			if(activeSessions != null && !activeSessions.isEmpty()) {
				
				for(UserSessionVO vo : activeSessions) {
					
					if(!vo.getLoginIp().equals(ip)) {
						duplicationMsg = "기존 로그인은 자동 차단됩니다.";
						
						// 2. 기존 세션 강제 종료
						for (UserSessionVO s : activeSessions) {
							HttpSession oldSession = SessionManager.getSession(s.getSessionId());
							if (oldSession != null) {
								try {
									oldSession.invalidate();
								} catch (IllegalStateException ignore) {}
							}
							
							egovNctsLoginService.deleteUserSession(userId);
						}
						
						// 3. 새 세션 저장
						vo = new UserSessionVO(userId, newSessionId, ip, new Date());
						egovNctsLoginService.insertUserSession(vo);
						session.setAttribute("USER_ID", userId);	
						
					}
				}
			}else {
				
				UserSessionVO vo = new UserSessionVO(userId, newSessionId, ip, new Date());
				egovNctsLoginService.insertUserSession(vo);
				session.setAttribute("USER_ID", userId);	
				
			}
			
			map.put("duplicationMsg", duplicationMsg);
			
							
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
