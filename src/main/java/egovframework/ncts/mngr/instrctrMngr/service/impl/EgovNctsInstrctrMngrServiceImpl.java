package egovframework.ncts.mngr.instrctrMngr.service.impl;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.TextUtil;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.mapper.CommonCodeMapper;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.instrctrMngr.mapper.EgovNctsInstrctrMngrMapper;
import egovframework.ncts.mngr.instrctrMngr.service.EgovNctsInstrctrMngrService;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrMngrVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrMemberMapper;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsInstrctrMngrServiceImpl implements EgovNctsInstrctrMngrService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsInstrctrMngrServiceImpl.class);
    
    @Autowired
    private EgovNctsInstrctrMngrMapper egovNctsInstrctrMngrMapper;
    @Autowired
    private EgovNctsMngrMemberMapper egovNctsMngrMemberMapper;
	@Autowired
	private CommonCodeMapper commonCodeMapper;
    
//  String iniFilePath = "/penta/scpdb_agent.ini";
  //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
  private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
    @Override
    public List<HashMap<String, Object>> selectInstrctrMngrList(PageInfoVO pageVO) throws Exception {
    	
    	ScpDbAgent agt = new ScpDbAgent();
    	if (pageVO.getSearchKeyword2() != null && !"".equals(pageVO.getSearchKeyword2()) ) {
	    	String searchKeyword2 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword2());
	    	pageVO.setSearchKeyword2(searchKeyword2);
    	}   
    	if (pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3()) ) {
    		String searchKeyword3 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword3());
    		pageVO.setSearchKeyword3(searchKeyword3);
    	}   
        int cnt = egovNctsMngrMemberMapper.selectMngrMemberCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        pageVO.setRecordCountPerPage(10);
    	List<HashMap<String, Object>> memberList = egovNctsMngrMemberMapper.selectMngrMemberList(pageVO);
        for (HashMap<String, Object> tmp : memberList) {
        	try {
	            if (tmp.get("USER_HP_NO") != null && !"".equals(String.valueOf(tmp.get("USER_HP_NO")))) {
	            	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_HP_NO").toString(),"UTF-8");
	            	tmp.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
	            }
	            if (tmp.get("USER_EMAIL") != null && !"".equals(String.valueOf(tmp.get("USER_EMAIL")))) {
	            	tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
	            }
	            if (tmp.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH_YMD")))) {
	            	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH_YMD").toString(),"UTF-8");
	            	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	            	tmp.put("USER_BIRTH_YMD", formattedDate);
	            }
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}   
    }
        return memberList;
    }
    
    @Override
    public HashMap<String, Object> selectMngrInstrctrDetail(MngrMemberVO param) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
        HashMap<String, Object> result = egovNctsMngrMemberMapper.selectMngrMemberDetail(param);
        
    	try {
    		
            if (result.get("USER_HP_NO") != null && !"".equals(String.valueOf(result.get("USER_HP_NO")))) {
            	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_HP_NO").toString(),"UTF-8");
            	result.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
            }
            if (result.get("USER_EMAIL") != null && !"".equals(String.valueOf(result.get("USER_EMAIL")))) {
            	result.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_EMAIL").toString(),"UTF-8"));
            }
            if (result.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(result.get("USER_BIRTH_YMD")))) {
            	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_BIRTH_YMD").toString(),"UTF-8");
            	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
            	result.put("USER_BIRTH_YMD", formattedDate);
            }

    	
	        instrctrCertStatusSetting(result);
	        
	        String fileView = FileViewMarkupBuilder.newInstance()
	                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
	                .wrapMarkup("p")
	                .isIcon(true)
	                .isSize(true)
	                .build()
	                .toString(); 
	        
	        result.put("fileView", fileView);
        
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	}         
        return result;
    }    
    
    private void instrctrCertStatusSetting(HashMap<String, Object> member) throws Exception {
    	PageInfoVO pVO = new PageInfoVO();
		pVO.setUserNo(Integer.parseInt(member.get("USER_NO").toString()));
		pVO.setSearchCondition1(String.valueOf(member.get("SEARCH_CONDITION1")));
		pVO.setInstrctrGubun(String.valueOf(member.get("SEARCH_CONDITION1")));
		
		List<HashMap<String, Object>> instrctrMaxDtList = egovNctsInstrctrMngrMapper.selectInstrctrMaxDtList(pVO);
		if(null != instrctrMaxDtList && !instrctrMaxDtList.isEmpty()) {
			String instrctrGubun = "";
			String maxActDt = "";
			String maxIssueDt = "";
			String validAt = "";
			String result = "";
			boolean flag = true;
			for(HashMap<String, Object> maxDt : instrctrMaxDtList) {
				instrctrGubun = maxDt.get("INSTRCTR_GUBUN").toString();
				maxActDt = maxDt.get("MAX_ACT_DT").toString();
				maxIssueDt = maxDt.get("MAX_T_ISSUE_DT").toString();
				validAt = maxDt.get("VALID_AT").toString();
				
				if(!"01".equals(member.get(instrctrGubun + "_GRADE_CD"))) {
					member.put(instrctrGubun + "_INSTRCTR_RESULT", "00");
				}
				
				else if("".equals(maxActDt)) {
					if("".equals(maxIssueDt) || "N".equals(validAt)) result = "02";
					else if("Y".equals(validAt)) result = "99";
					member.put(instrctrGubun + "_INSTRCTR_RESULT", result);	
				}
				else {
					pVO.setInstrctrGubun(instrctrGubun);
					pVO.setIssueDt(maxActDt);
					
					
					List<HashMap<String, Object>> actDtList = egovNctsInstrctrMngrMapper.selectInstrctrActDtList(pVO);
					if(null != actDtList && !actDtList.isEmpty()) {
						for(HashMap<String, Object> dt : actDtList) {
							if(flag) {
								pVO.setIssueDt(dt.get("ACT_DT").toString());
								HashMap<String, Object> actDt = egovNctsInstrctrMngrMapper.selectInstrctrActDtDetail(pVO); 
								if(Integer.parseInt(actDt.get("ACT_CNT").toString()) < 2) {
									if("N".equals(validAt)) result = "02";
									else result = "99";
								}
								else {
									result = "01";
									flag = false;
								}
							}
						}
						member.put(instrctrGubun + "_INSTRCTR_RESULT", result);
					}
				}
			}
		}
		
    }
    
    @Override
    public HashMap<String, Object> selectInstrctrMngrDetail(MngrInstrctrMngrVO param) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
        HashMap<String, Object> result = egovNctsInstrctrMngrMapper.selectInstrctrMngrDetail(param);
        try {
	        if (result.get("USER_EMAIL") != null && !"".equals(String.valueOf(result.get("USER_EMAIL")))) {
	        	result.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_EMAIL").toString(),"UTF-8"));
	        }
	        
	        if (result.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(result.get("USER_BIRTH_YMD")))) {
	        	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",result.get("USER_BIRTH_YMD").toString(),"UTF-8");
	        	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	        	result.put("USER_BIRTH_YMD", formattedDate);
	        }  
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	}    

        return result;
    }
      
    public void mngrProc(MngrInstrctrMngrVO param) throws Exception {
    	ScpDbAgent agt = new ScpDbAgent();
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.UPDATE.equals(procType)) {
        	
        	if (param.getUserEmail() != null && !"".equals(param.getUserEmail()) ) {
    	    	String userEmail = agt.ScpEncB64(iniFilePath, "KEY1", param.getUserEmail());
    	    	param.setUserEmail(userEmail);
        	}   
        	
            egovNctsInstrctrMngrMapper.mngrUpdateProc(param);
        }
    }
    
    public HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception{
    	ScpDbAgent agt = new ScpDbAgent();
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
    	if (pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3()) ) {
	    	String searchKeyword3 = agt.ScpEncB64(iniFilePath, "KEY1", pageVO.getSearchKeyword3().replaceAll("-", "").replaceAll(" ", ""));
	    	pageVO.setSearchKeyword3(searchKeyword3);
    	}   
        List<HashMap<String, Object>> rsTp = egovNctsInstrctrMngrMapper.selectCommonExcel(pageVO);
        for (HashMap<String, Object> tmp : rsTp) {
        	try {
	            if (tmp.get("USER_EMAIL") != null && !"".equals(String.valueOf(tmp.get("USER_EMAIL")))) {
	            	tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
	            }
	            
	            if (tmp.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH_YMD")))) {
	            	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH_YMD").toString(),"UTF-8");
	            	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	            	tmp.put("USER_BIRTH_YMD", formattedDate);
	            }  
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}  
        }
        
        paramMap.put("rsList",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();        
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }

	@Override
	public List<HashMap<String, Object>> selectInstrctrOfflectList(PageInfoVO pageVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
        int cnt = egovNctsInstrctrMngrMapper.selectInstrctrOfflectListTotCnt(pageVO);
        if(10 == pageVO.getRecordCountPerPage()) pageVO.setRecordCountPerPage(20);
        pageVO.setTotalRecordCount(cnt);
        if(null == pageVO.getPageType()) pageVO.setPageType("");
        List<HashMap<String, Object>> memberList = egovNctsInstrctrMngrMapper.selectInstrctrOfflectList(pageVO); 
        List<HashMap<String, Object>> codeList = commonCodeMapper.getCodeByGroup("DMH30");
        		
    	if(null != memberList && !memberList.isEmpty()) {
    		String result = "";
    		for(HashMap<String, Object> member : memberList) {
    			try {
	    	        if (member.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(member.get("USER_BIRTH_YMD")))) {
	                	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_BIRTH_YMD").toString(),"UTF-8");
	                	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	                	member.put("USER_BIRTH_YMD", formattedDate);
	    	        }
	    	        if (member.get("USER_EMAIL") != null && !"".equals(String.valueOf(member.get("USER_EMAIL")))) {
	    	        	String userEmail = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_EMAIL").toString(),"UTF-8");
	    	        	member.put("USER_EMAIL", userEmail);
	    	        }
	    	        if (member.get("USER_HP_NO") != null && !"".equals(String.valueOf(member.get("USER_HP_NO")))) {
	    	        	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_HP_NO").toString(),"UTF-8");
	    	        	member.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
	    	        }  
    	    	}
    	    	catch (ScpDbAgentException e) {
    	    		LOGGER.info(e.getMessage());
    	    	}
    	    	catch (Exception e) {
    	    		LOGGER.info(e.getMessage());
    	    	} 
    	        
    			member.put("SEARCH_CONDITION1", pageVO.getSearchCondition1());
    			instrctrCertStatusSetting(member);	
    			
    			String instrctrResult = member.get(pageVO.getSearchCondition1() + "_INSTRCTR_RESULT").toString();
    			result = "02".equals(instrctrResult) && null != member.get("STATUS_GUBUN") ? member.get("STATUS_GUBUN").toString() : instrctrResult;
    			member.put("INSTRCTR_RESULT", result);
    			
    			for(HashMap<String, Object> code : codeList) {
    				if(result.equals(code.get("CODE"))) member.put("INSTRCTR_RESULT_TXT", code.get("CODE_NM"));
    			}
    		}
    		
			if(null != pageVO.getSearchCondition3() && !"".equals(pageVO.getSearchCondition3())) {
				String orderVal = pageVO.getSearchCondition3();
				
				Iterator<HashMap<String, Object>> it = memberList.iterator();
				while(it.hasNext()) {
					HashMap<String, Object> de = it.next();
					if(!orderVal.equals(de.get("INSTRCTR_RESULT"))) {
						it.remove();
					}
				}
				/*Collections.sort(memberList, (v1, v2)-> {
					String val1 = String.valueOf(v1.get("INSTRCTR_RESULT"));
					String val2 = String.valueOf(v2.get("INSTRCTR_RESULT"));
					
					if (orderVal.equals(val1) && !orderVal.equals(val2)) {
						return -1;
					} else if (!orderVal.equals(val1) && orderVal.equals(val2)) {
						return 1;
					} else {
						int int1 = Integer.parseInt(val1);
						int int2 = Integer.parseInt(val2);
						return Integer.compare(int1, int2);
					}						
				});*/
				if("EXCEL".equals(pageVO.getPageType())) return memberList;
				
				int currentPageNo = pageVO.getCurrentPageNo();
				int recordCountPerPage = pageVO.getRecordCountPerPage();
				int startIdx = (currentPageNo - 1) * recordCountPerPage;
				int endIdx = currentPageNo * recordCountPerPage > memberList.size() ? memberList.size() : currentPageNo * recordCountPerPage;
				List<HashMap<String, Object>> subList = memberList.subList(startIdx, endIdx);
				pageVO.setTotalRecordCount(memberList.size());
				return subList;
			}
		}
    			
    	
        return memberList;
	}

	@Override
	public HashMap<String, Object> selectInstrctrOfflectExcelDownload(PageInfoVO pageVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        pageVO.setPageType("EXCEL");
        List<HashMap<String, Object>> rsTp = selectInstrctrOfflectList(pageVO);
		for(HashMap<String, Object> member : rsTp) {
			try {
		        if (member.get("USER_BIRTH_YMD") != null && !"".equals(String.valueOf(member.get("USER_BIRTH_YMD")))) {
	            	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_BIRTH_YMD").toString(),"UTF-8");
	            	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	            	member.put("USER_BIRTH_YMD", formattedDate);
		        }
		        if (member.get("USER_EMAIL") != null && !"".equals(String.valueOf(member.get("USER_EMAIL")))) {
		        	String userEmail = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_EMAIL").toString(),"UTF-8");
		        	member.put("USER_EMAIL", userEmail);
		        }
		        if (member.get("USER_HP_NO") != null && !"".equals(String.valueOf(member.get("USER_HP_NO")))) {
		        	String userHpNo = agt.ScpDecB64(iniFilePath, "KEY1",member.get("USER_HP_NO").toString(),"UTF-8");
		        	member.put("USER_HP_NO", TextUtil.formatTel(userHpNo));
		        }  
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}  
			
		}
        
        paramMap.put("rsList",rsTp);
        fileName = pageVO.getExcelFileNm();
        templateFile = pageVO.getExcelPageNm();
        
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
	}

	@Override
	public void insertInstrctrStatus(MngrInstrctrMngrVO param) throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.INSERT.equals(procType)) {
            egovNctsInstrctrMngrMapper.insertInstrctrStatus(param);
        }
        if(ProcType.DELETE.equals(procType)) {
        	egovNctsInstrctrMngrMapper.deleteInstrctrStatus(param);
        }
	}

	@Override
	public List<HashMap<String, Object>> selectInstrctrStatusList(PageInfoVO pageVO) throws Exception {
		if(null != pageVO.getPageType() && !"".equals(pageVO.getPageType())) {
			int cnt = egovNctsInstrctrMngrMapper.selectInstrctrStatusListTotCnt(pageVO);
			pageVO.setTotalRecordCount(cnt);
		}
		List<HashMap<String, Object>> list = egovNctsInstrctrMngrMapper.selectInstrctrStatusList(pageVO); 
		return list;
	}
}
