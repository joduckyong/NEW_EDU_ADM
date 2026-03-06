package egovframework.ncts.mngr.edcOperMngr.web;

import java.io.IOException;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.com.auth.AuthCheck;
import egovframework.com.auth.PreAuth;
import egovframework.com.cmm.ProcessMessageSource;
import egovframework.com.service.CommonCodeService;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.PageType;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcOperMngr.service.EgovNctsFrmatnEvlService;
import egovframework.ncts.mngr.edcOperMngr.vo.MngrFrmatnEvlVO;

@Controller
@RequestMapping(value = "/ncts/mngr/edcOperMngr")
public class EgovNctsMngrFrmatnEvlController {
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrFrmatnEvlController.class);
    
    @Autowired
    private EgovNctsFrmatnEvlService egovNctsFrmatnEvlService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @PreAuth(menuCd="110030401", pageType=PageType.LIST)
    @RequestMapping(value = "/mngrFrmatnEvlList.do")
    public String mngrFrmatnEvlList (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrFrmatnEvlVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        List<HashMap<String, Object>> list = null;
        List<HashMap<String, Object>> lecIdList = null;
        List<HashMap<String, Object>> commonList = null;
        
        commonList = commonCodeService.getCodeByGroup("DMH15");
        lecIdList = egovNctsFrmatnEvlService.selectLctreList(pageVO);
        list = egovNctsFrmatnEvlService.selectFrmatnEvlList(pageVO);
        
        model.addAttribute("list", list);
        model.addAttribute("lecIdList", lecIdList);
        model.addAttribute("codeMap", commonList);
        return "mngr/edcOperMngr/mngrFrmatnEvlList.ncts_content";
    }
    
    @RequestMapping(value = "/mngrFrmatnEvlDetail.do")
    public @ResponseBody HashMap<String, Object> mngrLctreDetail (HttpServletRequest request, ModelMap model,@ModelAttribute("common") MngrFrmatnEvlVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        HashMap<String, Object> secDetail = new HashMap<>();
        List<HashMap<String, Object>> list = null;
        try{
            list = egovNctsFrmatnEvlService.selectFrmatnEvlDetailList(param);
            result.put("de", list);
            result.put("success", "success");
        } catch(IOException e){
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }

        return result;
    }
    
    @PreAuth(menuCd="110030401", pageType=PageType.FORM)
    @RequestMapping(value = "/mngrFrmatnEvlForm.do")
    public String mngrFrmatnEvlForm(HttpServletRequest request,RedirectAttributes redirectAttributes, ModelMap model, @ModelAttribute("common") MngrFrmatnEvlVO param, @ModelAttribute("paginationInfo") PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> dtlList = null;
        List<HashMap<String, Object>> lecIdList = null;
        List<HashMap<String, Object>> commonList = null;
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        lecIdList = egovNctsFrmatnEvlService.selectLctreList(pageVO);
        commonList = commonCodeService.getCodeByGroup("DMH15");
         
        if (ProcType.UPDATE.equals(procType)) {
            dtlList = egovNctsFrmatnEvlService.selectFrmatnEvlDetailList(param);
            
            result.put("EXAM_NM", dtlList.get(0).get("EXAM_NM"));
            result.put("EXAM_WRANS_NOTE", dtlList.get(0).get("EXAM_WRANS_NOTE"));
            result.put("EXAM_TYPE_CD", dtlList.get(0).get("EXAM_TYPE_CD"));
            result.put("LECTURE_ID", dtlList.get(0).get("LECTURE_ID"));
            result.put("EXAM_NO", dtlList.get(0).get("EXAM_NO"));
            result.put("EXAM_SQNO", dtlList.get(0).get("EXAM_SQNO"));
            
            
            for(int i=0; i<dtlList.size(); i++){
            	model.put("reitemNm"+(i+1), dtlList.get(i).get("ITEM_NM"));
            	model.put("itemNo"+(i+1), dtlList.get(i).get("ITEM_NO"));
            	if(null != dtlList.get(0).get("EXAM_TYPE_CD")) {
            		if("01".equals(dtlList.get(0).get("EXAM_TYPE_CD"))) {
            			model.put("correctAnswer", dtlList.get(i).get("CORRECT_ANSWER"));
            		}
            		else if(!"".equals(dtlList.get(i).get("CORRECT_ANSWER")) && "O".equals(dtlList.get(i).get("CORRECT_ANSWER"))){
            			model.put("correctAnswer", i+1);
            		}
            	}
            	
            }
            
            model.addAttribute("EXAM_NO", dtlList.get(0).get("EXAM_NO"));
            model.addAttribute("result", result);
            
        }

        model.addAttribute("codeMap", commonList);
        model.addAttribute("lecIdList", lecIdList);
        return "mngr/edcOperMngr/mngrFrmatnEvlForm.ncts_content";
    }
    
    @AuthCheck(menuCd="110030301")
    @RequestMapping(value = "/mngrProgressFrmatn.do")
    public @ResponseBody HashMap<String, Object> mngrProgressFrmatn(HttpServletRequest request,ModelMap model, @ModelAttribute("common") MngrFrmatnEvlVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();

        try {
            egovNctsFrmatnEvlService.mngrProgressFrmatn(request, param);
             
            result.put("success", "success");
            result.put("msg", ProcessMessageSource.newInstance().getMsg(param.getProcType().split(",")[0]));
        }catch (IOException e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }catch (Exception e) {
            LOGGER.debug(e.getMessage());
            result.put("msg", ProcessMessageSource.newInstance().getErrMsg(param.getProcType()));
        }

        return result;
    }
    
    @AuthCheck(menuCd="110030301")
    @RequestMapping(value = "/mngrDeleteEvl.do")
    public @ResponseBody HashMap<String, Object> mngrDeleteLctre(HttpServletRequest request,ModelMap model, @ModelAttribute MngrFrmatnEvlVO param) throws Exception{
        HashMap<String, Object> result = new HashMap<>();
        try {
            egovNctsFrmatnEvlService.delEvl(param);
            
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
}