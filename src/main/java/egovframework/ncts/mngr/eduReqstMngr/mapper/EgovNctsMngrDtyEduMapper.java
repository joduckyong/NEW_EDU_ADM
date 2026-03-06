package egovframework.ncts.mngr.eduReqstMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduApplicantVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrDtyEduMapper {
	void insertMngrDtyEdu(MngrDtyEduVO vo) throws Exception;

	int updateMngrDtyEdu(MngrDtyEduVO vo) throws Exception;
	
	void insertMngrDtyEduApplicant(MngrDtyEduApplicantVO vo) throws Exception;

	int updateMngrDtyEduApplicant(MngrDtyEduApplicantVO vo) throws Exception;

	void deleteMngrDtyEdu(MngrDtyEduVO vo) throws Exception;
	
	HashMap<String, Object> selectMngrDtyEduDetail(MngrDtyEduVO vo) throws Exception;

	List<HashMap<String, Object>> selectMngrDtyEduList(PageInfoVO searchVO) throws Exception;

	int selectMngrDtyEduListTotCnt(PageInfoVO searchVO) throws Exception;
	
	List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduApplicantVO param) throws Exception;
	
	List<HashMap<String, Object>> selectMngrDtyEduApplicantListExcel(PageInfoVO searchVO) throws Exception;

	List<HashMap<String, Object>> selectDtyEduList() throws Exception;

	int selectMngrDtyEduApplicantListTotCnt(MngrDtyEduApplicantVO param) throws Exception;
	
	List<HashMap<String, Object>> mngrDtyEduApplicantDownload(MngrDtyEduApplicantVO param) throws Exception;

	int selectDtyInstrctrReportCnt(MngrDtyEduVO vo) throws Exception;

	void updateDtyInstrctrOthbcYnProcess(MngrDtyEduVO param) throws Exception;
}
