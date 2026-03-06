package egovframework.ncts.mngr.common.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.common.vo.MngrCommonVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrDtyEduProgressVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrCommonMapper {
    List<HashMap<String, Object>> selectLectureList(MngrCommonVO param)throws Exception;
    void mngrMailListProc(MngrCommonVO param) throws Exception;
	List<HashMap<String, Object>> selectMngrMailList() throws Exception;
	
	List<HashMap<String, Object>> selectPackageCertificate(MngrCommonVO param)throws Exception;
	HashMap<String, Object> selectPackageIsue(MngrCommonVO param) throws Exception;
	void insertPackageCertificate(MngrCommonVO param)throws Exception;
	HashMap<String, Object> selectMemberCoreDetail(MngrCommonVO param)throws Exception;
	String selectBbsPwSeq(MngrCommonVO param) throws Exception;
	void insertBbsPw(MngrCommonVO param)throws Exception;
	void updateBbsPw(MngrCommonVO param)throws Exception;
}
