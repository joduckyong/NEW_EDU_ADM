package egovframework.com.aspect;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonLogService;
import egovframework.com.service.CommonMenuService;
import egovframework.com.vo.CommonVO;
import egovframework.com.vo.MenuVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;

@Component
@Aspect
public class IsReadAuthChkAspect implements InitializingBean {
	
	private static final Logger log = LoggerFactory.getLogger(IsReadAuthChkAspect.class);
	
	@Resource(name = "menuService")
    private CommonMenuService menuService;
	
	@Resource(name = "logService")
    private CommonLogService logService;
	
	@Around("@annotation(egovframework.com.auth.PreAuth) && @ annotation(target)")
	public Object doServiceProfilling(ProceedingJoinPoint joinPoint, PreAuth target) throws Throwable {
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpServletResponse res =((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getResponse();
		HashMap<String, Object> logParam = new HashMap<>();
		
		CustomUser user =  SessionUtil.getProperty(req);
		String userId = user.getUserId();
		//String centerCd = user.getCenterId();
		String menuCd = target.menuCd();
		//String menuGrpNo = menuService.selectMenuGrpNoByMenuCd(menuCd);
		
		String ip = getIp(req);
		
		MenuVO pVO = new MenuVO();
		pVO.setMenuCd(menuCd);
		pVO.setUserId(userId);
		HashMap<String, Object>       pstmenuInfo = menuService.selectPresentMenuInfo(pVO);
		
		
		/*
		if( ( "3000".equals(menuGrpNo) || "3010".equals(menuGrpNo) ) && !"10000000".equals(centerCd)){
			
			HashMap<String, Object>  infoMap = menuService.selectRiskAuthInfo(pVO);
			if(null != infoMap){
				String distSeq   = String.valueOf(infoMap.get("DIST_SEQ"));
				String authGrpNo = String.valueOf(infoMap.get("AUTH_GRP_NO"));
				pVO.setDistSeq(distSeq);
				pVO.setAuthGrpNo(authGrpNo);
				
				pstmenuInfo = menuService.selectPresentRiskMenuInfo(pVO);
			}else{
				return "redirect:/ncts/egovNctsMain.do";
			}
			
			
		}else{
			pstmenuInfo = menuService.selectPresentMenuInfo(pVO);
		}
		*/
		
		PageType pageType = target.pageType();
		String procType = "";
		ProcType type = null;
		
		for(Object obj : joinPoint.getArgs()){
			if(obj instanceof CommonVO){
				CommonVO commonVO = (CommonVO)obj;
				commonVO.setMenuCd(menuCd);
			}
		}
		
		boolean isAuth = true;
		
		
		try {
			
			if(pageType.name().equals("LIST")){
				String READ_AT = (String) pstmenuInfo.get("READ_AT");
				if(!"Y".equals(READ_AT)) isAuth = false;
			}else if(pageType.name().equals("FORM")){
				procType = req.getParameter("procType");
				type = ProcType.findByProcType(procType);
				if(type == ProcType.INSERT){
					String INSERT_AT = (String) pstmenuInfo.get("INSERT_AT");
					if(!"Y".equals(INSERT_AT)) isAuth = false;
				}else if(type == ProcType.UPDATE){
					String UPDATE_AT = (String) pstmenuInfo.get("UPDATE_AT");
					if(!"Y".equals(UPDATE_AT)) isAuth = false;
				}else if(type == ProcType.EMPTY){
					String READ_AT = (String) pstmenuInfo.get("READ_AT");
					String INSERT_AT = (String) pstmenuInfo.get("INSERT_AT");
					boolean token = target.token();
					if(!token) isAuth = false;
					if(procType == null){
						if("N".equals(READ_AT) && "Y".equals(INSERT_AT)){
							isAuth = true;
							Object[] args = joinPoint.getArgs();
							for(Object obj : args){
								if(obj instanceof CommonVO){
									((CommonVO) obj).setProcType(ProcType.INSERT.key());
								}
							}	
						} 
					}
				}
			}
		} catch (Exception e) {
			return "redirect:/ncts/egovNctsMain.do";
		}
		
		
		if(!isAuth) return "redirect:/ncts/egovNctsMain.do";
		
		Object returnValue = joinPoint.proceed();
		req.setAttribute("pageInfo", pstmenuInfo);
		
		
		if(null != pageType){
			logParam.put("FRST_IP", ip);
			logParam.put("FRST_REGISTER_ID", userId);
			logParam.put("FRST_REGISTER_CENTER_NM", user.getCenterNm());
			logParam.put("FRST_REGISTER_DEPT_NM", user.getDeptNm());
			logParam.put("FRST_REGISTER_TEAM_NM", user.getTeamNm());
			logParam.put("FRST_REGISTER_QUALF_NM", user.getUserQualfNm());
			logParam.put("REQ_URL", req.getRequestURI());
			logParam.put("REQ_TYPE", "READ");
			logParam.put("REQ_SUCCESS_AT", "success");
			
			
			if(menuCd.matches("30110201") || menuCd.matches("30110202") || menuCd.matches("30110204") || menuCd.matches("30110207")){
				logParam.put("REQ_REGISTER_SEQ", req.getParameter("registerSeq"));	
			}
			
			if(menuCd.matches("120010101") || menuCd.matches("120010201") || menuCd.matches("120010401")
				|| menuCd.matches("120010501") || menuCd.matches("120010601") || menuCd.matches("120020101")
			){
				logParam.put("REQ_REGISTER_SEQ", req.getParameter("registerSeq"));
				logParam.put("REQ_REGISTER_TYPE", "R");
				
				if(menuCd.matches("120010201") && (null == logParam.get("REQ_REGISTER_SEQ") || "".equals(logParam.get("REQ_REGISTER_SEQ")))){
					logParam.put("REQ_REGISTER_SEQ", req.getParameter("progrmSeq"));
					logParam.put("REQ_REGISTER_TYPE", "P");
				}
			}
			
			if(menuCd.matches("120010301") || menuCd.matches("120010302") || menuCd.matches("120010304") || menuCd.matches("120010305")){
				logParam.put("REQ_REGISTER_SEQ", req.getParameter("progrmSeq"));
				logParam.put("REQ_REGISTER_TYPE", "P");
				
				if(null == logParam.get("REQ_REGISTER_SEQ") || "".equals(logParam.get("REQ_REGISTER_SEQ"))){
					logParam.put("REQ_REGISTER_SEQ", req.getParameter("searchCondition1"));
					logParam.put("REQ_REGISTER_TYPE", "P");
				}
			}
			
			if(menuCd.matches("110060301")) {
				logParam.put("REQ_REGISTER_SEQ", req.getParameter("userNo"));
				logParam.put("REQ_REGISTER_TYPE", "E");
			}
			
			String menuNm =  pageType.name().equals("MAIN") ? "메인화면" : (String) pstmenuInfo.get("MENU_NM");
			logParam.put("REQ_MENU_NM", menuNm);
			
			logService.insertSystemLogs(logParam);
		}
		
		return returnValue;
	}
	
	@Override
	public void afterPropertiesSet() throws Exception {
		
	}	
	
	private String getIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
 
        log.info(">>>> X-FORWARDED-FOR : " + ip);
 
        if (ip == null) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        
        return ip;
    }

}

