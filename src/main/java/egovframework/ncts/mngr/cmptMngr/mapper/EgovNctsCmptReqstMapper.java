package egovframework.ncts.mngr.cmptMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.cmptMngr.vo.MngrCmptReqstVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsCmptReqstMapper {
	List<HashMap<String, Object>> selectCmptReqstList(PageInfoVO pageVO)throws Exception;
    int selecCmptReqstTotCnt(PageInfoVO pageVO)throws Exception;
    HashMap<String, Object> selectCmptReqstDetail(MngrCmptReqstVO param)throws Exception;
    void insertCmptReqst(MngrCmptReqstVO param)throws Exception;
    void updateCmptReqst(MngrCmptReqstVO param)throws Exception;
    void deleteCmptReqst(MngrCmptReqstVO param)throws Exception;
    void updateReflctYn(MngrCmptReqstVO param)throws Exception;
    void mngrCmptAnswer(MngrCmptReqstVO param)throws Exception;
    void mngrCmptConfirmAt(MngrCmptReqstVO param)throws Exception;
}
