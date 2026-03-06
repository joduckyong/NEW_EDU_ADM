package egovframework.com.service;

import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

public interface CommonIpChkService {
	
		int selectIpChk(ipAuthVO vo) throws Exception;
		int selectIpChk2(ipAuthVO vo) throws Exception;
}
