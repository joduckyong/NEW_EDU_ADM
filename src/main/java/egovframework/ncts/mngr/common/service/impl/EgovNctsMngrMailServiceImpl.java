package egovframework.ncts.mngr.common.service.impl;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.nbp.ncp.nes.ApiClient;
import com.nbp.ncp.nes.ApiResponse;
import com.nbp.ncp.nes.api.V1Api;
import com.nbp.ncp.nes.auth.PropertiesFileCredentialsProvider;
import com.nbp.ncp.nes.exception.ApiException;
import com.nbp.ncp.nes.exception.SdkException;
import com.nbp.ncp.nes.marshaller.FormMarshaller;
import com.nbp.ncp.nes.marshaller.JsonMarshaller;
import com.nbp.ncp.nes.marshaller.XmlMarshaller;
import com.nbp.ncp.nes.model.EmailListResponse;
import com.nbp.ncp.nes.model.EmailListResponseContent;
import com.nbp.ncp.nes.model.EmailResponse;
import com.nbp.ncp.nes.model.EmailSendRequest;
import com.nbp.ncp.nes.model.EmailSendRequestRecipients;
import com.nbp.ncp.nes.model.EmailSendResponse;
import com.nbp.ncp.nes.model.FileUploadResponse;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.file.mapper.FileMngeMapper;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.common.mapper.EgovNctsMngrMailMapper;
import egovframework.ncts.mngr.common.service.EgovNctsMngrMailService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.common.vo.MngrMailVO;


