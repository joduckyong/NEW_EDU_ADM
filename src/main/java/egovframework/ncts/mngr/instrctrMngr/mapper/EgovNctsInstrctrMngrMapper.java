package egovframework.ncts.mngr.instrctrMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrMngrVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsInstrctrMngrMapper {
    List<HashMap<String, Object>> selectInstrctrMngrList(PageInfoVO pageVO) throws Exception;

    HashMap<String, Object> selectInstrctrMngrDetail(MngrInstrctrMngrVO param) throws Exception;

    int selectInstrctrMngrCnt(PageInfoVO pageVO)throws Exception;

    void mngrUpdateProc(MngrInstrctrMngrVO param)throws Exception;

    List<HashMap<String, Object>> selectCommonExcel(PageInfoVO pageVO)throws Exception;
    
    int selectInstrctrOfflectListTotCnt(PageInfoVO pageVO) throws Exception;
    List<HashMap<String, Object>> selectInstrctrOfflectList(PageInfoVO pageVO) throws Exception;
    
	int selectInstrctrStatusListTotCnt(PageInfoVO pageVO)throws Exception;
	List<HashMap<String, Object>> selectInstrctrStatusList(PageInfoVO pageVO) throws Exception;
	void insertInstrctrStatus(MngrInstrctrMngrVO param) throws Exception;

	List<HashMap<String, Object>> selectInstrctrMaxDtList(PageInfoVO pVO) throws Exception;
	List<HashMap<String, Object>> selectInstrctrActDtList(PageInfoVO pVO) throws Exception;
	HashMap<String, Object> selectInstrctrActDtDetail(PageInfoVO pVO) throws Exception;

}
