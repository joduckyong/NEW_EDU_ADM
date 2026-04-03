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

import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.file.mapper.FileMngeMapper;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEdcRequestMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEdcRequestService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduRequstApplicantVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrMemberMapper;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;


@Service
public class EgovNctsMngrEdcRequestServiceImpl implements EgovNctsMngrEdcRequestService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEdcRequestServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrEdcRequestMapper egovNctsMngrEdcRequsetMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Autowired
	private FileMngeMapper fileMngeMapper;
	
	@Autowired
    private EgovNctsMngrMemberMapper egovNctsMngrMemberMapper;
	
	@Autowired
	private EgovNctsMngrCommonService egovNctsMngrCommonService;

	@Override
    public List<HashMap<String, Object>> selectMngrEdcRequestList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsMngrEdcRequsetMapper.selectMngrEdcRequstCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequsetMapper.selectMngrEdcRequestList(pageVO);
        for(HashMap<String, Object> tmp : rslist){
	        String fileView = FileViewMarkupBuilder.newInstance()
					.atchFileId(StringUtils.defaultIfEmpty((String) tmp.get("ATCH_FILE_ID"), ""))
					.wrapMarkup("p")
					.isIcon(true)
					.isSize(true)
					.build()
					.toString();
	        tmp.put("fileView", fileView);
        }
        
        return rslist;
    }
    
    @Override
    public HashMap<String, Object> selectMngrEdcReqstDetail(MngrEdcRequestVO param)throws Exception {
    	String yn = "N";
        HashMap<String, Object> result = egovNctsMngrEdcRequsetMapper.selectMngrEdcReqstDetail(param);
        int cnt = egovNctsMngrEdcRequsetMapper.selectInstrctrReportCnt(param);
        if(cnt >= 1) yn = "Y";
        
        String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) result.get("REFER_MATTER_FILE"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
        result.put("fileView", fileView);
        result.put("INSTRCTR_ACT_STATUS", yn);
        return result;
    }
    
    public void mngrEduReqstProcess(MngrEdcRequestVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)){
        	if(null != param.getOriCenterCd() && null != param.getCenterCd()) {
        		if(!param.getOriCenterCd().equals(param.getCenterCd())) egovNctsMngrEdcRequsetMapper.insertReqstCenterRecord(param);
        	}
        	
            egovNctsMngrEdcRequsetMapper.updateEdcRequset(param);
        } else if(ProcType.DELETE.equals(procType)){
            egovNctsMngrEdcRequsetMapper.delEdcRequset(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public HashMap<String, Object> selectCommonExcel(MngrEdcRequestVO vo)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrEdcRequsetMapper.selectCommonExcel(vo);

        paramMap.put("rsList",rsTp);
        fileName = "mngrEdcRequestList";
        templateFile = "mngrEdcRequestList.xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }

    @Override
    public List<HashMap<String, Object>> selectMngrEdcInstrctrAsignList(PageInfoVO pageVO) throws Exception {
    	int cnt = egovNctsMngrEdcRequsetMapper.selectMngrEdcInstrctrAsignTotCnt(pageVO);
    	pageVO.setTotalRecordCount(cnt);
    	List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequsetMapper.selectMngrEdcInstrctrAsignList(pageVO);
    	return rslist;
    }
    
    @Override
    public HashMap<String, Object> instrctrAsignProcess(MngrEdcInstrctrVO param) throws Exception {
    	ProcType procType = ProcType.findByProcType(param.getProcType());
    	HashMap<String, Object> rs = new HashMap<String, Object>();
    	String result = "Y";
    	int cnt = egovNctsMngrEdcRequsetMapper.selectMngrEduInstrctrDcsnTotCnt(param);
    	
    	if(ProcType.INSERT.equals(procType) || ProcType.UPDATE.equals(procType)) {
    		if(cnt >= 10) {
    			result = "N";
    		} else {
    			param.setDelAt("N");
    			param.setDcsnYn("Y");
    			egovNctsMngrEdcRequsetMapper.instrctrAsignProcess(param);
    		}
    	} else if(ProcType.DELETE.equals(procType)) {
    		param.setDelAt("N");
    		param.setDcsnYn("F");
    		egovNctsMngrEdcRequsetMapper.instrctrAsignProcess(param);
    	} else {
    		throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
    	}
    	rs.put("rs", result);
    	return rs;
    }

	@Override
	public List<HashMap<String, Object>> selectMngrEduReqstApplicantList(MngrEdcRequestVO param) throws Exception{
		List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequsetMapper.selectMngrEduReqstApplicantList(param);
		return rslist;
	}

	@Override
	public void MngrEduReqstApplicantProcess(MngrEduRequstApplicantVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if(ProcType.UPDATE.equals(procType)) {
			egovNctsMngrEdcRequsetMapper.updateMngrEduReqstApplicant(param);
		} else {
			List<MngrEduRequstApplicantVO> applicantList = param.getApplicantList();
			
			if(null != applicantList) {
				for(MngrEduRequstApplicantVO list : applicantList) {
					if(ProcType.INSERT.equals(procType)) {
						list.setEduSeq(param.getEduSeq());
						MngrEdcRequestVO vo = new MngrEdcRequestVO();
						vo.setUserNm(list.getUserNm());
						vo.setUserId(list.getUserId());
						HashMap<String, Object> applicantDetail = egovNctsMngrEdcRequsetMapper.selectIrregEduApplcnt(vo);
						if(null == applicantDetail) throw new Exception("01");
						list.setUserNo(String.valueOf(applicantDetail.get("USER_NO")));
						
						int detailCd = Integer.parseInt(applicantDetail.get("DETAIL_GRADE_CD").toString());
						int courses = Integer.parseInt(param.getCourses());
						int instrctrDetailCd = Integer.parseInt(applicantDetail.get("INSTRCTR_DETAIL_GRADE_CD").toString());
						if((4 == courses && 99 == instrctrDetailCd) || (1 != courses && 4 != courses && 7 != courses && detailCd < courses)) list.setApplStat("I");
						
						if(!"I".equals(list.getApplStat())) egovNctsMngrEdcRequsetMapper.insertMngrEduReqstApplicant(list);
					} else if(ProcType.DELETE.equals(procType)) {
						if(!(null == list.getAppliSeq() || "".equals(list.getAppliSeq()))) egovNctsMngrEdcRequsetMapper.deleteMngrEduReqstApplicant(list);
					} else {
						throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
					}
				}
			}
		}
	}

	@Override
	public HashMap<String, Object> mngrEdcRequsetApplicantDownload(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrEdcRequsetMapper.mngrEdcRequsetApplicantDownload(pageVO);
        MngrEdcRequestVO vo = new MngrEdcRequestVO();
        vo.setReqstSeq(pageVO.getEduSeq());
        vo.setEduDivision(pageVO.getEduDivision());
        HashMap<String, Object> re = egovNctsMngrEdcRequsetMapper.selectMngrEdcReqstDetail(vo);
        paramMap.put("rsList",rsTp);
        paramMap.put("re",re);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
		
		return rs;
	}
	
	@Override
	public void updateApplAtProcess(MngrEdcRequestVO param)throws Exception{
	    ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)){
            egovNctsMngrEdcRequsetMapper.updateApplAtProcess(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
	}

	@Override
	public List<HashMap<String, Object>> selectIrregEduList() throws Exception {
		List<HashMap<String, Object>> codeList = egovNctsMngrEdcRequsetMapper.selectIrregEduList();
		return codeList;
	}
	
	@Override
	public void updateReqstComplProgress(HttpServletRequest request, MngrEduRequstApplicantVO param) throws Exception {
	    String[] complYn = param.getComplProcUser().split(",");
	    CustomUser customUser = SessionUtil.getProperty(request);
	    String userId = ""; 
	    if(null != customUser) userId = customUser.getUserId();
		String ip = request.getHeader("X-Forwarded-For");
        if (ip == null) ip = request.getRemoteAddr();
        param.setUserIp(ip);
        MngrMemberVO mngrMemberVO = new MngrMemberVO();
        
        try{
            for(int i=0; i<complYn.length; i++){
            	MngrEdcRequestVO vo = new MngrEdcRequestVO();
            	vo.setReqstSeq(param.getReqstSeq());
                vo.setPageType("irreg");
                vo.setComplProcUser(complYn[i]);
                vo.setCourses(param.getCourses());
                HashMap<String, Object> applicantDetail = egovNctsMngrEdcRequsetMapper.selectMngrEduReqstApplicantDetail(vo);
                vo.setUserId((String) applicantDetail.get("USER_ID"));
                vo.setUserNm((String) applicantDetail.get("USER_NM"));
                vo.setUserHp((String) applicantDetail.get("USER_HP"));
                vo.setUserOrg((String) applicantDetail.get("USER_ORG"));
                vo.setRegistIp(ip);
                vo.setFrstRegisterId(userId);
                vo.setLastUpdusrId(userId);
                vo.setEduDivision(param.getEduDivision());
                
                egovNctsMngrEdcRequsetMapper.updateIrreApplicntUserNo(vo);
                HashMap<String, Object> rs = egovNctsMngrEdcRequsetMapper.selectIrreApplicntUserNo(vo);
                if(!(null == rs || "".equals(rs))){
                	vo.setUserNo(rs.get("USER_NO").toString());
                	mngrMemberVO.setUserNo(Integer.parseInt(vo.getUserNo()));
                	egovNctsMngrEdcRequsetMapper.updateComplProgress(vo);
                	egovNctsMngrEdcRequsetMapper.updateUserCert(vo);
                	HashMap<String, Object> memberDetail = egovNctsMngrMemberMapper.selectMngrMemberDetail(mngrMemberVO);
                	mngrMemberVO.setDetailGradeCd((String) memberDetail.get("DETAIL_GRADE_CD"));
                	mngrMemberVO.setInstrctrDetailGradeCd((String) memberDetail.get("INSTRCTR_DETAIL_GRADE_CD"));
                	if(0 >= egovNctsMngrEdcRequsetMapper.getEdcIsueCount(vo)){
                		egovNctsMngrEdcRequsetMapper.insertComplProgress(vo);
                	}
                	resultCompCourse(vo);
                	updateGrade(mngrMemberVO);
                	
                    MngrCommonVO commonVO = new MngrCommonVO();
                    commonVO.setUserNo(vo.getUserNo());
                    commonVO.setFrstRegisterId(userId);
                    egovNctsMngrCommonService.packageCertificateProgress(commonVO);                	
                }
                else {
                	egovNctsMngrEdcRequsetMapper.updateComplProgress(vo);
                	if(0 >= egovNctsMngrEdcRequsetMapper.selectNullUser(vo)){
                		egovNctsMngrEdcRequsetMapper.insertComplProgress(vo);
                	};
                }
            }
        }catch(DataAccessException e){
            LOGGER.debug(e.getMessage());
            throw e;
        }
	}
	
	public void resultCompCourse(MngrEdcRequestVO param) throws Exception{
		for(int i=0; i<4; i++){
			String course = "0" + (i+1);
			
			MngrEdcRequestVO vo = new MngrEdcRequestVO();
			vo.setCourses(course);
			vo.setComplProcUser(param.getComplProcUser());
			vo.setUserNo(param.getUserNo());
			vo.setUserOrg(param.getUserOrg());
			try{
			    if("Y".equals(complYn(param, course))){
			        egovNctsMngrEdcRequsetMapper.insertCertificate(vo);
			    }
			} catch(DataAccessException e){
			    LOGGER.debug(e.getMessage());
			    throw e;
			}
		}
	}
	
	public String complYn(MngrEdcRequestVO vo, String course) throws Exception{
		String complYn = "N";
		
		vo.setCourses(course);
		
		try{
		    if(0 >= egovNctsMngrEdcRequsetMapper.selectCertificate(vo)){
		        List<HashMap<String, Object>> certList = null;
		        List<HashMap<String, Object>> ruleList = null;
		        
		        int onlectComplCount =  egovNctsMngrEdcRequsetMapper.onlectComplCount(vo);
		        int onlectCount =  egovNctsMngrEdcRequsetMapper.onlectCount(vo);
		        certList = egovNctsMngrEdcRequsetMapper.getCertCd(vo);
		        ruleList = egovNctsMngrEdcRequsetMapper.getRuleList(vo);
		        
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
	
	public void updateGrade(MngrMemberVO param) throws Exception {
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
	public List<HashMap<String, Object>> selectReqstCenterRecordList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsMngrEdcRequsetMapper.selectReqstCenterRecordListTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        List<HashMap<String, Object>> rslist = egovNctsMngrEdcRequsetMapper.selectReqstCenterRecordList(pageVO);
		return rslist;
	}

}
