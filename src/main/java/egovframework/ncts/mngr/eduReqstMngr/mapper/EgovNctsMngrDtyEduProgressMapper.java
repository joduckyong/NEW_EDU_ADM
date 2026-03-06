package egovframework.ncts.mngr.eduReqstMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrDtyEduProgressMapper {
	
	HashMap<String, Object> selectMngrDtyEduProgressDetail(MngrDtyEduProgressVO vo) throws Exception;
	List<HashMap<String, Object>> selectMngrDtyEduProgressList(PageInfoVO searchVO) throws Exception;
	int selectMngrDtyEduProgressListTotCnt(PageInfoVO searchVO) throws Exception;

    void updateMngrDtyEduApplicant(MngrDtyEduProgressVO param) throws Exception;

    List<HashMap<String, Object>> selectMngrDtyEduApplicantList(MngrDtyEduProgressVO param) throws Exception;
    HashMap<String, Object> selectMngrDtyEduApplicantDetail(MngrDtyEduProgressVO param) throws Exception;
    
	void isueAtProgress(MngrDtyEduProgressVO param) throws Exception;
    void insertComplProgress(MngrDtyEduProgressVO param) throws Exception;
	int getEdcIsueCount(MngrDtyEduProgressVO vo) throws Exception;
	int selectCertificate(MngrDtyEduProgressVO vo) throws Exception;
	void insertCertificate(MngrDtyEduProgressVO vo) throws Exception;

	int onlectComplCount(MngrDtyEduProgressVO vo) throws Exception;
	int getOnlectCount(MngrDtyEduProgressVO vo) throws Exception;
	
	List<HashMap<String, Object>> getCertCd(MngrDtyEduProgressVO vo) throws Exception;
	List<HashMap<String, Object>> getRuleList(MngrDtyEduProgressVO param)throws Exception;
	void updateUserCert(MngrDtyEduProgressVO vo)throws Exception;

	List<HashMap<String, Object>> selectPackageDetailCodeList(MngrDtyEduProgressVO param)throws Exception;
	
	List<HashMap<String, Object>> complAutoCheck(MngrDtyEduProgressVO param)throws Exception;

}
