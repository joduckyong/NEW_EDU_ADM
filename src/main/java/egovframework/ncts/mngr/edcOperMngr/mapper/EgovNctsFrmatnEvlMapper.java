package egovframework.ncts.mngr.edcOperMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcOperMngr.vo.MngrFrmatnEvlVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsFrmatnEvlMapper {
    int selecFrmatnEvlCnt(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectFrmatnEvlList(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectFrmatnEvlDetailList(MngrFrmatnEvlVO param)throws Exception;
    HashMap<String, Object> selectFrmatnEvlSeDetail(MngrFrmatnEvlVO param)throws Exception;
    int selectExamSqno(MngrFrmatnEvlVO param)throws Exception;
    void frmatnInsertExamProc(MngrFrmatnEvlVO param)throws Exception;
    void frmatnInsertExamItemProc(MngrFrmatnEvlVO param)throws Exception;
    int selectExamItemNo(MngrFrmatnEvlVO param)throws Exception;
    void delEvl(MngrFrmatnEvlVO param)throws Exception;
    void delEvlItem(MngrFrmatnEvlVO param)throws Exception;
}
