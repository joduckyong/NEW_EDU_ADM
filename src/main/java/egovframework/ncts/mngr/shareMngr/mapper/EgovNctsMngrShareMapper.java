package egovframework.ncts.mngr.shareMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.shareMngr.vo.MngrShareVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrShareMapper {
	
	List<HashMap<String, Object>> selectShareList(PageInfoVO pageVO)throws Exception;
	
	int selectShareTotCnt(PageInfoVO pageVO)throws Exception;
	
    HashMap<String, Object> selectShareListDetail(MngrShareVO param)throws Exception;   
    
    void insertShareList(MngrShareVO param)throws Exception;
    
    void deleteShareList(MngrShareVO param)throws Exception;
    
    void updateShareList(MngrShareVO param)throws Exception;   
    
    //List<HashMap<String, Object>> selectCommonExcel(PageInfoVO pageVO) throws Exception;
   
}
