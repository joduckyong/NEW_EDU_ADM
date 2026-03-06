package egovframework.ncts.personalInfo.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsPersonalInfoMapper {

	List<HashMap<String, Object>> personalInfoBatchProcess() throws Exception;
	
}