@Service
public class EgovNctsMngrMailServiceImpl implements EgovNctsMngrMailService {

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrMailServiceImpl.class);
	final static  String FILE_SEPARATOR = System.getProperty("file.separator");
	public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("com"));
	public static final String CREDENTIALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "egovProps" + FILE_SEPARATOR + "credentials.properties";
	public static final String X_NCP_LANG = "ko-KR";
	
	@Autowired
	private EgovNctsMngrMailMapper egovNctsMngrMailMapper;
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	public V1Api getApiInstane() throws Exception {
		ApiClient apiClient = new ApiClient.ApiClientBuilder()
				.addMarshaller(JsonMarshaller.getInstance())
				.addMarshaller(XmlMarshaller.getInstance())
				.addMarshaller(FormMarshaller.getInstance())
				.setCredentials(new PropertiesFileCredentialsProvider(CREDENTIALS_PROPERTIES_FILE).getCredentials()) 
				.setLogging(true)
				.build();
		
		V1Api apiInstance = new V1Api(apiClient);
		return apiInstance;
	}
    
    private ApiResponse<EmailSendResponse> mailPosts(MngrMailVO mailVo, List<EmailSendRequestRecipients> esrrList, PageInfoVO pageVO, List<String> fileIdList) throws Exception {
		V1Api apiInstance = getApiInstane();
		
		EmailSendRequest requestBody = new EmailSendRequest();
		requestBody.setRecipients(esrrList);
		if(null != mailVo.getTemplateSid() && !"".equals(mailVo.getTemplateSid())) requestBody.setTemplateSid(Integer.parseInt(mailVo.getTemplateSid()));
		else {
			requestBody.setSenderAddress(mailVo.getMailSenderAddress());
			requestBody.setSenderName(mailVo.getMailSenderName());
			requestBody.setTitle(mailVo.getMailTitle());
			requestBody.setBody(mailVo.getMailBody());
		}
		requestBody.setConfirmAndSend(false); 
		if(null != fileIdList && !fileIdList.isEmpty()) requestBody.attachFileIds(fileIdList); 
		return apiInstance.mailsPost(requestBody, X_NCP_LANG);
    }
    
    @Override
    public void mngrSendEmail(MngrMailVO mailVo, PageInfoVO pageVO) throws Exception {
    	List<EmailSendRequestRecipients> esrrList = emailSettings(mailVo, pageVO); 
    	List<String> fileList = fileSettings(mailVo, pageVO); 
    	
    	ApiResponse<EmailSendResponse> result = mailPosts(mailVo, esrrList, pageVO, fileList); 
		String requestId = result.getBody().getRequestId();
		int senderCnt = result.getBody().getCount();
		mailVo.setRequestId(requestId);
		mailVo.setMailSenderCnt(String.valueOf(senderCnt));
		egovNctsMngrMailMapper.insertMailRequest(mailVo); 
		
		Integer page = 0;
		Integer size = 10; 
		int totalPage = (int) Math.ceil((double) senderCnt / size);
		for(int i=0; i<totalPage; i++) {
			page = i;
			List<HashMap<String, Object>> mailResultList = getMailIdList(requestId, page, size);
			mailListProc(mailResultList, requestId);
		}
    }
	
	private List<EmailSendRequestRecipients> emailSettings(MngrMailVO mailVo, PageInfoVO pageVO) throws Exception {
		if(null == mailVo.getMailSenderAddress() || "".equals(mailVo.getMailSenderAddress().replaceAll(" ", ""))) throw new Exception("00");
		if(null == mailVo.getMailSenderName() || "".equals(mailVo.getMailSenderName().replaceAll(" ", ""))) throw new Exception("00");
		if(null == mailVo.getTemplateSid() || "".equals(mailVo.getTemplateSid())) {
			if(null == mailVo.getMailTitle() || "".equals(mailVo.getMailTitle().replaceAll(" ", ""))) throw new Exception("01");
			else if(null == mailVo.getMailBodySnapshot() || "".equals(mailVo.getMailBodySnapshot())) throw new Exception("01");
		}
		if(null == mailVo.getListAllCheck() || "".equals(mailVo.getListAllCheck())) {
			if(null == mailVo.getUserNoArr() || mailVo.getUserNoArr().length == 0) throw new Exception("02");
		}
		
		List<EmailSendRequestRecipients> esrrList = new ArrayList<EmailSendRequestRecipients>();

		if(null != mailVo.getPageType() && !"".equals(mailVo.getPageType())) {
			if("MEMBER".equals(mailVo.getPageType())) {
				List<HashMap<String, Object>> userList = egovNctsMngrMailMapper.selectMailAllUserList(mailVo);
				
				if(null != userList && !userList.isEmpty()) {
					for(HashMap<String, Object> user : userList) {
						EmailSendRequestRecipients esrr = new EmailSendRequestRecipients();
						esrr.setType("R");
						esrr.setAddress(String.valueOf(user.get("USER_EMAIL")));
						esrr.setName(String.valueOf(user.get("USER_NM")));
						esrrList.add(esrr);
					}
				} else throw new Exception("02");
			}
		}
		return esrrList;		
	}   
	
	private List<String> fileSettings(MngrMailVO mailVo, PageInfoVO pageVO) throws Exception{
		V1Api apiInstance = getApiInstane();
		
		List<String> fileIdList = new ArrayList<>();
		if(null != mailVo.getFileList() && !mailVo.getFileList().isEmpty()) {
			for(File saveFile : mailVo.getFileList()) {
				if(saveFile.isFile()) {
					ApiResponse<FileUploadResponse> fileUpload = apiInstance.filesPost(saveFile, X_NCP_LANG);
					String fileId = fileUpload.getBody().getFiles().get(0).getFileId();
					fileIdList.add(fileId);
				}
			}
		}
		/*List<HashMap<String, Object>> saveFileList = fileMngeMapper.selectFileInfs(mailVo.getAtchFileId());
		List<String> fileIdList = new ArrayList<>();
		if(null != saveFileList && !saveFileList.isEmpty()) {
			for(HashMap<String, Object> saveFile : saveFileList) {
				String filePath = saveFile.get("FILE_STRE_COURS").toString();
				String fileName = saveFile.get("STRE_FILE_NM").toString();
				
				File file = new File(filePath + File.separator + fileName);
				if(file.isFile()) {
					ApiResponse<FileUploadResponse> fileUpload = apiInstance.filesPost(file, X_NCP_LANG);
					//String tempRequestId = fileUpload.getBody().getTempRequestId();
					String fileId = fileUpload.getBody().getFiles().get(0).getFileId();
					fileIdList.add(fileId);
				}
			}
		}*/
		return fileIdList;
	}	
	
	public List<HashMap<String, Object>> getMailIdList2(String requestId) throws Exception {
		List<HashMap<String, Object>> mailResultList = new ArrayList<HashMap<String, Object>>();
		try{
			V1Api apiInstance = getApiInstane();
			ApiResponse<EmailListResponse> rslist = apiInstance.mailsRequestsRequestIdMailsGet(requestId, X_NCP_LANG, null, null, null, null, null, null, null);
			
			HashMap<String, Object> rs = new HashMap<>();
			for(EmailListResponseContent emailContent : rslist.getBody().getContent()) {
				String mailId = emailContent.getMailId();
				rs.put("MAIL_ID", mailId);
				mailResultList.add(rs);
				
				ApiResponse<EmailResponse> result = apiInstance.mailsMailIdGet(mailId, X_NCP_LANG);
				HashMap<String, Object> getMailInfo = new HashMap<String, Object>();
				getMailInfo.put("MAIL_ID", mailId);
				getMailInfo.put("SEND_STATUS", result.getBody().getEmailStatus().getCode());
				getMailInfo.put("REQUEST_DATE", result.getBody().getRequestDate().getFormattedDateTime());
				if(null != result.getBody().getSendDate()) getMailInfo.put("SEND_DATE", result.getBody().getSendDate().getFormattedDateTime());
				getMailInfo.put("ADDRESS", result.getBody().getRecipients().get(0).getAddress());
				getMailInfo.put("NAME", result.getBody().getRecipients().get(0).getName());
				mailResultList.add(getMailInfo);
			}
			
		}catch (ApiException e) {
			LOGGER.debug(e.getMessage());
			int statusCode = e.getHttpStatusCode();
			LOGGER.debug(Integer.toString(statusCode));
			Map<String, List<String>> responseHeaders = e.getHttpHeaders();
			InputStream byteStream = e.getByteStream();
		} catch (SdkException e) {
			LOGGER.debug(e.getMessage());
		} catch(Exception e) {
			LOGGER.debug(e.getMessage());
		}
		return mailResultList;
	}	
	
    public List<HashMap<String, Object>> getMailIdList(String requestId, Integer page, Integer size) throws Exception {
    	List<HashMap<String, Object>> mailResultList = new ArrayList<HashMap<String, Object>>();
		try{
			V1Api apiInstance = getApiInstane();
			ApiResponse<EmailListResponse> rslist = apiInstance.mailsRequestsRequestIdMailsGet(requestId, X_NCP_LANG, null, page, null, null, size, null, null);
			
			for(EmailListResponseContent emailContent : rslist.getBody().getContent()) {
				HashMap<String, Object> rs = new HashMap<>();
				rs.put("MAIL_ID", emailContent.getMailId());
				mailResultList.add(rs);
			}
			
		}catch (ApiException e) {
			LOGGER.debug(e.getMessage());
			int statusCode = e.getHttpStatusCode();
			LOGGER.debug(Integer.toString(statusCode));
			Map<String, List<String>> responseHeaders = e.getHttpHeaders();
			InputStream byteStream = e.getByteStream();
		} catch (SdkException e) {
			LOGGER.debug(e.getMessage());
		} catch(Exception e) {
			LOGGER.debug(e.getMessage());
		}
		return mailResultList;
    }	
    
	@Override
	public void updateMailStatusList(MngrMailVO param) throws Exception {
		List<HashMap<String, Object>> updateList = egovNctsMngrMailMapper.selectMngrMailStatusUpdateList();
		mailListProc(updateList, "");
	}
	
	private void mailListProc(List<HashMap<String, Object>> mailResultList, String requestId) throws Exception {
		V1Api apiInstance = getApiInstane();
		
		if(null != mailResultList && !mailResultList.isEmpty()) {
			for(HashMap<String, Object> mailResult : mailResultList) {
				MngrMailVO mngrMailVO = new MngrMailVO(); 
				
				ApiResponse<EmailResponse> result = apiInstance.mailsMailIdGet(mailResult.get("MAIL_ID").toString(), X_NCP_LANG);
				
				mngrMailVO.setMailId(mailResult.get("MAIL_ID").toString());
				if(null != requestId && !"".equals(requestId)) mngrMailVO.setRequestId(requestId);
				else mngrMailVO.setRequestId(mailResult.get("REQUEST_ID").toString());
				mngrMailVO.setSendStatus(result.getBody().getEmailStatus().getCode());
				mngrMailVO.setRequestDate(result.getBody().getRequestDate().getFormattedDateTime());
				if(null != result.getBody().getSendDate()) mngrMailVO.setSendDate(result.getBody().getSendDate().getFormattedDateTime());
				String userNo = egovNctsMngrMailMapper.selectUserEmail(result.getBody().getRecipients().get(0).getAddress());
				mngrMailVO.setUserNo(userNo);
				mngrMailVO.setUserEmail(result.getBody().getRecipients().get(0).getAddress());
				mngrMailVO.setUserNm(result.getBody().getRecipients().get(0).getName());
				egovNctsMngrMailMapper.mailListProc(mngrMailVO);
				
			}
		}
	}    


	@Override
	public HashMap<String, Object> selectLastUserNo() throws Exception {
		return egovNctsMngrMailMapper.selectLastUserNo();
	}

	@Override
	public int selectUserNoCnt() throws Exception {
		return egovNctsMngrMailMapper.selectUserNoCnt();
	}

	@Override
	public List<HashMap<String, Object>> selectMailAllUserList(MngrMailVO param) throws Exception {
		return egovNctsMngrMailMapper.selectMailAllUserList(param);
	}

	@Override
	public List<HashMap<String, Object>> selectMngrMailRequestList(PageInfoVO pageVO) throws Exception {
		int cnt = egovNctsMngrMailMapper.selectMngrMailRequestListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		return egovNctsMngrMailMapper.selectMngrMailRequestList(pageVO);
	}

	@Override
	public List<HashMap<String, Object>> selectMngrMailStatusList(PageInfoVO pageVO) throws Exception {
		int cnt = egovNctsMngrMailMapper.selectMngrMailStatusListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		return egovNctsMngrMailMapper.selectMngrMailStatusList(pageVO);
	}

	@Override
	public HashMap<String, Object> selectMngrMailRequestDetail(MngrMailVO param) throws Exception {
		HashMap<String, Object> rs = egovNctsMngrMailMapper.selectMngrMailRequestDetail(param);
		rs.put("MAIL_BODY", ParamUtils.reverseHtmlTag((String)rs.get("MAIL_BODY")));
		String fileView = FileViewMarkupBuilder.newInstance()
				.atchFileId(StringUtils.defaultIfEmpty((String) rs.get("ATCH_FILE_ID"), ""))
				.wrapMarkup("p")
				.isIcon(true)
				.isSize(true)
				.build()
				.toString();
		rs.put("fileView", fileView);
		return rs;
	}

	@Override
	public List<HashMap<String, Object>> selectMailAllViewUserList(PageInfoVO pageVO) throws Exception {
		int cnt = egovNctsMngrMailMapper.selectMailAllViewUserListTotCnt(pageVO);
		pageVO.setTotalRecordCount(cnt);
		return egovNctsMngrMailMapper.selectMailAllViewUserList(pageVO);
	}

	@Override
	public void updateMailRequest(MngrMailVO mngrMailVO) throws Exception {
		ProcType procType = ProcType.findByProcType(mngrMailVO.getProcType());
		
		if (ProcType.UPDATE.equals(procType)) egovNctsMngrMailMapper.updateMailRequest(mngrMailVO);
		else if (ProcType.DELETE.equals(procType)) egovNctsMngrMailMapper.deleteMailRequest(mngrMailVO);
		else throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		
	}
	
	/*@Override
	public void insertMailTmpKey(PageInfoVO pageVO) throws Exception {
		egovNctsMngrMailMapper.insertMailTmpKey(pageVO);
	}
	

	@Override
	public void mailTargetTmpProc(MngrMailVO mailVo) throws Exception {
		if(null == mailVo.getListAllCheck() || "".equals(mailVo.getListAllCheck())) {
			if(null == mailVo.getUserNoArr() || "".equals(mailVo.getUserNoArr())) throw new Exception("02");
		}
		egovNctsMngrMailMapper.deleteMailTargetTmp(mailVo);
		System.out.println(mailVo.getLastUserNo());
		System.out.println(mailVo.getListAllCheck());
		System.out.println(mailVo.getUserNoArr());
		egovNctsMngrMailMapper.insertMailTargetTmp(mailVo);
	}*/	

}
