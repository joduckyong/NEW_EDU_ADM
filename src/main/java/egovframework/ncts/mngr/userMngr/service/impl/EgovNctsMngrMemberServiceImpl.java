package egovframework.ncts.mngr.userMngr.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.nbp.ncp.nes.ApiResponse;
import com.nbp.ncp.nes.model.EmailSendResponse;

import egovframework.com.AESCrypt;
import egovframework.com.Sha256Crypto;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEduProgressMapper;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduProgressVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrMemberMapper;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsMngrMemberServiceImpl implements EgovNctsMngrMemberService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrMemberServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrMemberMapper egovNctsMngrMemberMapper;
    
    @Autowired
    private EgovNctsMngrEduProgressMapper mngrEduProgressMapper;

    @Autowired
    private EgovNctsMngrCommonService egovNctsMngrCommonService;	
    
    @Override
    public List<HashMap<String, Object>> selectMngrMemberList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsMngrMemberMapper.selectMngrMemberCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        pageVO.setRecordCountPerPage(10);
        return egovNctsMngrMemberMapper.selectMngrMemberList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectMngrMemberDetail(MngrMemberVO param) throws Exception {
        HashMap<String, Object> result = egovNctsMngrMemberMapper.selectMngrMemberDetail(param);
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString(); 
        
        result.put("fileView", fileView);
        return result;
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrMemberSeDetail(MngrMemberVO param) throws Exception {
        return egovNctsMngrMemberMapper.selectMngrMemberSeDetail(param);
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrMemberSeVideoDetail(MngrMemberVO param) throws Exception {
    	return egovNctsMngrMemberMapper.selectMngrMemberSeVideoDetail(param);
    }
    
    @Override
    public void mngrProc(MngrMemberVO param) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        try{
            if(ProcType.UPDATE.equals(procType)) {
                egovNctsMngrMemberMapper.mngrUpdateProc(param);
                
                if(!(null == param.getCertCdList() || "".equals(param.getCertCdList()))){
                	try {
	                    String[] certCdList = param.getCertCdList().split("[|]");
	                    String[] certCompList = param.getCertComplCdList().split("[|]");
                    
	                    for(int i = 0; i < certCdList.length; i++){
	                        MngrMemberVO certParam = new MngrMemberVO();
	
	                        certParam.setUserNo(param.getUserNo());
	                        certParam.setCertCd(certCdList[i]);
	                        certParam.setCertComplCd(certCompList[i]);
	                        
	                        int certCnt = egovNctsMngrMemberMapper.getCertCnt(certParam);
	                        
	                        if(0 == certCnt){
	                            egovNctsMngrMemberMapper.insertCertProc(certParam);
	                        } else {
	                            egovNctsMngrMemberMapper.updateCertProc(certParam);
	                        }
	                        
	                        if(0 >= egovNctsMngrMemberMapper.selectCntIssue(certParam)){
	                            if("P".equals(certParam.getCertComplCd())){
	                                egovNctsMngrMemberMapper.insertIssue(certParam);
	                            }
	                        } else {
	                            if(!"P".equals(certParam.getCertComplCd())){
	                                egovNctsMngrMemberMapper.deleteIssue(certParam);
	                            }
	                        }
	                    }
                	} catch(ArrayIndexOutOfBoundsException e) {
                		LOGGER.debug(e.getMessage());
                		throw e;
                	}
                }
            } else if(ProcType.INSERT.equals(procType)) {
                egovNctsMngrMemberMapper.mngrInsertProc(param);
            }
            
            resultCompCourse(param);
            updateGrade(param);
            
            MngrCommonVO commonVO = new MngrCommonVO();
            commonVO.setUserNo(Integer.toString(param.getUserNo()));
            commonVO.setFrstRegisterId(param.getFrstRegisterId());
            egovNctsMngrCommonService.packageCertificateProgress(commonVO);            
        }catch(DataAccessException e){
            LOGGER.debug(e.getMessage());
            throw e;
        }
    }
    
    public void updateGrade(MngrMemberVO param) throws Exception {
    	if("".equals(param.getDetailGradeCd())) param.setDetailGradeCd("00");
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

    public void delMember(MngrMemberVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
            egovNctsMngrMemberMapper.delMember(param);
        }
    }
    
    public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception{
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrMemberMapper.selectCommonExcel(pageVO);

        paramMap.put("rsList",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }
    
    public Object getDecryptPw(Object object)throws Exception{
        AESCrypt.decrypt((String)object);
        
        return AESCrypt.decrypt((String)object);
    }
    
    public String randomKey() throws Exception {
    	StringBuffer sbf = new StringBuffer();
    	Random random = new Random();
    	for(int i=0; i < 8; i++){
    		int choiceChar = random.nextInt(3);
    		
    		if(choiceChar == 0){
    			sbf.append((char)((int)(random.nextInt(26)) + 97));
    		}else if(choiceChar == 1){
    			sbf.append((char)((int)(random.nextInt(26)) + 65));
    		}else if(choiceChar == 2){
    			sbf.append((int)(random.nextInt(10)));
    		}
    	}
    	return sbf.toString();
    }
    
    public void updatePwProc(ApiResponse<EmailSendResponse> result, MngrMemberVO param, String randomKey) throws Exception {
    	String requestId = result.getBody().getRequestId();
    	param.setUserPw(Sha256Crypto.encryption(randomKey));
    	egovNctsMngrMemberMapper.updateUserPwd(param);
    	
    	MngrCommonVO mcVO = new MngrCommonVO();
    	mcVO.setRequestId(requestId);
    	mcVO.setCateGubun("0");
    	mcVO.setUniqueNo(String.valueOf(param.getUserNo()));
    	egovNctsMngrCommonService.getMailList(mcVO);
    }
    
    public List<HashMap<String, Object>> selecSeDetail(MngrMemberVO param)throws Exception{
        return egovNctsMngrMemberMapper.selecSeDetail(param);
    }
    
    public void resultCompCourse(MngrMemberVO param) throws Exception{
        for(int i=0; i<4; i++){
            String course = "0" + (i+1);
            
            MngrEduProgressVO vo = new MngrEduProgressVO();
            
            vo.setCourses(course);
            vo.setUserNo(Integer.toString(param.getUserNo()));
            vo.setPsitn(param.getCurrentJobNm());
            try{
                if("Y".equals(complYn(vo, course))){
                    mngrEduProgressMapper.insertCertificate(vo);
                }
            }catch(DataAccessException e){
                LOGGER.debug(e.getMessage());
                throw e;
            }
        }
    }
    
    public String complYn(MngrEduProgressVO vo, String course) throws Exception{
        String complYn = "N";
        
        MngrEduProgressVO param = new MngrEduProgressVO();
        
        param.setUserNo(vo.getUserNo());
        param.setCourses(course);
        
        try{
            if(0 >= mngrEduProgressMapper.selectCertificate(param)){  
                List<HashMap<String, Object>> certList = null;
                List<HashMap<String, Object>> ruleList = null;
                
                int onlectComplCount =  mngrEduProgressMapper.onlectComplCount(param);
                int onlectCount =  mngrEduProgressMapper.getOnlectCount(param);
                certList = mngrEduProgressMapper.getCertCd(param);
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

	@Override
	public List<HashMap<String, Object>> getCodeByGroupField(String codeId) throws Exception {
		return egovNctsMngrMemberMapper.getCodeByGroupField(codeId);
	}

	@Override
	public List<HashMap<String, Object>> getCodeByGroupLicense() throws Exception {
		return egovNctsMngrMemberMapper.getCodeByGroupLicense();
	}

	@Override
	public HashMap<String, Object> selectIdEmailChk(MngrMemberVO param) throws Exception {
		return egovNctsMngrMemberMapper.selectIdEmailChk(param);
	}
	@Override
	public void isueCertProc(MngrMemberVO param)throws Exception{
	    List<HashMap<String, Object>> ruleList = egovNctsMngrMemberMapper.getRuleList(); 
	    
	    try{
	        for(int i=0; i<ruleList.size(); i++){
	            String[] lectureList = ((String) ruleList.get(i).get("LECTURE_ID")).split("[|]");
	            
	            for(int j=0; j<lectureList.length; j++){
	                param.setCertCd(lectureList[j].replaceAll(" ", ""));
	                lectureList[j] = lectureList[j] + "|";
	                egovNctsMngrMemberMapper.upCertComple(param);
	            }
	            ruleList.get(i).get("COURSES");
	            
	            param.setCourseCd(ruleList.get(i).get("COURSES").toString());
	            param.setLectureList(lectureList);	           
	            
	            egovNctsMngrMemberMapper.upDetailGrade(param);
	            egovNctsMngrMemberMapper.isueCertProc(param);
	        }
	        
	    }catch(DataAccessException e){
	        LOGGER.debug(e.getMessage());
	        throw e;
	    }
	}

	@Override
	public void fileConfirmProcess(MngrMemberVO param) throws Exception {
		egovNctsMngrMemberMapper.insertFileConfirmAt(param);
	}

	@Override
	public List<HashMap<String, Object>> selectFileConfirmList(PageInfoVO pageVO) throws Exception {
		int cnt = egovNctsMngrMemberMapper.selectFileConfirmListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		return egovNctsMngrMemberMapper.selectFileConfirmList(pageVO);
	}


	@Override
	public void updateMngrMemberNote(MngrMemberVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
        if(ProcType.UPDATE.equals(procType)){
            egovNctsMngrMemberMapper.updateMngrMemberNote(param);
        }
	}

	@Override
	public void updateMngrMemberEntrstDe(MngrMemberVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
        if(ProcType.UPDATE.equals(procType)){
            egovNctsMngrMemberMapper.updateMngrMemberEntrstDe(param);
        }
	}
	
	@Override
	public void updateMngrMemberPackageAuthAt(MngrMemberVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if(ProcType.UPDATE.equals(procType)){
			egovNctsMngrMemberMapper.updateMngrMemberPackageAuthAt(param);
		}
	}

	@Override
	public List<HashMap<String, Object>> selectMemberNoteList(PageInfoVO pageVO) throws Exception {
		int cnt = egovNctsMngrMemberMapper.selectMemberNoteListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		return egovNctsMngrMemberMapper.selectMemberNoteList(pageVO);
	}
	
	@Override
	public void mngrMemberNoteProc(MngrMemberVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if(ProcType.INSERT.equals(procType)){
			egovNctsMngrMemberMapper.insertMemberNote(param);
		}
		else if(ProcType.UPDATE.equals(procType)){
			egovNctsMngrMemberMapper.updateMemberNote(param);
		}
		else if(ProcType.DELETE.equals(procType)){
			egovNctsMngrMemberMapper.deleteMemberNote(param);
		}
	}

	@Override
	public HashMap<String, Object> selectMemberNoteDetail(MngrMemberVO param) throws Exception {
		return egovNctsMngrMemberMapper.selectMemberNoteDetail(param);
	}
}
