package egovframework.ncts.mngr.shareMngr.web;


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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.CookieGenerator;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.file.controller.ExcelDownloadView;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.shareMngr.service.EgovNctsMngrShareService;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;



@Controller
@RequestMapping(value = "/ncts/mngr/shareMngr")
public class EgovNctsMngrShareController {
	
	  private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrShareController.class);	

	  @Autowired
	  private EgovNctsMngrShareService egovNctsShareService;
	  
	  @Autowired
	  private EgovNctsSysDeptService egovNctsSysDeptService;
	  
		/*
		 * @Autowired private ExcelDownloadView excelDownloadView;
		 */
	  
	  @PreAuth(menuCd="110080201", pageType=PageType.LIST)
	  @RequestMapping(value = "/mngrShareList.do") 
	  public String selectShareList(HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrShareVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO)throws Exception {
		  
			
			  CustomUser user = SessionUtil.getProperty(request);
			  
			  if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) if(null != user) pageVO.setCenterCd(user.getCenterId());
			     
	    	
	    	List<HashMap<String, Object>> list = null;

	        list =	egovNctsShareService.selectShareList(pageVO);
	        		
	        List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
	        model.addAttribute("list", list);
	        model.addAttribute("centerList", centerList);
	 
		  return "mngr/shareMngr/mngrShareList.ncts_content"; 
	  
	  }
	  
	  
	  @RequestMapping(value="/mngrShareDetail.do")
		public @ResponseBody HashMap<String, Object> mngrShareDetail (HttpServletRequest request, ModelMap model,@ModelAttribute MngrShareVO param){
			
			HashMap<String, Object> result = new HashMap<>();
			try {
				HashMap<String, Object> rs = egovNctsShareService.selectShareListDetail(param);
				
	            result.put("rs", rs);
				result.put("success", "success");
				
			} catch (IOException e) {
				 LOGGER.debug(e.getMessage());
				   result.put("success", "error");
			}catch (Exception e) {
			   LOGGER.debug(e.getMessage());
			   result.put("success", "error");
			}
			return result;
			
		}

	  
	   @PreAuth(menuCd="110080201", pageType=PageType.FORM)
	   @RequestMapping(value="/mngrShareForm.do")
	   public String ShareListInsert(HttpServletRequest request,RedirectAttributes redirectAttributes,ModelMap model, @ModelAttribute("common") MngrShareVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception{
		   
		   String atchFileId = "";
		   ProcType procType = ProcType.findByProcType(param.getProcType());	
			
		   HashMap<String, Object> result = new HashMap<>();	
						
			if (ProcType.UPDATE.equals(procType)) {
				result=egovNctsShareService.selectShareListDetail(param);
				atchFileId = org.apache.commons.lang.StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
				model.addAttribute("result", result);
			}
			
			List<HashMap<String, Object>> centerList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
	        model.addAttribute("centerList", centerList);
			
			StringBuffer markup = FileUploadMarkupBuilder.newInstance()
	                .fileDownYn(true)
	                .btnYn(true)
	                .atchFileId(atchFileId)
	                .fileTotal(5)
	                .build();
			
			
			model.addAttribute("markup", markup);
			
			
			
			return "mngr/shareMngr/mngrShareForm.ncts_content";
		   
		   
	   }
	    
	    @AuthCheck(menuCd="110080201")
		@RequestMapping(value = "/mngrProgressShare.do")
		public @ResponseBody HashMap<String, Object> mngrProgressShare(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, ModelMap model, @ModelAttribute MngrShareVO param) throws Exception{
			
	    	 HashMap<String, Object> result = new HashMap<>();
		        
		        try {
		            if (ProcType.isFindFileUpload(param.getProcType())) {
		                String atchFileId = FileUploadBuilder
		                        .getInstance()
		                        .multiRequest(multiRequest)
		                        .storePath("share")     // 저장위치
		                        .keyStr("share_") // 파일명키
		                        .procType(ProcType.findByProcType(param.getProcType()))
		                        .atchFileId(param.getAtchFileId())
		                        .fileKey(0)
		                        .build();
		                
		                if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);
		            }
		            
		        	CustomUser user = SessionUtil.getProperty(request);
		    		if(null != user) {
		    			param.setFrstRegisterId(user.getUserId());
		    			param.setLastUpdusrId(user.getUserId());
		    		}
		            
		    		egovNctsShareService.shareProgress(param);
		            
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
	   
	    @AuthCheck(menuCd="110080201")
	    @RequestMapping(value = "/mngrDeleteShareList.do")
	    public @ResponseBody HashMap<String, Object> deleteShareList (HttpServletRequest request,ModelMap model, @ModelAttribute MngrShareVO param) throws Exception{
	        HashMap<String, Object> result = new HashMap<>();
	        try {
	        	CustomUser user = SessionUtil.getProperty(request);
	    		if(null != user) param.setLastUpdusrId(user.getUserId());
	        	
	    		egovNctsShareService.shareProgress(param);
	    		
	            
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
	  
	    
		/*
		 * @RequestMapping(value = "/shareExcelDownload.do") public void
		 * statExcelDownload(HttpServletRequest request, HttpServletResponse response,
		 * ModelMap model,@ModelAttribute("paginationInfo") PageInfoVO pageVO) throws
		 * Exception {
		 * 
		 * 
		 * HashMap<String, Object> rsMap =
		 * egovNctsShareService.selectCommonExcel(pageVO);
		 * 
		 * HashMap<String, Object> paramMap = (HashMap<String, Object>)
		 * rsMap.get("paramMap"); String fileName = (String) rsMap.get("fileName");
		 * String templateFile = (String) rsMap.get("templateFile");
		 * 
		 * CookieGenerator cg = new CookieGenerator();
		 * cg.setCookieName("fileDownloadToken"); cg.setCookiePath("/");
		 * cg.addCookie(response, "true");
		 * 
		 * excelDownloadView.download(request, response, paramMap, fileName,
		 * templateFile); }
		 */
	 
	 

}
