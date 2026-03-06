package egovframework.ncts.mngr.userMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrDeleteCnfirmMemberMapper {
    List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberList(PageInfoVO pageVO) throws Exception;

    HashMap<String, Object> selectMngrDeleteCnfirmMemberDetail(MngrMemberVO param) throws Exception;

    List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeDetail(MngrMemberVO param) throws Exception;

    List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeVideoDetail(MngrMemberVO param) throws Exception;
    
    int selectMngrDeleteCnfirmMemberCnt(PageInfoVO pageVO) throws Exception;
    
    void deleteMngrDeleteCnfirmMember(MngrMemberVO param) throws Exception;


}
