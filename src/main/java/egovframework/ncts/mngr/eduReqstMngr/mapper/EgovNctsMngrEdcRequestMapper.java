package egovframework.ncts.mngr.eduReqstMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcInstrctrVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEdcRequestVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduRequstApplicantVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrEdcRequestMapper {

    int selectMngrEdcRequstCnt(PageInfoVO pageVO)throws Exception;

    List<HashMap<String, Object>> selectMngrEdcRequestList(PageInfoVO pageVO)throws Exception;

    HashMap<String, Object> selectMngrEdcReqstDetail(MngrEdcRequestVO param)throws Exception;

    void updateEdcRequset(MngrEdcRequestVO param) throws Exception;
    
    void delEdcRequset(MngrEdcRequestVO param)throws Exception;

    List<HashMap<String, Object>> selectCommonExcel(MngrEdcRequestVO vo)throws Exception;

    List<HashMap<String, Object>> selectMngrEdcInstrctrAsignList(PageInfoVO pageVO) throws Exception;
    
    int selectMngrEdcInstrctrAsignTotCnt(PageInfoVO pageVO) throws Exception;
    
    void instrctrAsignProcess(MngrEdcInstrctrVO param) throws Exception;
    
    int selectMngrEduInstrctrDcsnTotCnt(MngrEdcInstrctrVO param) throws Exception;
    
	List<HashMap<String, Object>> selectMngrEduReqstApplicantList(MngrEdcRequestVO param) throws Exception;
	
	HashMap<String, Object> selectMngrEduReqstApplicantDetail(MngrEdcRequestVO param) throws Exception;

	void insertMngrEduReqstApplicant(MngrEduRequstApplicantVO param) throws Exception;
	
	void updateMngrEduReqstApplicant(MngrEduRequstApplicantVO param) throws Exception;
	
	void deleteMngrEduReqstApplicant(MngrEduRequstApplicantVO param) throws Exception;

	List<HashMap<String, Object>> mngrEdcRequsetApplicantDownload(PageInfoVO pageVO) throws Exception;

	int selectInstrctrReportCnt(MngrEdcRequestVO vo) throws Exception;

    void updateApplAtProcess(MngrEdcRequestVO param)throws Exception;

	List<HashMap<String, Object>> selectIrregEduList()throws Exception;
	
	void updateComplProgress(MngrEdcRequestVO param) throws Exception;
	
	void updateUserCert(MngrEdcRequestVO vo)throws Exception;
	
	int getEdcIsueCount(MngrEdcRequestVO vo) throws Exception;
	
	void insertComplProgress(MngrEdcRequestVO param) throws Exception;
	
	void insertCertificate(MngrEdcRequestVO vo) throws Exception;
	
	int selectCertificate(MngrEdcRequestVO vo) throws Exception;
	
	int onlectComplCount(MngrEdcRequestVO vo) throws Exception;
	
	List<HashMap<String, Object>> getCertCd(MngrEdcRequestVO vo) throws Exception;
	
	List<HashMap<String, Object>> getRuleList(MngrEdcRequestVO param)throws Exception;
	
	void updateIrreApplicntUserNo(MngrEdcRequestVO param)throws Exception;
	
	HashMap<String, Object> selectIrreApplicntUserNo(MngrEdcRequestVO param)throws Exception;

	HashMap<String, Object> selectIrregEduApplcnt(MngrEdcRequestVO param)throws Exception;
	
	int onlectCount(MngrEdcRequestVO param) throws Exception;

	int selectNullUser(MngrEdcRequestVO vo);
	
	
    int selectReqstCenterRecordListTotCnt(PageInfoVO pageVO)throws Exception;

    List<HashMap<String, Object>> selectReqstCenterRecordList(PageInfoVO pageVO)throws Exception;

    void insertReqstCenterRecord(MngrEdcRequestVO param) throws Exception;	
}
