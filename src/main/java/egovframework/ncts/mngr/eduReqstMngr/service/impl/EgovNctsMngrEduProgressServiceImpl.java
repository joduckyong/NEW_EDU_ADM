package egovframework.ncts.mngr.eduReqstMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEduProgressMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrMemberMapper;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsMngrEduProgressServiceImpl implements EgovNctsMngrEduProgressService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduProgressServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrEduProgressMapper mngrEduProgressMapper;
	
	@Autowired
    private EgovNctsMngrMemberMapper egovNctsMngrMemberMapper;
	
	@Autowired
	private EgovNctsMngrCommonService egovNctsMngrCommonService;	
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void mngrEduProgressProcess(MngrEduProgressVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
	    if (ProcType.INSERT.equals(procType)) {
	        int insertYn = mngrEduProgressMapper.insertMngrEduProgress(param);
	        
	        if( 0 < insertYn){
	            mngrEduProgressMapper.updateMngrEduApplicant(param);
	        }
	        
	    }else if (ProcType.UPDATE.equals(procType)) {
	        mngrEduProgressMapper.updateMngrEduProgress(param);
	    }else if (ProcType.DELETE.equals(procType)) {
	        mngrEduProgressMapper.deleteMngrEduProgress(param);
	    }else{
	        throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
	    }
			
	}
	
	@Override
	public HashMap<String, Object> selectMngrEduProgressDetail(MngrEduProgressVO vo) throws Exception {
		HashMap<String, Object> rs = mngrEduProgressMapper.selectMngrEduProgressDetail(vo);
		rs.put("EDU_CN", ParamUtils.reverseHtmlTag((String)rs.get("EDU_CN")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMngrEduProgressList(PageInfoVO searchVO) throws Exception {
		int cnt = mngrEduProgressMapper.selectMngrEduProgressListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return mngrEduProgressMapper.selectMngrEduProgressList(searchVO);
	}
	@Override
	public List<HashMap<String, Object>> selectMngrEduApplicantList(MngrEduProgressVO param) throws Exception{
	    List<HashMap<String, Object>> rs = mngrEduProgressMapper.selectMngrEduApplicantList(param);
        
        for(HashMap<String, Object> tmp : rs){
            String fileView = FileViewMarkupBuilder.newInstance()
                    .atchFileId(StringUtils.defaultIfEmpty((String) tmp.get("ATCH_FILE_ID"), ""))
                    .wrapMarkup("p")
                    .isIcon(true)
                    .isSize(true)
                    .build()
                    .toString();
            tmp.put("fileView", fileView);
        }
        return rs;
	}
	
	@Override
	public void updateComplProgress(MngrEduProgressVO param) throws Exception {
	    String[] complYn = param.getComplProcUser().split(",");
		MngrMemberVO mngrMemberVO = new MngrMemberVO();
        
        try{
        	
            for(int i=0; i<complYn.length; i++){
                MngrEduProgressVO vo = new MngrEduProgressVO();
                vo.setComplProcUser(complYn[i]);
                vo.setEduSeq(param.getEduSeq());
                HashMap<String, Object> applicantDetail = mngrEduProgressMapper.selectMngrEduApplicantDetail(vo);
                vo.setUserId(param.getUserId());
                vo.setUserNo(String.valueOf(applicantDetail.get("USER_NO")));
                vo.setPsitn((String) applicantDetail.get("ORGANIZATION"));
                vo.setEduDivision(param.getEduDivision());
                mngrMemberVO.setUserNo(Integer.parseInt(String.valueOf(applicantDetail.get("USER_NO"))));
                mngrEduProgressMapper.updateComplProgress(vo);
                mngrEduProgressMapper.updateUserCert(vo);
                HashMap<String, Object> result = egovNctsMngrMemberMapper.selectCert(mngrMemberVO);
                HashMap<String, Object> memberDetail = egovNctsMngrMemberMapper.selectMngrMemberDetail(mngrMemberVO);
                mngrMemberVO.setDetailGradeCd((String) memberDetail.get("DETAIL_GRADE_CD"));
                mngrMemberVO.setInstrctrDetailGradeCd((String) memberDetail.get("INSTRCTR_DETAIL_GRADE_CD"));
                if(0 >= mngrEduProgressMapper.getEdcIsueCount(vo)){
                	mngrEduProgressMapper.insertComplProgress(vo);
                };
                resultCompCourse(vo);
                updateGrade(mngrMemberVO);
                
                MngrCommonVO commonVO = new MngrCommonVO();
                commonVO.setUserNo(vo.getUserNo());
                commonVO.setFrstRegisterId(vo.getUserId());
                egovNctsMngrCommonService.packageCertificateProgress(commonVO);                 
            }
        }catch(DataAccessException e){
            LOGGER.debug(e.getMessage());
            throw e;
        }
	}
	
	public void resultCompCourse(MngrEduProgressVO param) throws Exception{
		for(int i=0; i<4; i++){
			String course = "0" + (i+1);
			
			MngrEduProgressVO vo = new MngrEduProgressVO();
			vo.setCourses(course);
			vo.setComplProcUser(param.getComplProcUser());
			vo.setUserNo(param.getUserNo());
			vo.setPsitn(param.getPsitn());
			vo.setFrstRegisterId(param.getUserId());
			try{
			    if("Y".equals(complYn(param, course))){
			        mngrEduProgressMapper.insertCertificate(vo);
			    }
			} catch(DataAccessException e){
			    LOGGER.debug(e.getMessage());
			    throw e;
			}
		}
	}
	
	public String complYn(MngrEduProgressVO vo, String course) throws Exception{
		String complYn = "N";
		
		MngrEduProgressVO param = new MngrEduProgressVO();
		
		vo.setCourses(course);
		param.setCourses(course);
		
		try{
		    if(0 >= mngrEduProgressMapper.selectCertificate(vo)){
		        List<HashMap<String, Object>> certList = null;
		        List<HashMap<String, Object>> ruleList = null;
		        
		        int onlectComplCount =  mngrEduProgressMapper.onlectComplCount(vo);
		        int onlectCount =  mngrEduProgressMapper.getOnlectCount(vo);
		        certList = mngrEduProgressMapper.getCertCd(vo);
		        ruleList = mngrEduProgressMapper.getRuleList(param);
		        
		        if(onlectComplCount != 0 && onlectCount <= onlectComplCount){
		            for(int i=0; i<ruleList.size(); i++){
		                String[] lectureList = ((String) ruleList.get(i).get("LECTURE_ID")).replaceAll(" ", "").split("[|]");
		                
		                int complCount = 0;
		                
		                for(int j=0; j<lectureList.length; j++){
		                    
		                    for(int k=0; k<certList.size(); k++){
		                        if(certList.get(k).get("CERT_CD").equals(lectureList[j])){
		                            complCount++;
		                            
		                            if(lectureList.length == complCount){
		                                complYn = "Y";
		                                
		                                break;
		                            }
		                        }
		                    }
		                }
		            }
		        }
		    }
		}catch(DataAccessException e){
		    LOGGER.debug(e.getMessage());
		    throw e;
		}
		
		return complYn;
	}
	
	public void updateGrade(MngrMemberVO param) throws Exception{
		if(null == param.getDetailGradeCd() || "".equals(param.getDetailGradeCd())) param.setDetailGradeCd("00");
        int deGrade = Integer.parseInt(param.getDetailGradeCd());
        String deGradeTx = "";
        
        int tet = 0;
        
        try{
            HashMap<String, Object> result = egovNctsMngrMemberMapper.selectCert(param);
            int isueRet = egovNctsMngrMemberMapper.selectIsue(param);
            tet = Integer.parseInt((String)result.get("CTFHV_CD"));
            
            if(deGrade <= tet && 0 < isueRet) {
            	deGrade = tet +1;
            	deGradeTx = "0" + deGrade;
            	param.setDetailGradeCd(deGradeTx);
        		egovNctsMngrMemberMapper.updateGrade(param);
            }
        }catch(DataAccessException e){
            LOGGER.debug(e.getMessage());
            throw e;
        }
    }
}
