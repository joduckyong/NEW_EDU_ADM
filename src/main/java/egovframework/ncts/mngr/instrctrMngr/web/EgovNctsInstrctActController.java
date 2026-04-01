package egovframework.ncts.mngr.instrctrMngr.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrActService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrActVO;

@Controller
@RequestMapping(value = "/ncts/mngr/instrctrMngr")
public class EgovNctsInstrctActController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctActController.class);
    
    @Autowired
    private CommonCodeService commonCodeService;    
    
    @Autowired
    private EgovNctsInstrctrActService egovNctsInstrctrActService;
    
	@Autowired
	private EgovNctsMngrDtyEduProgressService egovNctsMngrDtyEduProgressService;    
    
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;	    
    
    @PreAuth(menuCd="110010301", pageType=PageType.LIST)
    @RequestMapping(value = "/instrctrActList.do")
    public String instrctrMngrList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrActVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        
        codeMap.put("DMH19", commonCodeService.getCodeByGroup("DMH19")); // 교육 구분
    	
		CustomUser user = SessionUtil.getProperty(request);
		/*if(null != user) {
			if(!(SessionUtil.hasMasterRole(request) || SessionUtil.hasSystemRole(request))) pageVO.setCenterCd(user.getCenterId());	
		}*/
        
        List<HashMap<String, Object>> list = egovNctsInstrctrActService.selectInstrctrActList(pageVO);
		List<HashMap<String, Object>> CenterList = (List<HashMap<String, Object>>) egovNctsSysDeptService.selectCenterList();
        
		model.addAttribute("centerList", CenterList);
        model.addAttribute("list", list);
        model.addAttribute("codeMap", codeMap);
        
        return "mngr/instrctrMngr/instrctrActList.ncts_content";
    }
    
    @RequestMapping(value = "/instrctrActDetail.do")
    public @ResponseBody HashMap<String, Object> selectMngrMemberDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrInstrctrActVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> de = new ArrayList<>();
        if(null != param.getDtyEduYn() && "Y".equals(param.getDtyEduYn())) {
        	MngrDtyEduProgressVO dtyEduVO = new MngrDtyEduProgressVO();
        	dtyEduVO.setEduSeq(param.getReqstSeq());
        	List<HashMap<String, Object>> lectureIds = egovNctsMngrDtyEduProgressService.selectPackageDetailCodeList(dtyEduVO);
        	result.put("lectureIds",lectureIds);
        	if(null == param.getCertCd() || "".equals(param.getCertCd())) param.setCertCd(lectureIds.get(0).get("LECTURE_ID").toString());
        }         
        de = egovNctsInstrctrActService.selectInstrctrActDetail(param);
        
        result.put("de", de);
        result.put("success", "success");
        return result;
    }
    /*
    @PreAuth(menuCd="110010201", pageType=PageType.FORM)
    @RequestMapping(value = "/instrctrForm.do")
    public String instrctrForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrInstrctrActVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> codeMap = new HashMap<>();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        codeMap.put("DMH03", commonCodeService.getCodeByGroup("DMH03"));
        codeMap.put("DMH04", commonCodeService.getCodeByGroup("DMH23"));
        codeMap.put("DMH07", commonCodeService.getCodeByGroup("DMH07"));
        codeMap.put("DMH08", commonCodeService.getCodeByGroup("DMH08"));
        
        if (ProcType.UPDATE.equals(procType)) {
            HashMap<String, Object> result = new HashMap<>();

            result = egovNctsInstrctrMngrService.selectInstrctrMngrDetail(param);
            
            model.addAttribute("result", result);
        }
        
        model.addAttribute("codeMap", codeMap);
        return "mngr/instrctrMngr/instrctrForm.ncts_content";
    }
    */
    
    @RequestMapping(value = "/actProc.do")
    public @ResponseBody HashMap<String, Object> actProc(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrInstrctrActVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setLastUpdusrId(user.getUserId());
        }
        
        try {
            egovNctsInstrctrActService.actProc(param);
            
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
    
    /*@RequestMapping(value = "/updateFile.do")
    public @ResponseBody HashMap<String, Object> updateFile(final MultipartHttpServletRequest multiRequest, HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrInstrctrActVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        
        try {
                String atchFileId = FileUploadBuilder
                        .getInstance()
                        .multiRequest(multiRequest)
                        .storePath("mngr")     // 저장위치
                        .keyStr("mngr_") // 파일명키
                        //.procType(ProcType.findByProcType(param.getProcType()))
                        .atchFileId(param.getAtchFileId())
                        .fileKey(0)
                        .build();
                
                if(!"".equals(atchFileId)) param.setAtchFileId(atchFileId);

            
            egovNctsInstrctrActService.updateFile(request, param);
            
            result.put("success", "success");
            System.out.println("111111111111111111111111111111111111111111111111111111111111");
            System.out.println(param.getProcType());
            result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
        } catch (IOException e) {
          LOGGER.debug(e.getMessage());
            System.out.println("22222222222222222222222222222222222222222222222222222222222");
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            System.out.println("22222222222222222222222222222222222222222222222222222222222");
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }
        
        return result;
    }*/
    
    /*
    @RequestMapping(value = "/instrctrExcelDownload.do")
    public void instrctrExcelDownload(HttpServletRequest request, HttpServletResponse response,  ModelMap model,@ModelAttribute("common") MngrInstrctrActVO vo) throws Exception {
        HashMap<String, Object> rsMap = egovNctsInstrctrMngrService.selectCommonExcel(vo);
        
        HashMap<String, Object> paramMap = (HashMap<String, Object>) rsMap.get("paramMap");
        String fileName = (String) rsMap.get("fileName");
        String templateFile = (String)  rsMap.get("templateFile");
        
        excelDownloadView.download(request, response, paramMap, fileName, templateFile);
    }*/
}