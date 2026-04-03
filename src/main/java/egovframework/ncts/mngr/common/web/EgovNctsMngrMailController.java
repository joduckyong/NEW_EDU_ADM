package egovframework.ncts.mngr.common.web;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.file.FileUploadBuilder;
import egovframework.com.file.FileUploadMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.cmm.sys.dept.service.EgovNctsSysDeptService;
import egovframework.ncts.mngr.common.service.EgovNctsMngrMailService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.common.vo.MngrMailVO;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import org.apache.commons.lang.StringUtils;


@Controller
@RequestMapping(value = "/ncts/mngr/mail")
public class EgovNctsMngrMailController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrMailController.class);
	
	@Autowired
	private EgovNctsMngrMailService egovNctsMngrMailService;
	@Autowired
	private EgovNctsMngrMemberService egovNctsMngrMemberService;
	
	@Autowired
	private EgovNctsSysDeptService egovNctsSysDeptService;
	@Autowired
    private CommonCodeService commonCodeService;
	
	
	@PreAuth(menuCd="110100101", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrMemberMailForm.do")
    public String mngrMemberMailForm (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("mail") MngrMailVO mailVo, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	CustomUser user = SessionUtil.getProperty(request);
    	if(null != user) pageVO.setUserId(user.getUserId());
    	
		/*if(null == pageVO.getMailTmpSeq() || "".equals(pageVO.getMailTmpSeq())) {
			HashMap<String, Object> mailTmpSeq = new HashMap<>();
			egovNctsMngrMailService.insertMailTmpKey(pageVO);
			mailVo.setMailTmpSeq(pageVO.getMailTmpSeq());
			mailTmpSeq.put("mailTmpSeq", pageVO.getMailTmpSeq());
			model.addAttribute("mailTmpSeq", pageVO.getMailTmpSeq());
		}*/
    	HashMap<String, Object> result = new HashMap<>();
    	String atchFileId = "";
    	ProcType procType = ProcType.findByProcType(param.getProcType());
    	
    	if (ProcType.UPDATE.equals(procType)) {
			result = egovNctsMngrMailService.selectMngrMailRequestDetail(mailVo);
			model.addAttribute("result", result);
			atchFileId = StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), "");
		}    	
    	
    	StringBuffer markup = FileUploadMarkupBuilder.newInstance()
                .fileDownYn(true)
                .btnYn(true)
                .atchFileId(atchFileId)
                .fileTotal(5)
                .build();
    	
    	model.addAttribute("markup", markup);
        return "mngr/common/mngrMemberMailForm.ncts_content";
    }	
    
	
	/*@RequestMapping(value = "/mailTargetTmpProc.do")
	public @ResponseBody HashMap<String, Object> mailTargetTmpProc(HttpServletRequest request,ModelMap model, @ModelAttribute MngrMailVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			
			egovNctsMngrMailService.mailTargetTmpProc(param);
			
			result.put("success", "success");
			result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			if(e.getMessage().equals("02")) result.put("msg", "수신자가 없습니다.");
			else result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
		
		return result;
	}    */
 
	
    @RequestMapping(value = "/mngrSendEmail.do")
    public @ResponseBody HashMap<String, Object> mngrSendEmail(@ModelAttribute("common") MngrMemberVO param,@ModelAttribute("mail") MngrMailVO mailVo, @ModelAttribute("paginationInfo") PageInfoVO pageVO, final MultipartHttpServletRequest multiRequest) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        try{
        	List<File> fileList = new ArrayList<>();
        	if (ProcType.isFindFileUpload(mailVo.getProcType())) {
				String atchFileId = FileUploadBuilder
						.getInstance()
						.multiRequest(multiRequest)
						.storePath("mail")     // 저장위치
						.keyStr("mail_") // 파일명키
						.procType(ProcType.findByProcType(mailVo.getProcType()))
						.atchFileId(mailVo.getAtchFileId())
						.fileKey(0)
						.build();
				
				if(!"".equals(atchFileId)) mailVo.setAtchFileId(atchFileId);
				
				Iterator<String> fileNames = multiRequest.getFileNames();
				while(fileNames.hasNext()) {
					String fileName = fileNames.next();
					MultipartFile mFile = multiRequest.getFile(fileName);
					File file = new File(mFile.getOriginalFilename());
					mFile.transferTo(file);
					if(file.isFile()) fileList.add(file);
				}
				mailVo.setFileList(fileList);
			}
        	
        	if(null != mailVo.getMailBodySnapshot() && !"".equals(mailVo.getMailBodySnapshot())) {
        		String serverUrl = multiRequest.getScheme()+"://"+multiRequest.getServerName()+":"+multiRequest.getServerPort();
        		String mailBodyReverseTag = ParamUtils.reverseHtmlTag(mailVo.getMailBodySnapshot());
        		mailVo.setMailBody(mailBodyReverseTag.replaceAll("/utl/web/imageSrc.do[?]editor=Y[&]path=", serverUrl+"/image"));
        	}
        		
        	egovNctsMngrMailService.mngrSendEmail(mailVo, pageVO);
    		result.put("success", "success");
    		result.put("msg", "저장되었습니다.");
        } catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        } catch (Exception e) {
			LOGGER.debug(e.getMessage());
			if(e.getMessage().equals("00")) result.put("msg", "발송자 정보를 입력해주세요.");
			else if(e.getMessage().equals("01")) result.put("msg", "메일 제목 또는 메일 내용을 입력해주세요.");
			else if(e.getMessage().equals("02")) result.put("msg", "수신자가 없습니다.");
			else result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}
        
        return result;
    }  
	
	/*
    @RequestMapping(value = "/getMailList.do")
    public @ResponseBody HashMap<String, Object> getMailList(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrCommonVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
        	egovNctsMngrMailService.getMailList();
            
            result.put("success", "success");
            result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
        } catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        } catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
		}

        return result;
    }*/
	
    @RequestMapping(value = "/memberListPopup.do")
    public String memberListPopup(HttpServletRequest request, ModelMap model, @ModelAttribute("paginationInfo") PageInfoVO pageVO, @ModelAttribute("common") MngrMemberVO param) throws Exception {
    	List<HashMap<String, Object>> rslist = egovNctsMngrMemberService.selectMngrMemberList(pageVO);
    	HashMap<String, Object> lastUserNo = egovNctsMngrMailService.selectLastUserNo();
    	int totalCnt = egovNctsMngrMailService.selectUserNoCnt();
    	model.addAttribute("rslist", rslist);
    	model.addAttribute("lastUserNo", lastUserNo);
    	model.addAttribute("totalCnt", totalCnt);
    	
    	return "mngr/common/selectEduMemberListPopup.ncts_popup";
    }
    
    @RequestMapping(value = "/selectChoiceMemberList.do")
    public String selectChoiceMemberList(HttpServletRequest request,ModelMap model, @ModelAttribute("pagination") PageInfoVO pageVO) throws Exception{
    	pageVO.setRecordCountPerPage(20);
    	List<HashMap<String, Object>> userList = egovNctsMngrMailService.selectMailAllViewUserList(pageVO);
        model.addAttribute("userList", userList);
        return "mngr/common/mngrChoiceMemberList.ncts_popup";
    }
    
    @PreAuth(menuCd="110100101", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrMailRequestList.do")
    public String mngrMailRequestList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrMemberVO param, @ModelAttribute("mail") MngrMailVO mailVo, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
    	CustomUser user = SessionUtil.getProperty(request);
    	if(null != user) pageVO.setUserId(user.getUserId());
    	List<HashMap<String, Object>> requestList = egovNctsMngrMailService.selectMngrMailRequestList(pageVO);
    	
    	model.addAttribute("requestList", requestList);
    	model.addAttribute("centerList", egovNctsSysDeptService.selectCenterList());
        return "mngr/common/mngrMailRequestList.ncts_content";
    }	    
    
    @RequestMapping(value = "/mngrMailRequestDetail.do")
	public @ResponseBody HashMap<String, Object> mngrMailRequestDetail(HttpServletRequest request, ModelMap model, @ModelAttribute MngrMailVO param, @ModelAttribute("pagination") PageInfoVO pageVO) throws Exception{
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> rs =egovNctsMngrMailService.selectMngrMailRequestDetail(param);
			result.put("rs", rs);
			result.put("success", "success");
		}catch (Exception e) {
			LOGGER.debug(e.getMessage());
			result.put("success", "error");
		}
		
		return result;
	}    
    
    @RequestMapping(value = "/selectMngrMailStatusList.do")
    public String selectMngrMailStatusList(HttpServletRequest request,ModelMap model, @ModelAttribute("mail") MngrMailVO param, @ModelAttribute("pagination") PageInfoVO pageVO) throws Exception{
        pageVO.setRecordCountPerPage(20);
    	List<HashMap<String, Object>> statusList = egovNctsMngrMailService.selectMngrMailStatusList(pageVO);
        model.addAttribute("statusList", statusList);
        return "mngr/common/mngrStatusMemberList.ncts_popup";
    }    
	
    @RequestMapping(value = "/updateMailRequest.do")
    public @ResponseBody HashMap<String, Object> updateMailRequest(HttpServletRequest request,ModelMap model, @ModelAttribute MngrMailVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception{
    	CustomUser user = SessionUtil.getProperty(request);
    	if(null != user) param.setLastUpdusrId(user.getUserId());
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		
    		egovNctsMngrMailService.updateMailRequest(param);
    		
    		result.put("success", "success");
    		result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
    	}catch (Exception e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
    	}
    	
    	return result;
    }    
    @RequestMapping(value = "/updateMailStatusList.do")
    public @ResponseBody HashMap<String, Object> updateMailStatusList(HttpServletRequest request,ModelMap model, @ModelAttribute MngrMailVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception{
    	CustomUser user = SessionUtil.getProperty(request);
    	if(null != user) param.setLastUpdusrId(user.getUserId());
    	HashMap<String, Object> result = new HashMap<>();
    	try {
    		
    		egovNctsMngrMailService.updateMailStatusList(param);
    		
    		result.put("success", "success");
    		result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType()));
    	}catch (Exception e) {
    		LOGGER.debug(e.getMessage());
    		result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
    	}
    	
    	return result;
    }    
    


}
