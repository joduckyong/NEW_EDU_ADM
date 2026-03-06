package egovframework.com.intercepter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import egovframework.com.ipcheck;
import egovframework.com.service.CommonIpChkService;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

public class ipChkInterceptor extends HandlerInterceptorAdapter{
	protected Log log = LogFactory.getLog(ipChkInterceptor.class);
	
	@Autowired
	private CommonIpChkService ipService;
    
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
        return super.preHandle(request, response, handler);
    }
     
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    }
}	
