package egovframework.ncts.mngr.userMngr.service;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;

public interface EgovNctsMngrMemberService {
    List<HashMap<String, Object>> selectMngrMemberList(PageInfoVO pageVO)throws Exception;

    List<HashMap<String, Object>> selectMngrMemberSeDetail(MngrMemberVO param)throws Exception;

    List<HashMap<String, Object>> selectMngrMemberSeVideoDetail(MngrMemberVO param) throws Exception;
    
    HashMap<String, Object> selectMngrMemberDetail(MngrMemberVO param)throws Exception;
    
    void mngrProc(MngrMemberVO param) throws Exception;

    void delMember(MngrMemberVO param)throws Exception;

    HashMap<String, Object> selectCommonExcel(PageInfoVO pageVO)throws Exception;

    Object getDecryptPw(Object object)throws Exception;

    List<HashMap<String, Object>> selecSeDetail(MngrMemberVO param)throws Exception;
    
    List<HashMap<String, Object>> getCodeByGroupField(String codeId)throws Exception;
    List<HashMap<String, Object>> getCodeByGroupLicense()throws Exception;
    
    HashMap<String, Object> selectIdEmailChk(MngrMemberVO param)throws Exception;

    void isueCertProc(MngrMemberVO param)throws Exception;
    void fileConfirmProcess(MngrMemberVO param)throws Exception;
    List<HashMap<String, Object>> selectFileConfirmList(PageInfoVO pageVO)throws Exception;

	void updateMngrMemberNote(MngrMemberVO param) throws Exception;

	void updateMngrMemberEntrstDe(MngrMemberVO param) throws Exception;
	
	void updateMngrMemberPackageAuthAt(MngrMemberVO param) throws Exception;

	List<HashMap<String, Object>> selectMemberNoteList(PageInfoVO pageVO) throws Exception;
	void mngrMemberNoteProc(MngrMemberVO param) throws Exception;

	HashMap<String, Object> selectMemberNoteDetail(MngrMemberVO param) throws Exception;

}
