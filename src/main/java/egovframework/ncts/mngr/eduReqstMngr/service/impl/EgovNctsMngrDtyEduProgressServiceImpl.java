package egovframework.ncts.mngr.eduReqstMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrDtyEduProgressMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrDtyEduProgressService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrMemberMapper;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsMngrDtyEduProgressServiceImpl implements EgovNctsMngrDtyEduProgressService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDtyEduProgressServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrDtyEduProgressMapper egovNctsMngrDtyEduProgressMapper;
	
	@Autowired
    private EgovNctsMngrMemberMapper egovNctsMngrMemberMapper;
	@Autowired
	private EgovNctsMngrCommonService egovNctsMngrCommonService;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public HashMap<String, Object> selectMngrDtyEduProgressDetail(MngrDtyEduProgressVO vo) throws Exception {
		HashMap<String, Object> rs = egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduProgressDetail(vo);
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
	public List<HashMap<String, Object>> selectMngrDtyEduProgressList(PageInfoVO searchVO) throws Exception {
		int cnt = egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduProgressListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduProgressList(searchVO);
	}
	@Override
	public List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduProgressVO param) throws Exception{
	    List<HashMap<String, Object>> rs = egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduApplicantList(param);
        
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
	public void updateDtyComplProgress(MngrDtyEduProgressVO param) throws Exception {
	    String[] complYn = param.getComplProcUser().split(",");
		MngrMemberVO mngrMemberVO = new MngrMemberVO();
        
        try{
            for(int i=0; i<complYn.length; i++){
                MngrDtyEduProgressVO vo = new MngrDtyEduProgressVO();
                vo.setComplProcUser(complYn[i]);
                vo.setEduSeq(param.getEduSeq());
                vo.setLectureId(param.getLectureId());
                HashMap<String, Object> applicantDetail = egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduApplicantDetail(vo);
                vo.setPackageNo(String.valueOf(applicantDetail.get("PACKAGE_NO")));
                vo.setEduDivision(param.getEduDivision());
                vo.setUserId(param.getUserId());
                vo.setUserNo(String.valueOf(applicantDetail.get("USER_NO")));
                vo.setPsitn(String.valueOf(applicantDetail.get("ORGANIZATION")));
                mngrMemberVO.setUserNo(Integer.parseInt(String.valueOf(applicantDetail.get("USER_NO"))));
                egovNctsMngrDtyEduProgressMapper.isueAtProgress(vo);
                egovNctsMngrDtyEduProgressMapper.updateUserCert(vo);
                HashMap<String, Object> memberDetail = egovNctsMngrMemberMapper.selectMngrMemberDetail(mngrMemberVO);
                mngrMemberVO.setDetailGradeCd(String.valueOf(memberDetail.get("DETAIL_GRADE_CD")));
                mngrMemberVO.setInstrctrDetailGradeCd(String.valueOf(memberDetail.get("INSTRCTR_DETAIL_GRADE_CD")));
                if(0 >= egovNctsMngrDtyEduProgressMapper.getEdcIsueCount(vo)){
                	egovNctsMngrDtyEduProgressMapper.insertComplProgress(vo);
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
	
	public void resultCompCourse(MngrDtyEduProgressVO param) throws Exception{
		for(int i=0; i<4; i++){
			String course = "0" + (i+1);
			
			MngrDtyEduProgressVO vo = new MngrDtyEduProgressVO();
			vo.setEduSeq(param.getEduSeq());
			vo.setCourses(course);
			vo.setComplProcUser(param.getComplProcUser());
			vo.setUserNo(param.getUserNo());
			vo.setPsitn(param.getPsitn());
			vo.setFrstRegisterId(param.getUserId());
			try{
			    if("Y".equals(complYn(param, course))){
			        egovNctsMngrDtyEduProgressMapper.insertCertificate(vo);
			    }
			} catch(DataAccessException e){
			    LOGGER.debug(e.getMessage());
			    throw e;
			}
		}
	}
	
	public String complYn(MngrDtyEduProgressVO vo, String course) throws Exception{
		String complYn = "N";
		
		MngrDtyEduProgressVO param = new MngrDtyEduProgressVO();
		
		vo.setCourses(course);
		param.setCourses(course);
		
		try{
		    if(0 >= egovNctsMngrDtyEduProgressMapper.selectCertificate(vo)){
		        List<HashMap<String, Object>> certList = null;
		        List<HashMap<String, Object>> ruleList = null;
		        
		        int onlectComplCount =  egovNctsMngrDtyEduProgressMapper.onlectComplCount(vo);
		        int onlectCount =  egovNctsMngrDtyEduProgressMapper.getOnlectCount(vo);
		        certList = egovNctsMngrDtyEduProgressMapper.getCertCd(vo);
		        ruleList = egovNctsMngrDtyEduProgressMapper.getRuleList(param);
		        
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

	@Override
	public void packageCertificateProgress(MngrDtyEduProgressVO param) throws Exception {
	    String[] complYn = param.getComplProcUser().split(",");
	    
	    for(String complProcUser : complYn) {
	    	MngrDtyEduProgressVO vo = new MngrDtyEduProgressVO();
	    	vo.setActiveType(param.getActiveType());
	    	vo.setComplProcUser(complProcUser);
	    	vo.setEduSeq(param.getEduSeq());
	    	vo.setFrstRegisterId(param.getUserId());
	    	HashMap<String, Object> applicantDetail = egovNctsMngrDtyEduProgressMapper.selectMngrDtyEduApplicantDetail(vo);
	    	vo.setCourses(String.valueOf(applicantDetail.get("COURSES")));
	    	vo.setPackageNo(String.valueOf(applicantDetail.get("PACKAGE_NO")));
	    	vo.setUserNo(String.valueOf(applicantDetail.get("USER_NO")));
	    	vo.setPsitn(String.valueOf(applicantDetail.get("ORGANIZATION")));
	    	vo.setCenterCd(String.valueOf(applicantDetail.get("CENTER_CD")));
	    	
	    	if(0 >= egovNctsMngrDtyEduProgressMapper.selectCertificate(vo)) {
	    		egovNctsMngrDtyEduProgressMapper.insertCertificate(vo);
	    	}
	    }
		
	}

	@Override
	public List<HashMap<String, Object>> complAutoCheck(MngrDtyEduProgressVO param) throws Exception {
		List<HashMap<String, Object>> packageCodeList = egovNctsMngrDtyEduProgressMapper.selectPackageDetailCodeList(param);
		String[] code = new String[packageCodeList.size()];
		int i = 0;
		for(HashMap<String, Object> rs : packageCodeList) {
			code[i] = rs.get("LECTURE_ID").toString();
			i++;
		}
		
		param.setPackageCode(code);
		List<HashMap<String, Object>> list = egovNctsMngrDtyEduProgressMapper.complAutoCheck(param);
		return list;
		
	}

	@Override
	public List<HashMap<String, Object>> selectPackageDetailCodeList(MngrDtyEduProgressVO dtyEduVO) throws Exception {
		return egovNctsMngrDtyEduProgressMapper.selectPackageDetailCodeList(dtyEduVO);
	}	

}
