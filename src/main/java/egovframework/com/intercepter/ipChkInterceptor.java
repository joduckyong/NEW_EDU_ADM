package egovframework.com.intercepter;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import egovframework.com.ipcheck;
import egovframework.com.service.CommonIpChkService;
import egovframework.com.sessionManager.SessionManager;
import egovframework.com.vo.UserSessionVO;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

public class ipChkInterceptor extends HandlerInterceptorAdapter{
	protected Log log = LogFactory.getLog(ipChkInterceptor.class);
	
	@Autowired
	private CommonIpChkService ipService;
    
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;
	
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	
    	String requestUrl = request.getRequestURL().toString(); 
    	if(requestUrl.contains("/egovLoginForm.do")){ 
    		
    		ipAuthVO vo = new ipAuthVO();
    		
	       	vo.setIpAdress(ipcheck.getClientIP());
	       	System.out.println(ipcheck.getClientIP());
	     
	       	request.setAttribute("ipChk", ipService.selectIpChk(vo));
	       	request.setAttribute("ipChk2", ipService.selectIpChk2(vo));
    	};
    	
		HttpSession session =  request.getSession();
		
		String id = (String)session.getAttribute("USER_ID");
        if (session != null && session.getAttribute("USER_ID") != null) {
        	
            String currentSessionId = session.getId();
            String ip = ipcheck.getClientIP(request);
            
            List<UserSessionVO> activeSessions = egovNctsLoginService.selectActiveSessions(id);
			if(activeSessions != null && !activeSessions.isEmpty()) {
				
				for(UserSessionVO vo : activeSessions) {
					
					if(!vo.getLoginIp().equals(ip)) {
						
						// 2. 기존 세션 강제 종료
						for (UserSessionVO s : activeSessions) {
							HttpSession oldSession = SessionManager.getSession(s.getSessionId());
							if (oldSession != null) {
								try {
									oldSession.invalidate();
								} catch (IllegalStateException ignore) {}
							}
							
				            if (vo.getSessionId() != null && !vo.getSessionId().equals(currentSessionId)) {
					            session.setAttribute("userinfo", "");
					            session.invalidate();
					            
					            response.sendRedirect("/ncts/login/msg.do");
//					            response.sendRedirect("/ncts/login/egovLoginForm.do");
					            
					            return false;
				            }
						}
						
					}
				}
			}
        }	
//        return super.preHandle(request, response, handler);
        return true;
    }
     
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    }
}	
