package egovframework.ncts.mngr.statMngr.web;

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
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.statMngr.service.EgovNctsMngrStatService;


@Controller
@RequestMapping(value = "/ncts/mngr/statMngr")
public class EgovNctsMngrStatController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrStatController.class);
    
    @Autowired
    private EgovNctsMngrStatService egovNctsMngrStatService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private ExcelDownloadView excelDownloadView;
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110090101", pageType=PageType.LIST)
    @RequestMapping(value = "/stMngr001.do")
    public String stMngr001 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> MngrCnt001N1 = null;
    	HashMap<String, Object> MngrCnt001N2 = null;
    	HashMap<String, Object> MngrCnt001N3 = null;
    	HashMap<String, Object> MngrNum001N1 = null;
    	HashMap<String, Object> MngrNum001N2 = null;
    	HashMap<String, Object> MngrNum001N3 = null;
    	HashMap<String, Object> MngrGroupNum001N1 = null;
    	HashMap<String, Object> MngrGroupNum001N2 = null;
    	HashMap<String, Object> MngrGroupNum001N3 = null;
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
    	List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        
        if(!(null == pageVO.getsDate01() || "".equals(pageVO.getsDate01()))) {
        	
        	pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
        	MngrCnt001N2 = egovNctsMngrStatService.selectStMngrCnt001(pageVO);
        	MngrNum001N2 = egovNctsMngrStatService.selectStMngrNum001(pageVO);
        	MngrGroupNum001N2 = egovNctsMngrStatService.selectStMngrGroupNum001(pageVO);
        	
        	pageVO.setSearchCondition1("");
        	pageVO.setSearchCondition2(pageVO.getsYear());
        	MngrCnt001N3 = egovNctsMngrStatService.selectStMngrCnt001(pageVO);
        	MngrNum001N3 = egovNctsMngrStatService.selectStMngrNum001(pageVO);
        	MngrGroupNum001N3 = egovNctsMngrStatService.selectStMngrGroupNum001(pageVO);
        	
        	pageVO.setSearchCondition2("");
        	MngrCnt001N1 = egovNctsMngrStatService.selectStMngrCnt001(pageVO);
        	MngrNum001N1 = egovNctsMngrStatService.selectStMngrNum001(pageVO);
        	MngrGroupNum001N1 = egovNctsMngrStatService.selectStMngrGroupNum001(pageVO);
        }
        
		model.addAttribute("centerList", CenterList);        
        model.addAttribute("cal", year);
        model.addAttribute("MngrCnt001N1", MngrCnt001N1); 
        model.addAttribute("MngrCnt001N2", MngrCnt001N2); 
        model.addAttribute("MngrCnt001N3", MngrCnt001N3); 
        model.addAttribute("MngrNum001N1", MngrNum001N1); 
        model.addAttribute("MngrNum001N2", MngrNum001N2); 
        model.addAttribute("MngrNum001N3", MngrNum001N3); 
        model.addAttribute("MngrGroupNum001N1", MngrGroupNum001N1);
        model.addAttribute("MngrGroupNum001N2", MngrGroupNum001N2);
        model.addAttribute("MngrGroupNum001N3", MngrGroupNum001N3);
        
        return "mngr/statMngr/stMngr001.ncts_content";
    }
    
    @PreAuth(menuCd="110090102", pageType=PageType.LIST)
    @RequestMapping(value = "/stMngr002.do")
    public String stMngr002 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> MngrCnt002N1 = null;
    	HashMap<String, Object> MngrCnt002N2 = null;
    	HashMap<String, Object> MngrCnt002N3 = null;
    	HashMap<String, Object> MngrNum002N1 = null;
    	HashMap<String, Object> MngrNum002N2 = null;
    	HashMap<String, Object> MngrNum002N3 = null;
    	HashMap<String, Object> MngrGroupNum002N1 = null;
    	HashMap<String, Object> MngrGroupNum002N2 = null;
    	HashMap<String, Object> MngrGroupNum002N3 = null;
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
    	
    	if(!(null == pageVO.getsDate01() || "".equals(pageVO.getsDate01()))) {
        	
        	pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
        	MngrCnt002N2 = egovNctsMngrStatService.selectStMngrCnt002(pageVO);
        	MngrNum002N2 = egovNctsMngrStatService.selectStMngrNum002(pageVO);
        	MngrGroupNum002N2 = egovNctsMngrStatService.selectStMngrGroupNum002(pageVO);
        	
        	pageVO.setSearchCondition1("");
        	pageVO.setSearchCondition2(pageVO.getsYear());
        	MngrCnt002N3 = egovNctsMngrStatService.selectStMngrCnt002(pageVO);
        	MngrNum002N3 = egovNctsMngrStatService.selectStMngrNum002(pageVO);
        	MngrGroupNum002N3 = egovNctsMngrStatService.selectStMngrGroupNum002(pageVO);
        	
        	pageVO.setSearchCondition2("");
        	MngrCnt002N1 = egovNctsMngrStatService.selectStMngrCnt002(pageVO);
        	MngrNum002N1 = egovNctsMngrStatService.selectStMngrNum002(pageVO);
        	MngrGroupNum002N1 = egovNctsMngrStatService.selectStMngrGroupNum002(pageVO);
        }
    	
    	model.addAttribute("centerList", CenterList);
    	model.addAttribute("cal", year);
    	model.addAttribute("MngrCnt002N1", MngrCnt002N1);
    	model.addAttribute("MngrCnt002N2", MngrCnt002N2);
    	model.addAttribute("MngrCnt002N3", MngrCnt002N3);
    	model.addAttribute("MngrNum002N1", MngrNum002N1);
    	model.addAttribute("MngrNum002N2", MngrNum002N2);
    	model.addAttribute("MngrNum002N3", MngrNum002N3);
    	model.addAttribute("MngrGroupNum002N1", MngrGroupNum002N1);
    	model.addAttribute("MngrGroupNum002N2", MngrGroupNum002N2);
    	model.addAttribute("MngrGroupNum002N3", MngrGroupNum002N3);
    	
    	return "mngr/statMngr/stMngr002.ncts_content";
    }
    
    @PreAuth(menuCd="110090103", pageType=PageType.LIST)
    @RequestMapping(value = "/stMngr003.do")
    public String stMngr003 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> MngrCnt003N1 = null;
    	HashMap<String, Object> MngrCnt003N2 = null;
    	HashMap<String, Object> MngrCnt003N3 = null;
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
		
       	if(!(null == pageVO.getsDate01() || "".equals(pageVO.getsDate01()))) {
        	
        	pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
        	MngrCnt003N2 = egovNctsMngrStatService.selectStMngrCnt003(pageVO);
        	
        	pageVO.setSearchCondition1("");
        	pageVO.setSearchCondition2(pageVO.getsYear());
        	MngrCnt003N3 = egovNctsMngrStatService.selectStMngrCnt003(pageVO);
        	
        	pageVO.setSearchCondition2("");
        	MngrCnt003N1 = egovNctsMngrStatService.selectStMngrCnt003(pageVO);
        }    	
    	
       	model.addAttribute("centerList", CenterList);
    	model.addAttribute("cal", year);
    	model.addAttribute("MngrCnt003N1", MngrCnt003N1);
    	model.addAttribute("MngrCnt003N2", MngrCnt003N2);
    	model.addAttribute("MngrCnt003N3", MngrCnt003N3);
    	
    	return "mngr/statMngr/stMngr003.ncts_content";
    }
    
    @RequestMapping(value = "/statMngrExcelDownload.do")
	public void statMngrExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> rsMap = egovNctsMngrStatService.statMngrExcelDownload(pageVO);
    	
    	HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
		String fileName = (String) rsMap.get("fileName");
		String templateFile = (String)  rsMap.get("templateFile");
		
    	excelDownloadView.download(request, response, paramMap, fileName, templateFile);
	}
    
  
    @PreAuth(menuCd="110090201", pageType=PageType.LIST)
    @RequestMapping(value = "/stGnrlMngr001.do")
    public String stGnrlMngr001 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> GnrlMngr001N1 = null;
    	HashMap<String, Object> GnrlMngr001N2 = null;
    	HashMap<String, Object> GnrlMngr001N3 = null;
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
    	
    	if(!(null == pageVO.getsDate01() || "".equals(pageVO.getsDate01()))) {
    		
    		pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
    		GnrlMngr001N2 = egovNctsMngrStatService.selectStGnrlMngr001(pageVO);
    		
    		pageVO.setSearchCondition1("");
    		pageVO.setSearchCondition2(pageVO.getsYear());
    		GnrlMngr001N3 = egovNctsMngrStatService.selectStGnrlMngr001(pageVO);
    		
    		pageVO.setSearchCondition2("");
    		GnrlMngr001N1 = egovNctsMngrStatService.selectStGnrlMngr001(pageVO);
    	}   
    	
    	model.addAttribute("centerList", CenterList);
    	model.addAttribute("cal", year);
    	model.addAttribute("GnrlMngr001N1", GnrlMngr001N1); 
    	model.addAttribute("GnrlMngr001N2", GnrlMngr001N2); 
    	model.addAttribute("GnrlMngr001N3", GnrlMngr001N3); 
    	
    	return "mngr/statMngr/stGnrlMngr001.ncts_content";
    }
    
    @PreAuth(menuCd="110090202", pageType=PageType.LIST)
    @RequestMapping(value = "/stGnrlMngr002.do")
    public String stGnrlMngr002 (HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	HashMap<String, Object> GnrlMngr002N1 = null;
    	HashMap<String, Object> GnrlMngr002N2 = null;
    	HashMap<String, Object> GnrlMngr002N3 = null;
    	HashMap<String,ArrayList<String>> year = DateUtil.yearList(20,2);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
    	
    	if(!(null == pageVO.getsDate01() || "".equals(pageVO.getsDate01()))) {
    		
    		pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
    		GnrlMngr002N2 = egovNctsMngrStatService.selectStGnrlMngr002(pageVO);
    		
    		pageVO.setSearchCondition1("");
    		pageVO.setSearchCondition2(pageVO.getsYear());
    		GnrlMngr002N3 = egovNctsMngrStatService.selectStGnrlMngr002(pageVO);
    		
    		pageVO.setSearchCondition2("");
    		GnrlMngr002N1 = egovNctsMngrStatService.selectStGnrlMngr002(pageVO);
    	}
    	
    	model.addAttribute("centerList", CenterList);
    	model.addAttribute("cal", year);
    	model.addAttribute("GnrlMngr002N1", GnrlMngr002N1);
    	model.addAttribute("GnrlMngr002N2", GnrlMngr002N2);
    	model.addAttribute("GnrlMngr002N3", GnrlMngr002N3);
    	
    	return "mngr/statMngr/stGnrlMngr002.ncts_content";
    }
    
}