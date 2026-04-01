package egovframework.ncts.mngr.mlbxMngr.service.impl;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.nbp.ncp.nes.ApiResponse;
import com.nbp.ncp.nes.exception.ApiException;
import com.nbp.ncp.nes.exception.SdkException;
import com.nbp.ncp.nes.model.EmailSendRequestRecipients;
import com.nbp.ncp.nes.model.EmailSendResponse;
import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.ParamUtils;
import egovframework.com.TextUtil;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.mapper.EgovNctsMngrCommonMapper;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.mlbxMngr.mapper.EgovNctsMngrMailBoxMapper;
import egovframework.ncts.mngr.mlbxMngr.service.EgovNctsMngrMailBoxService;
import egovframework.ncts.mngr.mlbxMngr.vo.MngrMailBoxVO;


@Service
public class EgovNctsMngrMailBoxImpl implements EgovNctsMngrMailBoxService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrMailBoxImpl.class);
    private static final int TEMPLATE_SID = 6475; // 개발
    // 	운영 private static final int TEMPLATE_SID = 219; 
    
    @Autowired
    private EgovNctsMngrMailBoxMapper egovNctsMngrMailBoxMapper;
    
    @Autowired
    private EgovNctsMngrCommonService egovNctsMngrCommonService;
    
	
