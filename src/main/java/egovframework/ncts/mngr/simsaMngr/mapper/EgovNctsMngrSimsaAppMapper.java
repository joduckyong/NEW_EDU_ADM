package egovframework.ncts.mngr.simsaMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.homeMngr.vo.MngrBbsManageVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrSimsaAppMapper {
	
     List<HashMap<String, Object>> selectSimsaAppList(MngrSimsaApplicantVO VO)throws Exception;

	void updateSimsaAppList(MngrSimsaApplicantVO param) throws Exception;

	List<HashMap<String, Object>> selectSimsaAppExcelDownload(MngrSimsaApplicantVO param) throws Exception;

}
