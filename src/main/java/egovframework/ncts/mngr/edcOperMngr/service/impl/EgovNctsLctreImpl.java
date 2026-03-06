package egovframework.ncts.mngr.edcOperMngr.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.poi.ss.formula.functions.T;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ibm.icu.util.BytesTrie.Iterator;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.file.mapper.FileMngeMapper;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcOperMngr.service.EgovNctsLctreService;
import egovframework.ncts.mngr.edcOperMngr.mapper.EgovNctsLctreMapper;
import egovframework.ncts.mngr.edcOperMngr.vo.MngrLctreVO;

@Service
public class EgovNctsLctreImpl implements EgovNctsLctreService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsLctreImpl.class);
    
    @Autowired
    private EgovNctsLctreMapper egovNctsLctreMapper;
    
    @Autowired
    private FileMngeMapper fileMngeMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsLctreMapper.selecLctreCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsLctreMapper.selectLctreList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectLctreDetail(MngrLctreVO param)throws Exception{
        HashMap<String, Object> result = egovNctsLctreMapper.selectLctreDetail(param);
        List<HashMap<String, Object>> fileList = fileMngeMapper.selectFileInfs((String)result.get("ATCH_FILE_ID"));
        String course = "";
        
        if(null != fileList && fileList.size() >0){
            HashMap<String, Object> fileMap = fileList.get(0);
            if(null != fileMap) result.put("STRE_FILE_NM",fileMap.get("STRE_FILE_NM"));
        }
        
        course = (String)result.get("COURSES");
        
        if(course.indexOf("일반") != -1) result.put("COURSES00", "00");
        if(course.indexOf("초") != -1) result.put("COURSES01", "01");
        if(course.indexOf("중") != -1) result.put("COURSES02", "02");
        if(course.indexOf("고") != -1) result.put("COURSES03", "03");
        
        
        result.put("START_GUIDE", ParamUtils.reverseHtmlTag((String)result.get("START_GUIDE")));
        result.put("FAIL_GUIDE", ParamUtils.reverseHtmlTag((String)result.get("FAIL_GUIDE")));
        
        return result;
    }
     
    public void delLctre(MngrLctreVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsLctreMapper.delLctre(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressLctre(HttpServletRequest request, MngrLctreVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) param.setLastUpdusrId(user.getUserId());
        
     /*   if(!(param.getVideoStopPoint() == null || param.getVideoStopPoint().equals(""))) {
            String[] stopArr = param.getVideoStopPoint().split(",");
            
            if(stopArr.length != 0) {
            	Arrays.sort(stopArr, new Comparator<String>() {
                	@Override
                    public int compare(String s1, String s2) {
                		int arr1 = Integer.parseInt(s1);
                        int arr2 = Integer.parseInt(s2);
                        
                        return Integer.compare(arr1, arr2);
                	}
                });
                     
                String sum = "";
                     
                for(int i=0; i<stopArr.length; i++) {
                	if((i+1) % 10 == 0) {
                		sum += stopArr[i] + "|";
                    } else {
                    	sum += stopArr[i] + ",";
                    }
                }
                
                param.setVideoStopPoint(sum.substring(0, sum.length()-1));
            } else {
            	param.setVideoStopPoint("");
            }
        } */
        
        if(ProcType.UPDATE.equals(procType)) {
            /*param.setNoTag(ParamUtils.removeHtmlTag(param.getContentsSnapshot()));*/
            egovNctsLctreMapper.lctreUpdateProc(param);
        } else if(ProcType.INSERT.equals(procType)){
            String idSeq = egovNctsLctreMapper.selectSeq(param);
            
            param.setLectureId("ONL"+idSeq);
            
            egovNctsLctreMapper.lctreInsertProc(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    /*
    public HashMap<String, Object> selectCommonExcel(MngrAnswerVO vo)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrAnswerMapper.selectCommonExcel(vo);
        
        for(int i=0; i<rsTp.size(); i++){
            rsTp.get(i).put("CONTENTS", ParamUtils.removeHtmlTag((String) rsTp.get(i).get("CONTENTS")));
        }
        
        paramMap.put("rsList",rsTp);
        fileName = "mngrAnswerList";
        templateFile = "mngrAnswerList.xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }*/
}
