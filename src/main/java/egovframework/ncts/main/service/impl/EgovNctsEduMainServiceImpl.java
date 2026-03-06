package egovframework.ncts.main.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.main.mapper.EgovNctsEduMainMapper;
import egovframework.ncts.main.mapper.EgovNctsMainMapper;
import egovframework.ncts.main.service.EgovNctsEduMainService;
import egovframework.ncts.main.service.EgovNctsMainService;
import egovframework.ncts.main.vo.MainVO;

@Service
public class EgovNctsEduMainServiceImpl implements EgovNctsEduMainService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMainServiceImpl.class);
	
	 @Autowired
     private EgovNctsEduMainMapper egovNctsEduMainMapper;

     @Resource(name = "egovMessageSource")
     EgovMessageSource egovMessageSource;


    @Override
 	public List<HashMap<String, Object>> selectNoticeList() throws Exception {
    	return egovNctsEduMainMapper.selectNoticeList();
 	} 
     
	@Override
	public HashMap<String, Object> selectHomeStatusUser() throws Exception {
		return egovNctsEduMainMapper.selectHomeStatusUser();
	}
	
	@Override
	public HashMap<String, Object> selectVisitUser() throws Exception {
		return egovNctsEduMainMapper.selectVisitUser();
	}
	
	@Override
	public HashMap<String, Object> selectOneOnOne(HashMap<String, Object> parameters) throws Exception {
		return egovNctsEduMainMapper.selectOneOnOne(parameters);
	}

	@Override
	public HashMap<String, Object> selectEdu(HashMap<String, Object> parameters) throws Exception {
		return egovNctsEduMainMapper.selectEdu(parameters);
	}

	@Override
	public HashMap<String, Object> selectApplicant(HashMap<String, Object> parameters) throws Exception {
		return egovNctsEduMainMapper.selectApplicant(parameters);
	}
	@Override
	public HashMap<String, Object> selectApplicantGroupBy(HashMap<String, Object> parameters) throws Exception {
		return egovNctsEduMainMapper.selectApplicantGroupBy(parameters);
	}

	@Override
	public HashMap<String, Object> eduVisitUserDownload(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "eduVisitUser1";
        String templateFile = "eduVisitUser1.xlsx";
        
        try{
        	List<HashMap<String, Object>> rsTp = egovNctsEduMainMapper.eduVisitUserDownload(pageVO);
        	
        	paramMap.put("rsList",rsTp);
        	
        	if("2021".equals(pageVO.getSearchCondition1())) {
        		fileName = "eduVisitUser2";
        		templateFile = "eduVisitUser2.xlsx";
        	}
        	
        	rs.put("paramMap", paramMap);
        	rs.put("fileName", fileName);
        	rs.put("templateFile", templateFile);
        	
        } catch(Exception e) {
        	LOGGER.debug(e.getMessage());
        }
        return rs;
	}

	@Override
	public HashMap<String, Object> selectInstrctrUser() throws Exception {
		return egovNctsEduMainMapper.selectInstrctrUser();
	}
}
