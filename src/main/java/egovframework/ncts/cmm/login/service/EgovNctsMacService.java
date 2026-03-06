package egovframework.ncts.cmm.login.service;

import java.util.HashMap;

public interface EgovNctsMacService {

	String selectMacServerAt() throws Exception;
	void updateMacServerAt(String macServerAt) throws Exception;
	
	String selectMacServerPortAt(HashMap<String, Object> param) throws Exception;
	void updateMacServerPortAt(HashMap<String, Object> param) throws Exception;
}
