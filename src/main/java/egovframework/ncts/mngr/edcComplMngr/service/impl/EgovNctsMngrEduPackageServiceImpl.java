package egovframework.ncts.mngr.edcComplMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcComplMngr.mapper.EgovNctsMngrEduPackageMapper;
import egovframework.ncts.mngr.edcComplMngr.service.EgovNctsMngrEduPackageService;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEduPackageVO;

@Service
public class EgovNctsMngrEduPackageServiceImpl implements EgovNctsMngrEduPackageService {

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrEduPackageServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrEduPackageMapper egovNctsMngrEduPackageMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
	@Override
	public List<HashMap<String, Object>> selectMngrEduPackageInfoList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsMngrEduPackageMapper.selectMngrEduPackageInfoListTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrEduPackageMapper.selectMngrEduPackageInfoList(pageVO);
	}

	@Override
	public HashMap<String, Object> selectMngrEduPackageDetail(MngrEduPackageVO param) throws Exception {
        HashMap<String, Object> result = egovNctsMngrEduPackageMapper.selectMngrEduPackageDetail(param);
        return result;
	}

	@Override
	public void mngrEduPackageProc(MngrEduPackageVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		
        if(ProcType.INSERT.equals(procType)) {
        	egovNctsMngrEduPackageMapper.insertMngrEduPackageInfo(param);
        } else if(ProcType.UPDATE.equals(procType)) {
        	egovNctsMngrEduPackageMapper.updateMngrEduPackageInfo(param);
        	egovNctsMngrEduPackageMapper.deleteMngrEduPackageDetailCode(param);
        } else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
        
        String[] lectureIdArr = param.getLectureId().replaceAll(" ", "").split("[|]");
        for(String lectureId : lectureIdArr) {
        	param.setLectureId(lectureId);
        	egovNctsMngrEduPackageMapper.mngrEduPackageDetailCodeProc(param);
        }
	}
	
	@Override
	public void deleteMngrEduPackageInfo(MngrEduPackageVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if(ProcType.DELETE.equals(procType)) {
			egovNctsMngrEduPackageMapper.deleteMngrEduPackageInfo(param);
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}	
	}

	@Override
	public List<HashMap<String, Object>> selectMngrEduPackageDetailCodeList(MngrEduPackageVO param) throws Exception {
		return egovNctsMngrEduPackageMapper.selectMngrEduPackageDetailCodeList(param);
	}
}
