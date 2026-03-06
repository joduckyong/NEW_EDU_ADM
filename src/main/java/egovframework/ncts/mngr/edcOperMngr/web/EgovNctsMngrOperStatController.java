package egovframework.ncts.mngr.edcOperMngr.web;

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

import egovframework.com.DateUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.edcOperMngr.service.EgovNctsMngrOperStatService;


@Controller
@RequestMapping(value = "/ncts/mngr/edcOperMngr")
public class EgovNctsMngrOperStatController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrOperStatController.class);
    
    @Autowired
    private EgovNctsMngrOperStatService egovNctsMngrOperStatService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110030501", pageType=PageType.LIST)
    @RequestMapping(value = "/stMngr004.do")
    public String stMngr001 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
    	List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        
    	HashMap<String, Object> yearEduList = egovNctsMngrOperStatService.selectYearEduList(pageVO);		
    	model.addAttribute("year", year);    	
    	model.addAttribute("CenterList", CenterList);    	
		model.addAttribute("yearEduList", yearEduList);    	
        
        return "mngr/edcOperMngr/stMngr004.ncts_content";
    }
    
    
    @RequestMapping(value = "/statMngrOperExcelDownload.do")
	public void statMngrOperExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> rsMap = egovNctsMngrOperStatService.statYearEduExcelDownload(pageVO);
    	
		String fileName = (String) pageVO.getExcelFileNm();
		String templateFile = (String) pageVO.getExcelPageNm();
		
    	excelDownloadView.download(request, response, rsMap, fileName, templateFile);
	}
    
  
    
}