package egovframework.ncts.mngr.edcOperMngr.service.impl;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.DateUtil;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcOperMngr.mapper.EgovNctsMngrOperStatMapper;
import egovframework.ncts.mngr.edcOperMngr.service.EgovNctsMngrOperStatService;


@Service("mngrOperService")
public class EgovNctsMngrOperStatServiceImpl implements EgovNctsMngrOperStatService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrOperStatServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrOperStatMapper egovNctsMngrOperStatMapper;

	@Override
	public HashMap<String, Object> selectYearEduList(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
		
		/*rs.put("result", egovNctsMngrOperStatMapper.selectYearEduResult(pageVO));*/
		rs.put("yearList", egovNctsMngrOperStatMapper.selectYearEdu(pageVO));
		pageVO.setsGubun("M");
		rs.put("monthList", egovNctsMngrOperStatMapper.selectYearEdu(pageVO));
		return rs;
	}


	@Override
	public HashMap<String, Object> statYearEduExcelDownload(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
		
		rs.put("result", egovNctsMngrOperStatMapper.selectYearEduResult(pageVO));
		rs.put("yearList", egovNctsMngrOperStatMapper.selectYearEdu(pageVO));
		pageVO.setsGubun("M");
		rs.put("monthList", egovNctsMngrOperStatMapper.selectYearEdu(pageVO));		
		return rs;
	}
	
	public void insertDateTable() throws Exception {
		egovNctsMngrOperStatMapper.insertDateTable();
	}

    
}
