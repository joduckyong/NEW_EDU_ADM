package egovframework.ncts.mngr.userMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.userMngr.mapper.EgovNctsMngrDeleteCnfirmMemberMapper;
import egovframework.ncts.mngr.userMngr.service.EgovNctsMngrDeleteCnfirmMemberService;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

@Service
public class EgovNctsMngrDeleteCnfirmMemberServiceImpl implements EgovNctsMngrDeleteCnfirmMemberService{

    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsMngrDeleteCnfirmMemberServiceImpl.class);
    
    @Autowired
    private EgovNctsMngrDeleteCnfirmMemberMapper egovNctsMngrDeleteCnfirmMemberMapper;
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberList(PageInfoVO pageVO) throws Exception {
        int cnt = egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberList(pageVO);
    }
    
    @Override
    public HashMap<String, Object> selectMngrDeleteCnfirmMemberDetail(MngrMemberVO param) throws Exception {
        HashMap<String, Object> result = egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberDetail(param);
        String fileView = FileViewMarkupBuilder.newInstance()
                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
                .wrapMarkup("p")
                .isIcon(true)
                .isSize(true)
                .build()
                .toString(); 
        
        result.put("fileView", fileView);
        return result;
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeDetail(MngrMemberVO param) throws Exception {
        return egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberSeDetail(param);
    }
    
    @Override
    public List<HashMap<String, Object>> selectMngrDeleteCnfirmMemberSeVideoDetail(MngrMemberVO param) throws Exception {
    	return egovNctsMngrDeleteCnfirmMemberMapper.selectMngrDeleteCnfirmMemberSeVideoDetail(param);
    }

	@Override
	public void deleteMngrDeleteCnfirmMember(MngrMemberVO param) throws Exception {
		egovNctsMngrDeleteCnfirmMemberMapper.deleteMngrDeleteCnfirmMember(param);
	}

   
}
