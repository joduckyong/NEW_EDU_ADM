package egovframework.ncts.mngr.edcComplMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrEduPackageVO;

public interface EgovNctsMngrEduPackageService {
    List<HashMap<String, Object>> selectMngrEduPackageInfoList(PageInfoVO pageVO) throws Exception;
    HashMap<String, Object> selectMngrEduPackageDetail(MngrEduPackageVO param) throws Exception;
	void mngrEduPackageProc(MngrEduPackageVO param) throws Exception;
	void deleteMngrEduPackageInfo(MngrEduPackageVO param) throws Exception;
	List<HashMap<String, Object>> selectMngrEduPackageDetailCodeList(MngrEduPackageVO param) throws Exception;
}
