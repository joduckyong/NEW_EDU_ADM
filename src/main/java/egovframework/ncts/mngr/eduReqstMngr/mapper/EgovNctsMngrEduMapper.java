package egovframework.ncts.mngr.eduReqstMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcTempInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrEduMapper {
	void insertMngrEdu(MngrEduVO vo) throws Exception;

	int updateMngrEdu(MngrEduVO vo) throws Exception;
	
	void insertMngrEduApplicant(MngrEduApplicantVO vo) throws Exception;

	int updateMngrEduApplicant(MngrEduApplicantVO vo) throws Exception;

	void deleteMngrEdu(MngrEduVO vo) throws Exception;
	
	HashMap<String, Object> selectMngrEduDetail(MngrEduVO vo) throws Exception;

	List<HashMap<String, Object>> selectMngrEduList(PageInfoVO searchVO) throws Exception;

	int selectMngrEduListTotCnt(PageInfoVO searchVO) throws Exception;
	
	List<HashMap<String, Object>> selectMngrEduApplicantList(MngrEduApplicantVO param) throws Exception;
	
	List<HashMap<String, Object>> selectMngrEduApplicantListExcel(PageInfoVO searchVO) throws Exception;

	List<HashMap<String, Object>> selectEduList()throws Exception;

	int selectMngrEduApplicantListTotCnt(MngrEduApplicantVO param) throws Exception;
	
	HashMap<String, Object> selectRegEduAplcStatus(MngrEduVO param) throws Exception;
	
	List<HashMap<String, Object>> selectInstrctrOriList(MngrEdcInstrctrVO param) throws Exception;

	List<HashMap<String, Object>> mngrEduApplicantDownload(MngrEduApplicantVO param) throws Exception;

	List<HashMap<String, Object>> selectTempInstrctrList(MngrEdcTempInstrctrVO param) throws Exception;
	
	int selectTempInstrctrListTotCnt(MngrEdcTempInstrctrVO param) throws Exception;
	
	String selectTempInstrctrAsignKey(MngrEdcTempInstrctrVO param) throws Exception;
	
	void insertTempInstrctrAsign(MngrEdcTempInstrctrVO param) throws Exception;
	
	void deleteTempInstrctrAsign(MngrEdcTempInstrctrVO param) throws Exception;
	
	void insertInstrctrAsign(MngrEdcInstrctrVO param) throws Exception;

	int selectRegInstrctrReportCnt(MngrEduVO vo) throws Exception;

	void updateInstrctrOthbcYnProcess(MngrEduVO param) throws Exception;

	void updateInstrctrAsign(MngrEdcInstrctrVO param) throws Exception;

	void updateInstrctrAct(MngrEdcInstrctrVO param) throws Exception;
}
