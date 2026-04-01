package egovframework.ncts.mngr.common.service.impl;

import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.nbp.ncp.nes.model.EmailListResponseEmailStatus;
import com.nbp.ncp.nes.model.EmailSendRequest;
import com.nbp.ncp.nes.model.EmailSendRequestRecipients;
import com.nbp.ncp.nes.model.EmailSendResponse;
import com.nbp.ncp.nes.model.NesDateTime;

import egovframework.com.AESCrypt;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.ncts.mngr.common.mapper.EgovNctsMngrCommonMapper;
import egovframework.ncts.mngr.common.service.EgovNctsMngrCommonService;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;


@Service
public class EgovNctsMngrCommonImpl implements EgovNctsMngrCommonService {

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrCommonImpl.class);
	final static  String FILE_SEPARATOR = System.getProperty("file.separator");
//	public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("com"));
	public static final String RELATIVE_PATH_PREFIX;

	static {
	    // 1. getResource("") 단 1회 호출, null 검증
	    URL resource = EgovProperties.class.getResource("");
	    if (resource == null) {
	        throw new IllegalStateException(
	            "[EgovProperties] 클래스 리소스 경로를 확인할 수 없습니다. " +
	            "클래스 로더 환경을 점검하세요.");
	    }

	    String path = resource.getPath();

	    // 2. "com" 세그먼트 존재 여부 검증 → lastIndexOf가 -1이면 substring 오류 방지
	    int comIdx = path.lastIndexOf("com");
	    if (comIdx < 0) {
	        throw new IllegalStateException(
	            "[EgovProperties] 경로에서 'com' 세그먼트를 찾을 수 없습니다. " +
	            "패키지 구조를 확인하세요. 경로: " + path);
	    }

	    RELATIVE_PATH_PREFIX = path.substring(0, comIdx);
	}		
	public static final String CREDENTIALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "egovProps" + FILE_SEPARATOR + "credentials.properties";
	public static final String X_NCP_LANG = "ko-KR";
	
	@Autowired
	private EgovNctsMngrCommonMapper egovNctsMngrCommonMapper;
	
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
    
    @Override
    public List<HashMap<String, Object>> selectLectureList(MngrCommonVO param)throws Exception{
        List<HashMap<String, Object>> list = null;
        list = egovNctsMngrCommonMapper.selectLectureList(param);
        return list;
    }
    
    @Override
    public ApiResponse<EmailSendResponse> mailPosts(int templateSid, List<EmailSendRequestRecipients> esrrList, List<String> fileIdList) throws Exception {
		V1Api apiInstance = getApiInstane();
		
		EmailSendRequest requestBody = new EmailSendRequest();
		requestBody.setRecipients(esrrList);
		requestBody.setTemplateSid(templateSid); 
		requestBody.setConfirmAndSend(false); 
		if(!(null == fileIdList || fileIdList.isEmpty())) requestBody.attachFileIds(fileIdList); 
		return apiInstance.mailsPost(requestBody, X_NCP_LANG);
    }
    

    @Override
    public void getMailList(MngrCommonVO param) throws Exception {
		String requestId = String.valueOf(param.getRequestId());
		String requestDateTime = null;
		String sendDateTime = null;
		String code = null;
		
		try{
			V1Api apiInstance = getApiInstane();
			String nullStr = null;
			List<String> nullList = null;
			Integer nullInt = null;
			
			ApiResponse<EmailListResponse> result = apiInstance.mailsRequestsRequestIdMailsGet(requestId, X_NCP_LANG, nullStr, nullInt, nullStr, nullList, nullInt, nullList, nullStr);
			NesDateTime requestDate = result.getBody().getContent().get(0).getRequestDate();
			NesDateTime sendDate = result.getBody().getContent().get(0).getSendDate();
			EmailListResponseEmailStatus emailStatus = result.getBody().getContent().get(0).getEmailStatus();
			
			if(null != requestDate) requestDate.getFormattedDateTime();
			if(null != sendDate) sendDateTime = sendDate.getFormattedDateTime();
			if(null != emailStatus) code = emailStatus.getCode();
			
		    param.setRequestId(requestId);
		    param.setSendStatus(code);
		    param.setRequestDate(requestDateTime);
		    param.setSendDate(sendDateTime);
		    egovNctsMngrCommonMapper.mngrMailListProc(param);
		    
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
   }
   
   @Override
   public void selectMailList() throws Exception {
	   List<HashMap<String, Object>> rslist = egovNctsMngrCommonMapper.selectMngrMailList();
	
	   for(HashMap<String, Object> rs: rslist) {
		   MngrCommonVO param = new MngrCommonVO();
		   param.setRequestId(String.valueOf(rs.get("REQUEST_ID")));
		   param.setCateGubun(String.valueOf(rs.get("CATE_GUBUN")));
		   param.setUniqueNo(String.valueOf(rs.get("UNIQUE_NO")));
		   getMailList(param);
	   }
   }   
   
   @Override
   public void packageCertificateProgress(MngrCommonVO param) throws Exception {
	   	List<HashMap<String, Object>> certificate = egovNctsMngrCommonMapper.selectPackageCertificate(param);
	   	if(null != certificate && certificate.size() > 0) {
			for(HashMap<String, Object> cert : certificate) {
				param.setPackageNo(cert.get("PACKAGE_NO").toString());
				HashMap<String, Object> isue = egovNctsMngrCommonMapper.selectPackageIsue(param);
				
				if(null != isue) {
					param.setCourses(String.valueOf(isue.get("COURSES")));
					param.setEdcIssueNo(String.valueOf(isue.get("EDC_ISSUE_NO")));
					param.setIssueDt(String.valueOf(isue.get("ISSUE_DT")));
					
					egovNctsMngrCommonMapper.insertPackageCertificate(param);
				}
			}
		}		
	}

	@Override
	public HashMap<String, Object> selectMemberCoreDetail(MngrCommonVO param) throws Exception {
		return egovNctsMngrCommonMapper.selectMemberCoreDetail(param);
	}

	@Override
	public void bbsPwProc(MngrCommonVO param) throws Exception {
		if(!StringUtils.isBlank(param.getBbsPw())) param.setBbsPw(AESCrypt.encrypt(param.getBbsPw()));
		
		if(!StringUtils.isBlank(param.getPwSeq())) egovNctsMngrCommonMapper.updateBbsPw(param);
		else if(!StringUtils.isBlank(param.getBbsPw())) egovNctsMngrCommonMapper.insertBbsPw(param);
	}   
}
