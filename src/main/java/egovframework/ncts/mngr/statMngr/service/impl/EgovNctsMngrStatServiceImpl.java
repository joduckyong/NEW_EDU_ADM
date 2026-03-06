package egovframework.ncts.mngr.statMngr.service.impl;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.statMngr.mapper.EgovNctsMngrStatMapper;
import egovframework.ncts.mngr.statMngr.service.EgovNctsMngrStatService;


@Service
public class EgovNctsMngrStatServiceImpl implements EgovNctsMngrStatService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrStatServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrStatMapper egovNctsMngrStatMapper;

	@Override
	public HashMap<String, Object> selectStMngrCnt001(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrCnt001(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrNum001(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrNum001(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrGroupNum001(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrGroupNum001(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrCnt002(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrCnt002(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrNum002(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrNum002(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrGroupNum002(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrGroupNum002(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStMngrCnt003(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStMngrCnt003(pageVO);
	}

	@Override
	public HashMap<String, Object> statMngrExcelDownload(PageInfoVO pageVO) throws Exception {
		HashMap<String, Object> rs = new HashMap<>();
		HashMap<String, Object> paramMap = new HashMap<>();
		String fileName = "";
		String templateFile = "";
		
		
		if(!(null == pageVO.getExcelPageNm() || "".equals(pageVO.getExcelPageNm()))){
			if("stMngr001".equals(pageVO.getExcelPageNm())) {
			
				pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
				paramMap.put("MngrCnt001N2",egovNctsMngrStatMapper.selectStMngrCnt001(pageVO));
				paramMap.put("MngrNum001N2",egovNctsMngrStatMapper.selectStMngrNum001(pageVO));
				paramMap.put("MngrGroupNum001N2",egovNctsMngrStatMapper.selectStMngrGroupNum001(pageVO));
			
				pageVO.setSearchCondition1("");
				pageVO.setSearchCondition2(pageVO.getsYear());
				paramMap.put("MngrCnt001N3",egovNctsMngrStatMapper.selectStMngrCnt001(pageVO));
				paramMap.put("MngrNum001N3",egovNctsMngrStatMapper.selectStMngrNum001(pageVO));
				paramMap.put("MngrGroupNum001N3",egovNctsMngrStatMapper.selectStMngrGroupNum001(pageVO));
			
				pageVO.setSearchCondition2("");
				paramMap.put("MngrCnt001N1",egovNctsMngrStatMapper.selectStMngrCnt001(pageVO));
				paramMap.put("MngrNum001N1",egovNctsMngrStatMapper.selectStMngrNum001(pageVO));
				paramMap.put("MngrGroupNum001N1",egovNctsMngrStatMapper.selectStMngrGroupNum001(pageVO));
				
				fileName = pageVO.getExcelFileNm();
				templateFile = "stMngr001.xlsx";
			}
			else if("stMngr002".equals(pageVO.getExcelPageNm())) {
			
				pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
				paramMap.put("MngrCnt002N2",egovNctsMngrStatMapper.selectStMngrCnt002(pageVO));
				paramMap.put("MngrNum002N2",egovNctsMngrStatMapper.selectStMngrNum002(pageVO));
				paramMap.put("MngrGroupNum002N2",egovNctsMngrStatMapper.selectStMngrGroupNum002(pageVO));
			
				pageVO.setSearchCondition1("");
				pageVO.setSearchCondition2(pageVO.getsYear());
				paramMap.put("MngrCnt002N3",egovNctsMngrStatMapper.selectStMngrCnt002(pageVO));
				paramMap.put("MngrNum002N3",egovNctsMngrStatMapper.selectStMngrNum002(pageVO));
				paramMap.put("MngrGroupNum002N3",egovNctsMngrStatMapper.selectStMngrGroupNum002(pageVO));
			
				pageVO.setSearchCondition2("");
				paramMap.put("MngrCnt002N1",egovNctsMngrStatMapper.selectStMngrCnt002(pageVO));
				paramMap.put("MngrNum002N1",egovNctsMngrStatMapper.selectStMngrNum002(pageVO));
				paramMap.put("MngrGroupNum002N1",egovNctsMngrStatMapper.selectStMngrGroupNum002(pageVO));
				
				fileName = pageVO.getExcelFileNm();
				templateFile = "stMngr002.xlsx";
			}
			else if("stMngr003".equals(pageVO.getExcelPageNm())) {
			
				pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
				paramMap.put("MngrCnt003N2",egovNctsMngrStatMapper.selectStMngrCnt003(pageVO));
		
				pageVO.setSearchCondition1("");
				pageVO.setSearchCondition2(pageVO.getsYear());
				paramMap.put("MngrCnt003N3",egovNctsMngrStatMapper.selectStMngrCnt003(pageVO));
	
				pageVO.setSearchCondition2("");
				paramMap.put("MngrCnt003N1",egovNctsMngrStatMapper.selectStMngrCnt003(pageVO));
				
				fileName = pageVO.getExcelFileNm();
				templateFile = "stMngr003.xlsx";
			}
			else if("stGnrlMngr001".equals(pageVO.getExcelPageNm())) {

				pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
				paramMap.put("GnrlMngr001N2",egovNctsMngrStatMapper.selectStGnrlMngr001(pageVO));

				pageVO.setSearchCondition1("");
				pageVO.setSearchCondition2(pageVO.getsYear());
				paramMap.put("GnrlMngr001N3",egovNctsMngrStatMapper.selectStGnrlMngr001(pageVO));

				pageVO.setSearchCondition2("");
				paramMap.put("GnrlMngr001N1",egovNctsMngrStatMapper.selectStGnrlMngr001(pageVO));
				
				fileName = pageVO.getExcelFileNm();
				templateFile = "stGnrlMngr001.xlsx";
			}
			else if("stGnrlMngr002".equals(pageVO.getExcelPageNm())) {

				pageVO.setSearchCondition1(pageVO.getsYear() + pageVO.getsMonth());
				paramMap.put("GnrlMngr002N2",egovNctsMngrStatMapper.selectStGnrlMngr002(pageVO));

				pageVO.setSearchCondition1("");
				pageVO.setSearchCondition2(pageVO.getsYear());
				paramMap.put("GnrlMngr002N3",egovNctsMngrStatMapper.selectStGnrlMngr002(pageVO));

				pageVO.setSearchCondition2("");
				paramMap.put("GnrlMngr002N1",egovNctsMngrStatMapper.selectStGnrlMngr002(pageVO));
				
				fileName = pageVO.getExcelFileNm();
				templateFile = "stGnrlMngr002.xlsx";
			}
			
			
		}
		
		paramMap.put("searchCondition3", pageVO.getSearchCondition3());		
		paramMap.put("date", pageVO.getsDate01());		
		rs.put("paramMap", paramMap);
		rs.put("fileName", fileName);
		rs.put("templateFile", templateFile);
		
		return rs;
	}

	@Override
	public HashMap<String, Object> selectStGnrlMngr001(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStGnrlMngr001(pageVO);
	}

	@Override
	public HashMap<String, Object> selectStGnrlMngr002(PageInfoVO pageVO) throws Exception {
		return egovNctsMngrStatMapper.selectStGnrlMngr002(pageVO);
	}

    
}