//    String iniFilePath = "/penta/scpdb_agent.ini";
    //String iniFilePath = "C:\\scp\\scpdb_agent.ini";
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
	@Override
	public List<HashMap<String, Object>> selectMngrMailBoxList(PageInfoVO pageVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		
		if (pageVO.getSearchKeyword2() != null && !"".equals(pageVO.getSearchKeyword2())) {
			String searchKeyword2 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword2().replaceAll(" ", ""));
			pageVO.setSearchKeyword2(searchKeyword2);
		}
		if (pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3())) {
			String searchKeyword3 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword3().replaceAll(" ", ""));
			pageVO.setSearchKeyword3(searchKeyword3);
		}
		if (pageVO.getSearchKeyword4() != null && !"".equals(pageVO.getSearchKeyword4())) {
			String searchKeyword4 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword4().replaceAll("-", ""));
			pageVO.setSearchKeyword4(searchKeyword4);
		}   
		int cnt = egovNctsMngrMailBoxMapper.selectMngrMailBoxListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		List<HashMap<String, Object>> rslist = egovNctsMngrMailBoxMapper.selectMngrMailBoxList(pageVO);
	    // 결과값 변환 처리
	    for (HashMap<String, Object> tmp : rslist) {
	    	try {
		        if (tmp.get("TEL_NO") != null && !"".equals(String.valueOf(tmp.get("TEL_NO")))) {
		        	String telNo = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("TEL_NO").toString(),"UTF-8");
		        	tmp.put("TEL_NO", TextUtil.formatTel(telNo));
		        }
	
		        if (tmp.get("USER_EMAIL") != null && !"".equals(String.valueOf(tmp.get("USER_EMAIL")))) {
		        	tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
		        }
		        
		        if (tmp.get("USER_BIRTH") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH")))) {
		        	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH").toString(),"UTF-8");
		        	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
		        	tmp.put("USER_BIRTH", formattedDate);
		        }
	    	}
	    	catch (ScpDbAgentException e) {
	    		LOGGER.info(e.getMessage());
	    	}
	    	catch (Exception e) {
	    		LOGGER.info(e.getMessage());
	    	}  
	    }		
		return rslist;
	}

	@Override
	public HashMap<String, Object> selectMngrMailBoxDetail(MngrMailBoxVO param) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		HashMap<String, Object> rs = egovNctsMngrMailBoxMapper.selectMngrMailBoxDetail(param);

		try {
	        if (rs.get("TEL_NO") != null && !"".equals(String.valueOf(rs.get("TEL_NO")))) {
	        	String telNo = agt.ScpDecB64(iniFilePath, "KEY1",rs.get("TEL_NO").toString(),"UTF-8");
	        	rs.put("TEL_NO", TextUtil.formatTel(telNo));
	        }
	        if (rs.get("USER_EMAIL") != null && !"".equals(String.valueOf(rs.get("USER_EMAIL")))) {
	        	rs.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",rs.get("USER_EMAIL").toString(),"UTF-8"));
	        }
	        if (rs.get("USER_BIRTH") != null && !"".equals(String.valueOf(rs.get("USER_BIRTH")))) {
	        	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",rs.get("USER_BIRTH").toString(),"UTF-8");
	        	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
	        	rs.put("USER_BIRTH", formattedDate);
	        }
    	}
    	catch (ScpDbAgentException e) {
    		LOGGER.info(e.getMessage());
    	}
    	catch (Exception e) {
    		LOGGER.info(e.getMessage());
    	}   
		
		rs.put("CONTENTS", ParamUtils.reverseHtmlTag((String)rs.get("CONTENTS")));
		return rs;
	}

	@Override
	public void updatePostProcess(MngrMailBoxVO param) throws Exception {
		if("contents".equals(param.getPageType())) {
			egovNctsMngrMailBoxMapper.updatePostContents(param);
		} else {
			String postNo[] = param.getPostNo().split(",");
			String postYn[] = param.getPostYn().split(",");
			
			for(int i=0; i<postNo.length; i++) {
				MngrMailBoxVO vo = new MngrMailBoxVO();
				vo.setPostNo(postNo[i]);
				vo.setPostYn(postYn[i]);
				egovNctsMngrMailBoxMapper.updatePostYn(vo);
			}
		}
	}

	@Override
	public HashMap<String, Object> mngrMailBoxDownload(PageInfoVO pageVO) throws Exception {
		ScpDbAgent agt = new ScpDbAgent();
		HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        HashMap<String, Object> re = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
		if (pageVO.getSearchKeyword2() != null && !"".equals(pageVO.getSearchKeyword2())) {
			String searchKeyword2 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword2().replaceAll(" ", ""));
			pageVO.setSearchKeyword2(searchKeyword2);
		}
		if (pageVO.getSearchKeyword3() != null && !"".equals(pageVO.getSearchKeyword3())) {
			String searchKeyword3 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword3().replaceAll(" ", ""));
			pageVO.setSearchKeyword3(searchKeyword3);
		}
		if (pageVO.getSearchKeyword4() != null && !"".equals(pageVO.getSearchKeyword4())) {
			String searchKeyword4 = agt.ScpEncB64(iniFilePath, "KEY1",pageVO.getSearchKeyword4().replaceAll("-", ""));
			pageVO.setSearchKeyword4(searchKeyword4);
		}        
        List<HashMap<String, Object>> rsTp = egovNctsMngrMailBoxMapper.selectMngrMailBoxExcel(pageVO);
	    for (HashMap<String, Object> tmp : rsTp) {
	    	try {
		        if (tmp.get("TEL_NO") != null && !"".equals(String.valueOf(tmp.get("TEL_NO")))) {
		        	String telNo = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("TEL_NO").toString(),"UTF-8");
		        	tmp.put("TEL_NO", TextUtil.formatTel(telNo));
		        }
	
		        if (tmp.get("USER_EMAIL") != null && !"".equals(String.valueOf(tmp.get("USER_EMAIL")))) {
		        	tmp.put("USER_EMAIL", agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_EMAIL").toString(),"UTF-8"));
		        }
		        
		        if (tmp.get("USER_BIRTH") != null && !"".equals(String.valueOf(tmp.get("USER_BIRTH")))) {
		        	String birthday = agt.ScpDecB64(iniFilePath, "KEY1",tmp.get("USER_BIRTH").toString(),"UTF-8");
		        	String formattedDate = birthday.substring(0,4) + "." + birthday.substring(4,6) + "." + birthday.substring(6,8);
		        	tmp.put("USER_BIRTH", formattedDate);
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
	public void mngrMailBoxEmailSend(MngrMailBoxVO param) throws Exception {
		
	    try{
	    	String postNo[] = param.getPostNo().split(",");
			
			for(String postNoStr : postNo) {
				List<EmailSendRequestRecipients> esrrList = new ArrayList<EmailSendRequestRecipients>();
				EmailSendRequestRecipients esrr = new EmailSendRequestRecipients();
				MngrMailBoxVO vo = new MngrMailBoxVO();
				vo.setPostNo(postNoStr);
				HashMap<String, Object> userDetail = egovNctsMngrMailBoxMapper.selectMngrMailBoxDetail(vo); 
				
				esrr.setAddress(String.valueOf(userDetail.get("USER_EMAIL")));
				esrr.setName(String.valueOf(userDetail.get("USER_NAME")));
				esrr.setType("R"); 
				esrrList.add(esrr);
				
				ApiResponse<EmailSendResponse> result = egovNctsMngrCommonService.mailPosts(TEMPLATE_SID, esrrList, null);
				
				updatePostProc(result, vo);
			}
	    	
	    }catch (ApiException e) {
			LOGGER.debug(e.getMessage());
			int statusCode = e.getHttpStatusCode();
			LOGGER.debug(Integer.toString(statusCode));
			Map<String, List<String>> responseHeaders = e.getHttpHeaders();
			InputStream byteStream = e.getByteStream();
			throw new Exception("error");
		} catch (SdkException e) {
			LOGGER.debug(e.getMessage());
			throw new Exception("error");
		} catch(Exception e) {
			LOGGER.debug(e.getMessage());
			throw new Exception("error");
		}
	}
	
	public void updatePostProc(ApiResponse<EmailSendResponse> result, MngrMailBoxVO vo) throws Exception {
		String requestId = result.getBody().getRequestId();
		MngrCommonVO mcVO = new MngrCommonVO();
		mcVO.setRequestId(requestId);
		mcVO.setCateGubun("1");
		mcVO.setUniqueNo(vo.getPostNo());
		egovNctsMngrCommonService.getMailList(mcVO);
		
		vo.setPostYn("E");
		egovNctsMngrMailBoxMapper.updatePostYn(vo);
		
	}
    
}
