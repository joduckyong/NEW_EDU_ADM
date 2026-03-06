package egovframework.ncts.main.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;


public interface EgovNctsEduMainService {
	List<HashMap<String, Object>> selectNoticeList() throws Exception;
	HashMap<String, Object> selectHomeStatusUser() throws Exception;
	HashMap<String, Object> selectVisitUser() throws Exception;
	HashMap<String, Object> selectOneOnOne(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectEdu(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectApplicant(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectApplicantGroupBy(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> eduVisitUserDownload(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> selectInstrctrUser() throws Exception;
}
