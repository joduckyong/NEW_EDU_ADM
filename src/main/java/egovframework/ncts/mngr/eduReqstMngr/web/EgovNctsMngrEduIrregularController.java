package egovframework.ncts.mngr.eduReqstMngr.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduIrregularService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;

@Controller
@RequestMapping(value = "/ncts/mngr/eduReqstMngr")
public class EgovNctsMngrEduIrregularController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduIrregularController.class);
	
	@Autowired
	private EgovNctsMngrEduIrregularService mngrEduIrregularService;
	
	@Autowired
    private ExcelDownloadView excelDownloadView;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;		
	
	@PreAuth(menuCd="110020202", pageType=PageType.LIST)
	@RequestMapping(value = "/mngrEduIrregularList.do")
	public String mngrEduIrregularList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrEduVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		CustomUser user = SessionUtil.getProperty(request); 
		if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) if(null != user) pageVO.setsGubun2(user.getCenterId());	
	    List<HashMap<String, Object>> resultList = mngrEduIrregularService.selectNfdrmPlanList(pageVO);
		List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
	    
	    model.addAttribute("list", resultList);
	    model.addAttribute("centerList", centerList);
		return "mngr/eduReqstMngr/mngrEduIrregularList.ncts_content";
	}
	
	@RequestMapping(value = "/selectNfdrmPlanDetail.do")
	public @ResponseBody HashMap<String, Object> selectNfdrmPlanDetail(@ModelAttribute("common") MngrEduVO param) throws Exception {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
            HashMap<String, Object> rs = mngrEduIrregularService.selectNfdrmPlanDetail(param);

            result.put("rs", rs);
            result.put("success", "success");
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
        }
	    return result;    
	}
	
	@RequestMapping(value = "/updateNfdrmPlan.do")
    public @ResponseBody HashMap<String, Object> updateNfdrmPlan(HttpServletRequest request,ModelMap model, @ModelAttribute MngrEduVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            mngrEduIrregularService.updateNfdrmPlan(request, param);
            
            result.put("success", "success");
            result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }
        
        return result;
    }
	
	@RequestMapping(value = "/nfdrmPlanExcelDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rsMap = mngrEduIrregularService.nfdrmPlanExcelDownload(pageVO);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
}
