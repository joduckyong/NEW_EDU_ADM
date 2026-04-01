package egovframework.ncts.mngr.eduReqstMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEdcComplVO;
import egovframework.ncts.mngr.eduReqstMngr.mapper.EgovNctsMngrEduGnrlMapper;
import egovframework.ncts.mngr.eduReqstMngr.service.EgovNctsMngrEduGnrlService;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduGnrlVO;

@Service
public class EgovNctsMngrEduGnrlServiceImpl implements EgovNctsMngrEduGnrlService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduGnrlServiceImpl.class);
	
	@Autowired
	private EgovNctsMngrEduGnrlMapper egovNctsMngrEduGnrlMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Override
	public void mngrEduGnrlProcess(MngrEduGnrlVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
			
		if (ProcType.INSERT.equals(procType)) {
			egovNctsMngrEduGnrlMapper.insertMngrEduGnrl(param);
		}else if (ProcType.UPDATE.equals(procType)) {
			egovNctsMngrEduGnrlMapper.updateMngrEduGnrl(param);
		}else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduGnrlMapper.deleteMngrEduGnrl(param);
		}else{
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}
	
	@Override
	public HashMap<String, Object> selectMngrEduGnrlDetail(MngrEduGnrlVO vo) throws Exception {
		String yn = "N";
		int cnt = egovNctsMngrEduGnrlMapper.selectGnrlInstrctrReportCnt(vo);
        if(cnt >= 1) {
        	yn = "Y";
        } 
		HashMap<String, Object> rs = egovNctsMngrEduGnrlMapper.selectMngrEduGnrlDetail(vo);
		rs.put("GNRL_EDU_CN", ParamUtils.reverseHtmlTag((String)rs.get("GNRL_EDU_CN")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		rs.put("INSTRCTR_ACT_STATUS", yn);
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMngrEduGnrlList(PageInfoVO searchVO) throws Exception {
		int cnt = egovNctsMngrEduGnrlMapper.selectMngrEduGnrlListTotCnt(searchVO);
		searchVO.setTotalRecordCount(cnt);
		return egovNctsMngrEduGnrlMapper.selectMngrEduGnrlList(searchVO);
	}
	
	@Override
	public List<HashMap<String, Object>> selectInstrctrOriList(MngrEdcInstrctrVO vo) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsMngrEduGnrlMapper.selectInstrctrOriList(vo);
		return rslist;
	}

	@Override
	public HashMap<String, Object> tempInstrctrAsignProcess(MngrEdcTempInstrctrVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		HashMap<String, Object> result = new HashMap<String, Object>();
 		String tempKey = "";
		String rs = "Y";
		
		if (ProcType.INSERT.equals(procType)) {
			int cnt = egovNctsMngrEduGnrlMapper.selectTempInstrctrListTotCnt(param);
			if(cnt >= 10) rs = "N";
			tempKey = egovNctsMngrEduGnrlMapper.selectTempInstrctrAsignKey(param);
			if(!(null == param.getTempSeq() || "".equals(param.getTempSeq()))) tempKey = param.getTempSeq();
			param.setTempSeq(tempKey);
			if("Y".equals(rs)) egovNctsMngrEduGnrlMapper.insertTempInstrctrAsign(param);
		} else if (ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduGnrlMapper.deleteTempInstrctrAsign(param);
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
			if(!(null == param.getEduInstNo() || "".equals(param.getEduInstNo()))) {
				String[] instrctrNo = param.getEduInstNo().split(",");
				
				for(String a : instrctrNo) {
					param.setInstrctrNo(a);
					param.setInstrctrDivision("I");
					egovNctsMngrEduGnrlMapper.insertInstrctrAsign(param);
				}
			}
			
			if(!(null == param.getEduAssistInstNo() || "".equals(param.getEduAssistInstNo()))) {
				String[] instrctrAssistNo = param.getEduAssistInstNo().split(",");				
				for(String a : instrctrAssistNo) {
					param.setInstrctrNo(a);
					param.setInstrctrDivision("S");
					egovNctsMngrEduGnrlMapper.insertInstrctrAsign(param);
				}
			}
			MngrEdcTempInstrctrVO vo = new MngrEdcTempInstrctrVO();
			vo.setTempSeq(param.getTempSeq());
			egovNctsMngrEduGnrlMapper.deleteTempInstrctrAsign(vo);
		} 
	}

	@Override
	public List<HashMap<String, Object>> selectTempInstrctrList(MngrEdcTempInstrctrVO param) throws Exception {
		List<HashMap<String, Object>> rslist = egovNctsMngrEduGnrlMapper.selectTempInstrctrList(param);
		return rslist;
	}

	@Override
	public void updateGnrlInstrctrOthbcYnProcess(MngrEduGnrlVO param) throws Exception {
		egovNctsMngrEduGnrlMapper.updateGnrlInstrctrOthbcYnProcess(param);
		
	}

	@Override
	public List<HashMap<String, Object>> selectEduGnrlList() throws Exception {
		return egovNctsMngrEduGnrlMapper.selectEduGnrlList();
	}

	@Override
	public HashMap<String, Object> selectMngrGnrlExcelDownload(PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrEduGnrlMapper.selectMngrGnrlExcelDownload(pageVO);

        paramMap.put("rslist",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
	}
}
