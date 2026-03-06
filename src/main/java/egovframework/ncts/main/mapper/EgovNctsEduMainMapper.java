package egovframework.ncts.main.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsEduMainMapper {
	List<HashMap<String, Object>> selectNoticeList() throws Exception;
	HashMap<String, Object> selectHomeStatusUser() throws Exception;
	HashMap<String, Object> selectVisitUser() throws Exception;
	HashMap<String, Object> selectOneOnOne(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectEdu(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectApplicant(HashMap<String, Object> parameters) throws Exception;
	HashMap<String, Object> selectApplicantGroupBy(HashMap<String, Object> parameters) throws Exception;
	List<HashMap<String, Object>> eduVisitUserDownload(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> selectInstrctrUser() throws Exception;
}
