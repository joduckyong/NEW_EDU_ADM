package egovframework.ncts.mngr.cmptMngr.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.cmptMngr.vo.MngrCmptReqstVO;

public interface EgovNctsCmptReqstService {
    List<HashMap<String, Object>> selectCmptReqstList(PageInfoVO pageVO)throws Exception;
    HashMap<String, Object> selectCmptReqstDetail(MngrCmptReqstVO param)throws Exception;
    void mngrProgressCmptReqst(MngrCmptReqstVO param)throws Exception ;
    void updateReflctYn(MngrCmptReqstVO param)throws Exception;
    void mngrCmptAnswer(HttpServletRequest request, MngrCmptReqstVO param)throws Exception;
    void mngrCmptConfirmAt(MngrCmptReqstVO param)throws Exception;
}
