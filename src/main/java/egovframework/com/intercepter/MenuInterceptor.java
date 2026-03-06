package egovframework.com.intercepter;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonMenuService;
import egovframework.com.vo.MenuVO;

public class MenuInterceptor extends HandlerInterceptorAdapter{
	
	@Resource(name = "menuService")
    private CommonMenuService menuService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
		PreAuth annotation = ((HandlerMethod) handler).getMethodAnnotation(PreAuth.class);

		if(annotation != null){
			CustomUser customUser = SessionUtil.getProperty(request);
			String userId = customUser.getUserId();
			String menuCd = annotation.menuCd();
			String centerCd = customUser.getCenterId();
			MenuVO pVO = new MenuVO();
			pVO.setMenuCd(menuCd);
			pVO.setUserId(userId);
			List<HashMap<String, Object>> highmenu = menuService.selectUseHighMenuList(pVO); 
			if(!"00000000".equals(menuCd)){
				
				String menuGrpNo = menuService.selectMenuGrpNoByMenuCd(menuCd);
				pVO.setMenuGrpNo(menuGrpNo);
				
				if( ( "3000".equals(menuGrpNo) || "3010".equals(menuGrpNo) ) && !"10000000".equals(centerCd)){
					HashMap<String, Object>  infoMap = menuService.selectRiskAuthInfo(pVO);
					if(null != infoMap){
						String distSeq   = String.valueOf(infoMap.get("DIST_SEQ"));
						String authGrpNo = String.valueOf(infoMap.get("AUTH_GRP_NO"));
						pVO.setDistSeq(distSeq);
						pVO.setAuthGrpNo(authGrpNo);
						setRiskMenu(pVO);
					}else{
						FlashMap flashMap = new FlashMap();
						flashMap.put("ErrorMsg", "권한이 없거나 기간이 만료되었습니다.");
						FlashMapManager flashMapManager = RequestContextUtils.getFlashMapManager(request);
						flashMapManager.saveOutputFlashMap(flashMap, request, response);
						response.sendRedirect("/ncts/egovNctsMain.do");
						return false;
					}
				}else{
					setCommonMenu(pVO);
				}

				request.setAttribute("leftmenu", pVO.getLeftmenu());
				request.setAttribute("tabmenu", pVO.getTabmenu());
				request.setAttribute("menuCd", menuCd);
			}
			request.setAttribute("highmenu", highmenu);
		}/*else{
			if(authCheck != null){
				return true;
			}
			response.sendRedirect("/ncts/egovNctsMain.do");
			return false;
		}*/
		
	    return true;
	}
	
	
	public void setCommonMenu(MenuVO pVO) throws Exception{ 
		pVO.setLeftmenu(menuService.selectUseLeftMenuList(pVO)); 
		pVO.setTabmenu(menuService.selectUseTabMenuList(pVO)); 
	}
	
	public void setRiskMenu(MenuVO pVO) throws Exception{
		pVO.setLeftmenu(menuService.selectUseLeftRiskMenuList(pVO)); 
		pVO.setTabmenu(menuService.selectUseTabRiskMenuList(pVO)); 
	}
	

	/*@Override
	public void postHandle(	HttpServletRequest request, HttpServletResponse response,
			Object handler, ModelAndView modelAndView) throws Exception {
		System.out.println("############### postHandle executed---");
	}
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
			Object handler, Exception ex) throws Exception {
		System.out.println("############### afterCompletion Completed---");
	}*/
}
