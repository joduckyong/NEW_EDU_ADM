package egovframework.com.mapper;

import egovframework.ncts.cmm.sys.ipauth.vo.ipAuthVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CommonIpChkMapper {
	int selectIpChk(ipAuthVO vo) throws Exception;
	int selectIpChk2(ipAuthVO vo) throws Exception;
}
