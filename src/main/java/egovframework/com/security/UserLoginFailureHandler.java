package egovframework.com.security;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.security.vo.CustomUser;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;

public class UserLoginFailureHandler implements AuthenticationFailureHandler {

	private static final Logger logger = LoggerFactory.getLogger(UserLoginFailureHandler.class);
	
	@Autowired
	private CustomizeUserDetailService customizeUserDetailService;
	
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest req, HttpServletResponse res, AuthenticationException auth)
			throws IOException, ServletException {
		ObjectMapper om = new ObjectMapper();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", "fail");
		map.put("msg", auth.getMessage());
		
		if(auth instanceof CredentialsExpiredException) {
			try {
				String userId = req.getParameter("userId");
				CustomUser user = new CustomUser();
				user.setUserId(userId);
				user.setFailrCnt("99");
				egovNctsLoginService.updateFailrCnt(user);
				user = (CustomUser) customizeUserDetailService.loadUserByUsername(userId);
				if(null != user) {
					if(5 <= Integer.parseInt(user.getFailrCnt())) egovNctsLoginService.updateLockAt(userId); 
				}
			} catch (Exception e) {
				logger.debug(e.getMessage());
			}
		}
		
		String jsonString = om.writeValueAsString(map);

		OutputStream out = res.getOutputStream();
		out.write(jsonString.getBytes());
	}

}
