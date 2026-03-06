package egovframework.ncts.mngr.eduReqstMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.AESCrypt;
import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEduMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;

@Service
public class EgovNctsMngrEduServiceImpl implements EgovNctsMngrEduService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrEduMapper egovNctsMngrEduMapper;
    @Autowired
    private EgovNctsMngrCommonService egovNctsMngrCommonService;	

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void mngrEduProcess(MngrEduVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
			
		if (ProcType.INSERT.equals(procType) || ProcType.UPDATE.equals(procType)) {
			if(ProcType.INSERT.equals(procType)) egovNctsMngrEduMapper.insertMngrEdu(param);
			else egovNctsMngrEduMapper.updateMngrEdu(param);
			
			MngrCommonVO commonVO = new MngrCommonVO();
			commonVO.setPwSeq(param.getPwSeq());
			commonVO.setTypeCd(param.getTypeCd());
			commonVO.setBbsNo(param.getEduSeq());
			commonVO.setBbsPw(param.getBbsPw());
			commonVO.setFrstRegisterId(param.getFrstRegisterId());
			commonVO.setLastUpdusrId(param.getLastUpdusrId());			
			egovNctsMngrCommonService.bbsPwProc(commonVO);
		}else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduMapper.deleteMngrEdu(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	@Override
	public String mngrEduApplicantProcess(MngrEduApplicantVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		String rs = "Y";
		// int cnt = egovNctsMngrEduMapper.selectMngrEduApplicantListTotCnt(param);
		int cnt = 0;
		if(cnt >= 1) {
			rs = "N";
		} else {
			if (ProcType.INSERT.equals(procType)) {
				egovNctsMngrEduMapper.insertMngrEduApplicant(param);
			}else if (ProcType.UPDATE.equals(procType)) {
				egovNctsMngrEduMapper.updateMngrEduApplicant(param);
			}else{
				throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
			}
		}
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMngrEduApplicantList(MngrEduApplicantVO param) throws Exception {
		List<HashMap<String, Object>> rs = egovNctsMngrEduMapper.selectMngrEduApplicantList(param);
		
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
	public HashMap<String, Object> selectMngrEduDetail(MngrEduVO vo) throws Exception {
		String yn = "N";
		int cnt = egovNctsMngrEduMapper.selectRegInstrctrReportCnt(vo);
        if(cnt >= 1) {
        	yn = "Y";
        } 
		HashMap<String, Object> rs = egovNctsMngrEduMapper.selectMngrEduDetail(vo);
		rs.put("EDU_CN", ParamUtils.reverseHtmlTag((String)rs.get("EDU_CN")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		rs.put("INSTRCTR_ACT_STATUS", yn);
		
		if(null != rs.get("BBS_PW") && !"".equals(rs.get("BBS_PW"))) rs.put("BBS_PW", AESCrypt.decrypt(rs.get("BBS_PW").toString()));
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMngrEduList(PageInfoVO searchVO) throws Exception {
		int cnt = egovNctsMngrEduMapper.selectMngrEduListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return egovNctsMngrEduMapper.selectMngrEduList(searchVO);
	}
	
	@Override
	public List<HashMap<String, Object>> selectEduList()throws Exception {
	    
	    return egovNctsMngrEduMapper.selectEduList();
	}

	@Override
	public HashMap<String, Object> selectRegEduAplcStatus(MngrEduVO vo) throws Exception {
		HashMap<String, Object> rs = egovNctsMngrEduMapper.selectRegEduAplcStatus(vo);
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectInstrctrOriList(MngrEdcInstrctrVO vo) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsMngrEduMapper.selectInstrctrOriList(vo);
		return rslist;
	}

	@Override
	public HashMap<String, Object> mngrEduApplicantDownload(MngrEduApplicantVO param) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        HashMap<String, Object> re = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        MngrEduVO vo = new MngrEduVO();
        
        vo.setEduSeq(param.getEduSeq());
        vo.setEduDivision(param.getEduDivision());
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrEduMapper.mngrEduApplicantDownload(param);
        re = egovNctsMngrEduMapper.selectMngrEduDetail(vo);
        if(!("".equals(re.get("INSTRCTR_NM_S")) || null == re.get("INSTRCTR_NM_S"))) re.put("INSTRCTR_NM_S", "," + re.get("INSTRCTR_NM_S"));
        else re.put("INSTRCTR_NM_S", "");
        paramMap.put("rd", re);
        paramMap.put("rsList",rsTp);
        fileName = param.getExcelFileNm();
        templateFile = param.getExcelPageNm()+".xlsx";
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
		
		return rs;
	}

	@Override
	public HashMap<String, Object> tempInstrctrAsignProcess(MngrEdcTempInstrctrVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		HashMap<String, Object> result = new HashMap<String, Object>();
 		String tempKey = "";
		String rs = "Y";
		
		if (ProcType.INSERT.equals(procType)) {
			int cnt = egovNctsMngrEduMapper.selectTempInstrctrListTotCnt(param);
			if(cnt >= 10) rs = "N";
			tempKey = egovNctsMngrEduMapper.selectTempInstrctrAsignKey(param);
			if(!(null == param.getTempSeq() || "".equals(param.getTempSeq()))) tempKey = param.getTempSeq();
			param.setTempSeq(tempKey);
			if("Y".equals(rs)) egovNctsMngrEduMapper.insertTempInstrctrAsign(param);
		}else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduMapper.deleteTempInstrctrAsign(param);
		} else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
		result.put("rs", rs);
		result.put("tempKey", tempKey);
		return result;
	}
	
	@Override
	public void insertInstrctrAsign(MngrEdcInstrctrVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
		if (ProcType.INSERT.equals(procType)) {
			/*if(!(null == param.getEduInstNo() || "".equals(param.getEduInstNo()))) {
				String[] instrctrNo = param.getEduInstNo().split(",");
				
				for(String a : instrctrNo) {
					param.setInstrctrNo(a);
					param.setInstrctrDivision("I");
					egovNctsMngrEduMapper.insertInstrctrAsign(param);
				}
			}
			
			if(!(null == param.getEduAssistInstNo() || "".equals(param.getEduAssistInstNo()))) {
				String[] instrctrAssistNo = param.getEduAssistInstNo().split(",");				
				for(String a : instrctrAssistNo) {
					param.setInstrctrNo(a);
					param.setInstrctrDivision("S");
					egovNctsMngrEduMapper.insertInstrctrAsign(param);
				}
			}*/
			
			egovNctsMngrEduMapper.insertInstrctrAsign(param);
			
			MngrEdcTempInstrctrVO vo = new MngrEdcTempInstrctrVO();
			vo.setTempSeq(param.getTempSeq());
			egovNctsMngrEduMapper.deleteTempInstrctrAsign(vo);
		} else if(ProcType.UPDATE.equals(procType)) {
			if(null != param.getOriEduDivision() && null != param.getEduDivision() && !param.getOriEduDivision().equals(param.getEduDivision())) {
				egovNctsMngrEduMapper.updateInstrctrAsign(param);
				egovNctsMngrEduMapper.updateInstrctrAct(param);
			}
		}
	}

	@Override
	public List<HashMap<String, Object>> selectTempInstrctrList(MngrEdcTempInstrctrVO param) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsMngrEduMapper.selectTempInstrctrList(param);
		return rslist;
	}

	@Override
	public void updateInstrctrOthbcYnProcess(MngrEduVO param) throws Exception {
		egovNctsMngrEduMapper.updateInstrctrOthbcYnProcess(param);
		
	}
}
