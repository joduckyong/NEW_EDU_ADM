package egovframework.ncts.mngr.edcOperMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrOperStatMapper {
	List<HashMap<String, Object>> selectYearEdu(PageInfoVO pageVO) throws Exception;
	HashMap<String, Object> selectYearEduResult(PageInfoVO pageVO) throws Exception;
	void insertDateTable() throws Exception;
}
