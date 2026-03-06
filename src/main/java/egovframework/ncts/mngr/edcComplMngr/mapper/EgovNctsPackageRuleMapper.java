package egovframework.ncts.mngr.edcComplMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.edcComplMngr.vo.MngrPackageRuleVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsPackageRuleMapper {
    int selectPackageRuleListTotCnt(PageInfoVO pageVO)throws Exception;
    List<HashMap<String, Object>> selectPackageRuleList(PageInfoVO pageVO)throws Exception;
    HashMap<String, Object> selectPackageRuleDetail(MngrPackageRuleVO param)throws Exception;
    void insertPackageRule(MngrPackageRuleVO param)throws Exception;
    void updatePackageRule(MngrPackageRuleVO param)throws Exception;
	void deletePackageRule(MngrPackageRuleVO param)throws Exception;
}
