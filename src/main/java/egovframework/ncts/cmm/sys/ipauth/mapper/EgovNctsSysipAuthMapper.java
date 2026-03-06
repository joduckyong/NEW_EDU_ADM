package egovframework.ncts.cmm.sys.ipauth.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthGrpVO;
import egovframework.ncts.cmm.sys.auth.vo.AuthVO;
import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsSysipAuthMapper {
	void insertipAuth(ipAuthVO vo) throws Exception;
	int updateipAuth(ipAuthVO vo) throws Exception;
	void authipDelete(ipAuthVO vo) throws Exception;	
	HashMap<String, Object> selectipAuthDetail(ipAuthVO vo) throws Exception;
	List<HashMap<String, Object>> selectipAuthList(PageInfoVO searchVO) throws Exception;
	int selectipAuthListTotCnt(PageInfoVO searchVO) throws Exception;
	int selectIpChk(ipAuthVO vo) throws Exception;
	int selectIpChk2(ipAuthVO vo) throws Exception;	
	int ipChkYtoN(ipAuthVO vo) throws Exception;
	int ipChkNtoY(ipAuthVO vo) throws Exception;
	String useAble() throws Exception;
}