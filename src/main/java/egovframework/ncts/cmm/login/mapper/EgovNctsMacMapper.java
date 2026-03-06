package egovframework.ncts.cmm.login.mapper;

import java.util.HashMap;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMacMapper {

	String selectMacServerAt() throws Exception;
	void updateMacServerAt(String macServerAt) throws Exception;
	
	String selectMacServerPortAt(HashMap<String, Object> param) throws Exception;
	void updateMacServerPortAt(HashMap<String, Object> param) throws Exception;

}
