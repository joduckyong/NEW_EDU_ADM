package egovframework.ncts.mngr.instrctrMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.instrctrMngr.vo.MngrInstrctrSttusVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsInstrctrSttusMapper {
	int selectInstrctrSttusTotCnt(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectInstrctrSttusList(PageInfoVO pageVO) throws Exception;
    HashMap<String, Object> selectInstrctrSttusDetail(MngrInstrctrSttusVO param) throws Exception;
    List<HashMap<String, Object>> selectInstrctrSttusExcelDownload(PageInfoVO pageVO) throws Exception;
	List<HashMap<String, Object>> selectInstrctrDetailList(PageInfoVO pageVO) throws Exception;

}
