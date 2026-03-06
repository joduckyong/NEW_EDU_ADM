package egovframework.ncts.mngr.edcComplMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreOffVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsLctreOffMapper {
    int selecLctreCnt(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception;
    void lctreInsertProc(MngrLctreOffVO param)throws Exception;
    String selectSeq(MngrLctreOffVO param)throws Exception;
    HashMap<String, Object> selectLctreDetail(MngrLctreOffVO param)throws Exception;
    void delLctre(MngrLctreOffVO param)throws Exception;
    void lctreUpdateProc(MngrLctreOffVO param)throws Exception;
    void delActive(MngrLctreOffVO param)throws Exception;
	void insertUserCert(MngrLctreOffVO param) throws Exception;
    int selectCertCd(MngrLctreOffVO param) throws Exception;
    void userUpdateCert(MngrLctreOffVO param) throws Exception;
    void delCert(MngrLctreOffVO param) throws Exception;
    List<HashMap<String, Object>> selectLctreExcelList(PageInfoVO pageVO) throws Exception;
    
    void dtyEduApplicantIsueUpdate(MngrLctreOffVO param) throws Exception;
    void eduIsueUpdate(MngrLctreOffVO param) throws Exception;
    void eduGeneralEduUpdate(MngrLctreOffVO param) throws Exception;
    void eduManageUpdate(MngrLctreOffVO param) throws Exception;
    void eduPackageDetailCodeUpdate(MngrLctreOffVO param) throws Exception;
    void instrctrAsignUpdate(MngrLctreOffVO param) throws Exception;
    void tmpInstrctrAsignUpdate(MngrLctreOffVO param) throws Exception;
	void instrctrOfflectUpdate(MngrLctreOffVO param) throws Exception;
	void lectureOnlectUpdate(MngrLctreOffVO param) throws Exception;
	void webeduDtyResultUpdate(MngrLctreOffVO param) throws Exception;
	void videoStopPointUpdate(MngrLctreOffVO param) throws Exception;
	
	List<HashMap<String, Object>> selectLectureOnlectList(MngrLctreOffVO param) throws Exception;
	HashMap<String, Object> selectLectureOnlectDetail(MngrLctreOffVO param) throws Exception;
	void insertTempLectureOnlect(MngrLctreOffVO param) throws Exception;
	void updateTempLectureOnlect(MngrLctreOffVO param) throws Exception;
	void deleteTempLectureOnlect(MngrLctreOffVO param) throws Exception;
	void insertLectureOnlect(MngrLctreOffVO param) throws Exception;
	void updateLectureOnlect(MngrLctreOffVO param) throws Exception;
	void deleteLectureOnlect(MngrLctreOffVO param) throws Exception;
	void insertLectureOnlectTempSeq(MngrLctreOffVO vo) throws Exception;
	void updateLectureSn(MngrLctreOffVO param) throws Exception;
	void updateTempLectureSn(MngrLctreOffVO param) throws Exception;
}
