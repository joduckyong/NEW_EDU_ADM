package egovframework.ncts.mngr.eduReqstMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.eduReqstMngr.vo.MngrEduVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrEduIrregularMapper {
	List<HashMap<String, Object>> selectNfdrmPlanList(PageInfoVO pageVO) throws Exception;

    HashMap<String, Object> selectNfdrmPlanDetail(MngrEduVO param)throws Exception;

    void updateNfdrmPlan(MngrEduVO param)throws Exception;
    
    void deleteNfdrmPlan(MngrEduVO param)throws Exception;

	void insertNfdrmPlan(MngrEduVO param)throws Exception;

	List<HashMap<String, Object>> nfdrmPlanExcelDownload(PageInfoVO pageVO) throws Exception;

	int selecNfdrmPlanCnt(PageInfoVO pageVO)throws Exception;

}
