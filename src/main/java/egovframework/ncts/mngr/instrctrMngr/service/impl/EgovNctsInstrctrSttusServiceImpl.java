package egovframework.ncts.mngr.instrctrMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrSttusMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrSttusService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrSttusVO;

@Service
public class EgovNctsInstrctrSttusServiceImpl implements EgovNctsInstrctrSttusService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrSttusServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrSttusMapper egovNctsInstrctrSttusMapper;
    
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrSttusList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsInstrctrSttusMapper.selectInstrctrSttusTotCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsInstrctrSttusMapper.selectInstrctrSttusList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectInstrctrSttusDetail(MngrInstrctrSttusVO param) throws Exception {
        HashMap<String, Object> result = egovNctsInstrctrSttusMapper.selectInstrctrSttusDetail(param);
        return result;
    }

	@Override
	public HashMap<String, Object> selectInstrctrSttusExcelDownload(PageInfoVO pageVO) throws Exception {
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsInstrctrSttusMapper.selectInstrctrSttusExcelDownload(pageVO);

        paramMap.put("rslist",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectInstrctrDetailList(PageInfoVO pageVO) throws Exception {
		return egovNctsInstrctrSttusMapper.selectInstrctrDetailList(pageVO);
	}
    
}
