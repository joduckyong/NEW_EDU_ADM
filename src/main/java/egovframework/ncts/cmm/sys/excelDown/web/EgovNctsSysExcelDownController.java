package egovframework.ncts.cmm.sys.excelDown.web;

import java.util.ArrayList;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.CookieGenerator;

import egovframework.com.DateUtil;
import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.excelDown.service.EgovNctsSysExcelDownService;
import egovframework.ncts.cmm.sys.excelDown.vo.ExcelDownVO;
import egovframework.ncts.cmm.sys.log.vo.LogVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Controller
@RequestMapping(value = "/ncts/cmm/sys/excelDown")
public class EgovNctsSysExcelDownController {
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsSysExcelDownController.class);
	
	@Autowired
	private EgovNctsSysExcelDownService egovNctsSysExcelDownService;
	
	@Autowired
    private ExcelDownloadView excelDownloadView;
	
	@PreAuth(menuCd="90060301", pageType=PageType.LIST)
	@RequestMapping(value = "/excelDownList.do")
	public String menuList(ModelMap model,@ModelAttribute("common") LogVO logVO, HttpServletResponse response, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);

		List<HashMap<String, Object>> rslist = (List<HashMap<String, Object>>)egovNctsSysExcelDownService.selectExcelList(pageVO);
		
		model.addAttribute("cal", year);
		model.addAttribute("rslist", rslist);
		
		return "cmm/sys/excelDown/excelDownList.ncts_content";
	}
	
	@PreAuth(menuCd="90060301", pageType=PageType.FORM, token=true)
	@RequestMapping(value = "/excelDownForm.do")
	public String excelDownForm(ModelMap model,@ModelAttribute("common") ExcelDownVO param, HttpServletResponse response, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
		HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
		HashMap<String, Object> result = new HashMap<>();
		result = egovNctsSysExcelDownService.selectExcelListDetail(param);
		
		model.addAttribute("cal", year);
		model.addAttribute("result", result);
		
		return "cmm/sys/excelDown/excelDownForm.ncts_content";
	}
	
	@RequestMapping(value = "/insertExcelResn.do")
	public @ResponseBody HashMap<String, Object> insertExcelResn(HttpServletRequest request,ModelMap model, @ModelAttribute ExcelDownVO param) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		CustomUser user = SessionUtil.getProperty(request);
		if(null != user) param.setFrstRegisterId(user.getUserId());
		try {
			egovNctsSysExcelDownService.insertExcelResn(param);
			result.put("success", "success");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		return result;
	}	
	
	@AuthCheck(menuCd="90060301")
	@RequestMapping(value = "/updateExcelDown.do")
	public @ResponseBody HashMap<String, Object> updateExcelDown(final MultipartHttpServletRequest multiRequest,HttpServletRequest request,ModelMap model, @ModelAttribute ExcelDownVO param) throws Exception{
	    HashMap<String, Object> result = new HashMap<>();
		CustomUser user = SessionUtil.getProperty(request);
	    try {
	    	
	    	egovNctsSysExcelDownService.updateExcelDown(param);

	     result.put("success", "success");
	     result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
	    }catch (Exception e) {
	     LOGGER.debug(e.getMessage());
	     result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
	    }
	    return result;
	}
	
	@AuthCheck(menuCd="90060301")
	@RequestMapping(value="/deleteExcelDown.do")
	 public @ResponseBody HashMap<String, Object> deleteRecvry2Register(HttpServletRequest request,ModelMap model,@ModelAttribute ExcelDownVO param)throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			egovNctsSysExcelDownService.deleteExcelDown(param);
			 result.put("success", "success");
             result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		} catch (Exception e) {
			  LOGGER.debug(e.getMessage());
              result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		return result;
	 }
	
	@RequestMapping(value = "/excelDownload.do")
    public void excelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsSysExcelDownService.selectExcelDownList(pageVO); 
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        CookieGenerator cg = new CookieGenerator();
        cg.setCookieName("fileDownloadToken");
        cg.setCookiePath("/");
        cg.addCookie(response, "true");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }
}
