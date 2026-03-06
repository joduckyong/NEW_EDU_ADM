package egovframework.ncts.cmm.login.web;

import java.io.InputStream;
import java.io.InterruptedIOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.com.security.CustomizeUserDetailService;
import egovframework.com.security.vo.CustomUser;
import egovframework.ncts.cmm.login.service.EgovNctsLoginService;
import egovframework.ncts.cmm.login.service.EgovNctsMacService;

@Controller
@RequestMapping(value="/ncts/login/mac")
public class EgovNctsMacController {

	private static final Logger log = LoggerFactory.getLogger(EgovNctsMacController.class);
	private static final int TIME = 60 * 60; // 1시간
	
	@Autowired
	private EgovNctsMacService egovNctsMacService;	
	
	@Autowired
	private EgovNctsLoginService egovNctsLoginService;	
	
	@Autowired
	private CustomizeUserDetailService customizeUserDetailService;

	@RequestMapping(value = "/macServerCheck.do")
	public @ResponseBody HashMap<String, Object> macServerCheck(@ModelAttribute CustomUser customUser) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> param = new HashMap<>();
		CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(customUser.getUserId());
		param.put("macPort", user.getMacPort());
		param.put("serverIp", InetAddress.getLocalHost().getHostAddress());
		result.put("result", egovNctsMacService.selectMacServerPortAt(param));
		return result;
	}	
	
	@RequestMapping(value = "/macCheck.do")
	public @ResponseBody HashMap<String, Object> macCheck(HttpServletRequest request, HttpServletResponse response,RedirectAttributes redirectAttributes, Authentication auth) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		String pcMac = "";
		HashMap<String, Object> param = new HashMap<>();
		// TCP Socket
		CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(request.getParameter("userId"));
		
		if(null == user.getMacPort() || "".equals(user.getMacPort())) {
			result.put("errorMsg", "포트 설정 후 시도해주시기를 바랍니다.");
			return result;
		}
		int port = Integer.parseInt(user.getMacPort());		
		param.put("macPort", port);
		param.put("serverIp", InetAddress.getLocalHost().getHostAddress());
		
		ServerSocket server = new ServerSocket();
		try {
			server.bind(new InetSocketAddress(port));
			server.setSoTimeout(30000);
			param.put("macServerAt", "Y");
			egovNctsMacService.updateMacServerPortAt(param);
			log.debug("create Server Port : " + port);
		} catch(SocketException e) {
			log.debug(e.getMessage());
			result.put("errorMsg", "현재 로그인 시도중입니다. <br>잠시 후 다시 시도해주시기를 바랍니다.");
			return result;
		}
		
		Socket client = new Socket();
		while (true) {
			try {
				client = server.accept(); 
				client.setSoTimeout(30000); // 30 seconds timeout
				
				if (client.isConnected()) {
					log.debug("@@ Client connected from " + client.getInetAddress());
					
					// Getting input and output streams from the socket
					InputStream in = client.getInputStream();
				    
					// Receiving data from the client
					byte[] buffer = new byte[256];
					int bytesReceived = in.read(buffer);
					pcMac = new String(buffer, 0, bytesReceived);
					log.debug("Received Mac-Addr from client: " + pcMac);
					
					client.close();
					server.close();
					log.debug("Client connection closed.");
					param.put("macServerAt", "N");
					egovNctsMacService.updateMacServerPortAt(param);
					//사용자의 맥주소 조회
					List<HashMap<String, Object>> userMacList = customizeUserDetailService.selectUserMacAddress(request.getParameter("userId"));
					for(HashMap<String, Object> tmp : userMacList){
						if(pcMac.equals(tmp.get("MAC_ADDR_W")) || pcMac.equals(tmp.get("MAC_ADDR_C"))) {
							//CustomUser user = (CustomUser) customizeUserDetailService.loadUserByUsername(request.getParameter("userId"));
							Authentication authentication  = new UsernamePasswordAuthenticationToken(user, user.getPassword(), user.getAuthorities());
							SecurityContext securityContext = SecurityContextHolder.getContext();
							securityContext.setAuthentication(authentication);
							
							user.setFailrCnt("0");
							egovNctsLoginService.updateFailrCnt(user);
							
							HttpSession session = request.getSession(true);
							session.setMaxInactiveInterval(TIME);
							session.setAttribute("SPRING_SECURITY_CONTEXT",securityContext);   // 세션에 spring security context 넣음
							session.setAttribute("userinfo", authentication.getPrincipal());							
							
							result.put("success", "success");
							result.put("targetUrl", "/ncts/egovNctsMain.do");
						}
					}
					return result;
				}
			} catch(SocketTimeoutException e) {
				param.put("macServerAt", "N");
				egovNctsMacService.updateMacServerPortAt(param);
				result.put("errorMsg", "30초가 지나 종료되었습니다. <br>다시 시도해주시기를 바랍니다.");
				log.debug("ServerSocket Timeout @@ " + e.getMessage());
				break;
			} catch (InterruptedIOException e) {
				param.put("macServerAt", "N");
				egovNctsMacService.updateMacServerPortAt(param);
				result.put("errorMsg", "30초가 지나 종료되었습니다. <br>다시 시도해주시기를 바랍니다.");
				log.debug("Socket Timeout @@ " + e.getMessage());
				break;
			} catch (Exception e) { 
				param.put("macServerAt", "N");
				egovNctsMacService.updateMacServerPortAt(param);
				result.put("errorMsg", "다시 시도해주시기를 바랍니다.");
				log.debug("Exception @@ " + e.getMessage());
				break;
			} finally {
				if(null != client) client.close();
				if(null != server) server.close();
			}
			
		}	
		return result;
	}
}
