package egovframework.ncts.mngr.edcComplMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.mapper.FileMngeMapper;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsLctreOffService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreOffVO;
import egovframework.ncts.mngr.edcComplMngr.mapper.EgovNctsLctreOffMapper;


@Service
public class EgovNctsLctreOffImpl implements EgovNctsLctreOffService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsLctreOffImpl.class);
    
    @Autowired
    private EgovNctsLctreOffMapper egovNctsLctreOffMapper;
    
    @Autowired
    private FileMngeMapper fileMngeMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsLctreOffMapper.selecLctreCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsLctreOffMapper.selectLctreList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectLctreDetail(MngrLctreOffVO param)throws Exception{
        HashMap<String, Object> result = egovNctsLctreOffMapper.selectLctreDetail(param);
        String course = "";
        
        course = (String)result.get("COURSES");
        
        if(course.indexOf("00") != -1) result.put("COURSES00", "00");
        if(course.indexOf("01") != -1) result.put("COURSES01", "01");
        if(course.indexOf("02") != -1) result.put("COURSES02", "02");
        if(course.indexOf("03") != -1) result.put("COURSES03", "03");
        if(course.indexOf("04") != -1) result.put("COURSES04", "04");
        if(course.indexOf("07") != -1) result.put("COURSES07", "07");
        
        return result;
    }
     
    public void delOffLctre(MngrLctreOffVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            if(null == param.getActiveYn() || param.getActiveYn().isEmpty()){
                egovNctsLctreOffMapper.delLctre(param);
                egovNctsLctreOffMapper.delCert(param);
                egovNctsLctreOffMapper.deleteLectureOnlect(param);
            } else {
                egovNctsLctreOffMapper.delActive(param);
            }
        }
    }
    
    public void mngrProgressOffLctre(HttpServletRequest request, MngrLctreOffVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setFrstRegisterId(user.getUserId());
        	param.setLastUpdusrId(user.getUserId());
        }
        /*String progrmCompositionStr = "";
        if(null != param.getProgrmComposition()){
            for(int i=0; i < param.getProgrmComposition().size(); i++){
                if(i>0){
                    progrmCompositionStr += "||" + param.getProgrmComposition().get(i);
                }else{
                    progrmCompositionStr += param.getProgrmComposition().get(i); 
                }
            }
        }
        param.setProgrmCompositionStr(progrmCompositionStr);*/
        
        if(ProcType.UPDATE.equals(procType)) {
        	egovNctsLctreOffMapper.lctreUpdateProc(param);
        	egovNctsLctreOffMapper.userUpdateCert(param);
        	if(null != param.getLectureIdOld() && null != param.getLectureId() && !param.getLectureIdOld().equals(param.getLectureId())) {
        		egovNctsLctreOffMapper.dtyEduApplicantIsueUpdate(param);
        		egovNctsLctreOffMapper.eduIsueUpdate(param);
        		egovNctsLctreOffMapper.eduGeneralEduUpdate(param);
        		egovNctsLctreOffMapper.eduManageUpdate(param);
        		egovNctsLctreOffMapper.eduPackageDetailCodeUpdate(param);
        		egovNctsLctreOffMapper.instrctrAsignUpdate(param);
        		egovNctsLctreOffMapper.tmpInstrctrAsignUpdate(param);
        		egovNctsLctreOffMapper.instrctrOfflectUpdate(param);
        		egovNctsLctreOffMapper.lectureOnlectUpdate(param);
        		egovNctsLctreOffMapper.webeduDtyResultUpdate(param);
        		egovNctsLctreOffMapper.videoStopPointUpdate(param);
        	}
            
            if(null != param.getVideoAt() && "N".equals(param.getVideoAt())) {
            	egovNctsLctreOffMapper.deleteLectureOnlect(param);
            }
            
        } else if(ProcType.INSERT.equals(procType)){
            egovNctsLctreOffMapper.lctreInsertProc(param);
            
            if(0 >= egovNctsLctreOffMapper.selectCertCd(param)) egovNctsLctreOffMapper.insertUserCert(param);
            
            if(null != param.getTempSeq() && !"".equals(param.getTempSeq())) {
            	String[] tempSeqArr = param.getTempSeq().split(",");
            	
            	MngrLctreOffVO vo = new MngrLctreOffVO();
            	vo.setLectureId(param.getLectureId());
            	for(String seq : tempSeqArr) {
            		vo.setTempSeq(seq);
            		egovNctsLctreOffMapper.insertLectureOnlectTempSeq(vo);
            		egovNctsLctreOffMapper.deleteTempLectureOnlect(vo);
            	}
            }
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
    }

	@Override
	public HashMap<String, Object> selectLctreExcelList(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsLctreOffMapper.selectLctreExcelList(pageVO);
        
        paramMap.put("rsList",rsTp);
        
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        	
        return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectLectureOnlectList(MngrLctreOffVO param) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsLctreOffMapper.selectLectureOnlectList(param);
		return rslist;
	}
	
	@Override
	public HashMap<String, Object> selectLectureOnlectDetail(MngrLctreOffVO param) throws Exception {
        HashMap<String, Object> result = egovNctsLctreOffMapper.selectLectureOnlectDetail(param);
        List<HashMap<String, Object>> fileList = fileMngeMapper.selectFileInfs((String)result.get("ATCH_FILE_ID"));
        
        if(null != fileList && fileList.size() >0){
            HashMap<String, Object> fileMap = fileList.get(0);
            if(null != fileMap) result.put("STRE_FILE_NM",fileMap.get("STRE_FILE_NM"));
        }
		return result;
	}

	@Override
	public void lectureOnlectProc(MngrLctreOffVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if(null != param.getLectureId() && !"".equals(param.getLectureId())) {
			if(ProcType.DELETE.equals(procType)) {
				egovNctsLctreOffMapper.deleteLectureOnlect(param);
				egovNctsLctreOffMapper.updateLectureSn(param);
			}
			else if(null != param.getLectureSeq() && !"".equals(param.getLectureSeq())) egovNctsLctreOffMapper.updateLectureOnlect(param);
			else egovNctsLctreOffMapper.insertLectureOnlect(param);
		}
		else {
			if(ProcType.DELETE.equals(procType)) {
				egovNctsLctreOffMapper.deleteTempLectureOnlect(param);
				
				if(null != param.getDelTempSeq() && !"".equals(param.getDelTempSeq())) {
					for(String tSeq : param.getDelTempSeq()) {
						param.setTempSeq(tSeq);
						egovNctsLctreOffMapper.updateTempLectureSn(param);
					}
				}
			}
			else if(null != param.getTempSeq() && !"".equals(param.getTempSeq())) egovNctsLctreOffMapper.updateTempLectureOnlect(param);
			else egovNctsLctreOffMapper.insertTempLectureOnlect(param);
		}
		
	}
}
