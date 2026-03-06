package egovframework.ncts.mngr.edcComplMngr.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrLctreOffVO;

public interface EgovNctsLctreOffService {
    List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception;
    void mngrProgressOffLctre(HttpServletRequest request, MngrLctreOffVO param)throws Exception ;
    HashMap<String, Object> selectLctreDetail(MngrLctreOffVO param)throws Exception;
    void delOffLctre(MngrLctreOffVO param)throws Exception;
    HashMap<String, Object> selectLctreExcelList(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectLectureOnlectList(MngrLctreOffVO param) throws Exception;
	HashMap<String, Object> selectLectureOnlectDetail(MngrLctreOffVO param)throws Exception;
	void lectureOnlectProc(MngrLctreOffVO param)throws Exception ;
}
