package egovframework.ncts.mngr.simsaMngr.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
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
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;
import egovframework.ncts.mngr.shareMngr.web.EgovNctsMngrShareController;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaService;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

@Controller
@RequestMapping(value = "/ncts/mngr/simsaMngr")
public class EgovNctsMngrSimsaController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrShareController.class);

	@Autowired
	private EgovNctsMngrSimsaService egovNctsSimsaService;
	
	@Autowired
    private ExcelDownloadView excelDownloadView;

	@PreAuth(menuCd = "110110101", pageType = PageType.LIST)
	@RequestMapping(value = "/mngrSimsaList.do")
	public String selectSimsaList(HttpServletRequest request, ModelMap model,
			@ModelAttribute("common") MngrSimsaManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute MngrSimsaApplicantVO VO)
			throws Exception {

		CustomUser user = SessionUtil.getProperty(request);
		//ProcType procType = ProcType.findByProcType(param.getProcType());

		if (!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request)))
			if (null != user)
				pageVO.setCenterCd(user.getCenterId());

		List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) egovNctsSimsaService.selectSimsaList(pageVO);

		HashMap<String, Object> result = new HashMap<>();
			result = egovNctsSimsaService.selectSimsaListDetail(param);
			
			model.addAttribute("list", list);
			model.addAttribute("result", result);
			
				
		
		return "mngr/simsaMngr/mngrSimsaList.ncts_content";

	}

	@RequestMapping(value = "/simsaListDetail.do")
	public @ResponseBody HashMap<String, Object> mngrSimsaDetail(HttpServletRequest request, ModelMap model,
			@ModelAttribute MngrSimsaManageVO param, @ModelAttribute MngrSimsaApplicantVO VO) {

		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> list = null;
		HashMap<String, Object> allList = null;

		try {
			list = egovNctsSimsaService.selectSimsaAppListMain(VO);
			HashMap<String, Object> rs = egovNctsSimsaService.selectSimsaListDetail(param);
			allList = egovNctsSimsaService.selectAll(VO);
			
			
			result.put("allList", allList);
			result.put("rs", rs);
			result.put("de", list);
			result.put("success", "success");

		} catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		return result;

	}

	@PreAuth(menuCd = "110110101", pageType = PageType.FORM)
	@RequestMapping(value = "/mngrSimsaForm.do") 
	public String ShareListInsert(HttpServletRequest request, RedirectAttributes redirectAttributes, ModelMap model,
			@ModelAttribute("common") MngrSimsaManageVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO)
			throws Exception {

		ProcType procType = ProcType.findByProcType(param.getProcType());

		HashMap<String, Object> result = new HashMap<>();

		if (ProcType.UPDATE.equals(procType)) {

			result = egovNctsSimsaService.selectSimsaListDetail(param);
			model.addAttribute("result", result);

		}

		return "mngr/simsaMngr/mngrSimsaList.ncts_content";

	}


	@AuthCheck(menuCd = "110110101")
	@RequestMapping(value = "/mngrSimsaProcess.do")
	public @ResponseBody List<HashMap<String, Object>> mngrProgressSimsa(HttpServletRequest request, ModelMap model,
			@ModelAttribute MngrSimsaManageVO param) throws Exception {

		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> rr = new ArrayList<HashMap<String,Object>> ();
	    
		try {

			CustomUser user = SessionUtil.getProperty(request);
			if (null != user) {
				param.setFrstRegisterId(user.getUserId());
				param.setLastUpdusrId(user.getUserId());
			}
			
			
				
				int actCnt = egovNctsSimsaService.selectSimsaActiveCnt(param);
				
				if(actCnt >= 1 && "Y".equals(param.getUseAt())) { 
					
					result.put("actCnt", actCnt);
					rr.add(result);
				
				}else { 
					
					egovNctsSimsaService.simsaProcess(param);
					result.put("success", "success");
					result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
					rr.add(result);
				
				}
		
		} catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
			rr.add(result);

		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
			rr.add(result);
		}

		return rr;
	}

	
	@AuthCheck(menuCd = "110110101")
	@RequestMapping(value = "/mngrSimsaDelete.do")
	public @ResponseBody List<HashMap<String, Object>> mngrDeleteSimsa(HttpServletRequest request, ModelMap model,
			@ModelAttribute MngrSimsaManageVO param) throws Exception {

		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> dd = new ArrayList<HashMap<String,Object>> ();
	   	
		
		try {

			CustomUser user = SessionUtil.getProperty(request);
			if (null != user) {
				param.setFrstRegisterId(user.getUserId());
				param.setLastUpdusrId(user.getUserId());
			}
			
				
				
				int del1 = egovNctsSimsaService.deleteRequire1(param);
				
				
				if(del1 != 0 ) { 
					
					egovNctsSimsaService.deleteSimsaList(param);
					result.put("success", "success");
					result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
					dd.add(result);
					
				}else { 
					result.put("fail", "fail");
					dd.add(result);
				}
				
			
			
		 } catch (IOException e) {
			 LOGGER.debug(e.getMessage());
				result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
				dd.add(result);
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
			dd.add(result);
		}

		
		
		return dd;
	}
	
	@RequestMapping(value = "/simsaMagamChk.do")
	public @ResponseBody HashMap<String, Object> simsaMagamChk(HttpServletRequest request, ModelMap model, @ModelAttribute MngrSimsaManageVO param) {

		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> data = egovNctsSimsaService.selectSimsaListDetail(param);
			HashMap<String, Object> rs = egovNctsSimsaService.selectStartDePast(param);
			
			result.put("data", data);
			result.put("rs", rs);
			result.put("success", "success");

		} catch (IOException e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		return result;

	}
	
	@RequestMapping(value = "/mngrSimsaAppExcelDownload.do")
    public void statExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rsMap = egovNctsSimsaService.selectCommonExcel(pageVO);
        
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
