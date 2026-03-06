package egovframework.ncts.mngr.common.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.nbp.ncp.nes.ApiResponse;
import com.nbp.ncp.nes.model.EmailSendRequestRecipients;
import com.nbp.ncp.nes.model.EmailSendResponse;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;


public interface EgovNctsMngrCommonService {
    List<HashMap<String, Object>> selectLectureList(MngrCommonVO pageVO)throws Exception;
    ApiResponse<EmailSendResponse> mailPosts(int templateSid, List<EmailSendRequestRecipients> esrrList, List<String> fileIdList) throws Exception;
    void getMailList(MngrCommonVO param) throws Exception;
    void selectMailList() throws Exception;
    
    void packageCertificateProgress(MngrCommonVO param) throws Exception;
    HashMap<String, Object> selectMemberCoreDetail(MngrCommonVO param) throws Exception;
    
    void bbsPwProc(MngrCommonVO param) throws Exception;
}
