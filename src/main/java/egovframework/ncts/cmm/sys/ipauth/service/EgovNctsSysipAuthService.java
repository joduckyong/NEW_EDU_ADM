package egovframework.ncts.cmm.sys.ipauth.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthGrpVO;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;

public interface EgovNctsSysipAuthService {

	void authipProcess(ipAuthVO param) throws Exception;
	void authipDelete(ipAuthVO param) throws Exception;

	HashMap<String, Object> selectipDetail(ipAuthVO vo) throws Exception;

	List<HashMap<String, Object>> selectipAuthList(PageInfoVO searchVO) throws Exception;
	String useAble() throws Exception;
	int selectIpChk(ipAuthVO vo) throws Exception;
	int selectIpChk2(ipAuthVO vo) throws Exception;
	
	void ipChkYtoN(ipAuthVO param) throws Exception;
	void ipChkNtoY(ipAuthVO param) throws Exception;
}
