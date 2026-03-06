package egovframework.ncts.mngr.edcComplMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEduPackageVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrEduPackageMapper {
    int selectMngrEduPackageInfoListTotCnt(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectMngrEduPackageInfoList(PageInfoVO pageVO) throws Exception;
    HashMap<String, Object> selectMngrEduPackageDetail(MngrEduPackageVO param) throws Exception;
    List<HashMap<String, Object>> selectMngrEduPackageDetailCodeList(MngrEduPackageVO param) throws Exception;
    void insertMngrEduPackageInfo(MngrEduPackageVO param) throws Exception;
    void updateMngrEduPackageInfo(MngrEduPackageVO param) throws Exception;
    void mngrEduPackageDetailCodeProc(MngrEduPackageVO param) throws Exception;
	void deleteMngrEduPackageInfo(MngrEduPackageVO param) throws Exception;
	void deleteMngrEduPackageDetailCode(MngrEduPackageVO param) throws Exception;
}
