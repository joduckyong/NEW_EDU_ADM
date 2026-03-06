package egovframework.ncts.mngr.userMngr.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.vo.PageInfoVO;
import egovframework.ncts.mngr.userMngr.vo.MngrMemberVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface EgovNctsMngrMemberMapper {
    List<HashMap<String, Object>> selectMngrMemberList(PageInfoVO pageVO) throws Exception;

    HashMap<String, Object> selectMngrMemberDetail(MngrMemberVO param) throws Exception;

    List<HashMap<String, Object>> selectMngrMemberSeDetail(MngrMemberVO param) throws Exception;

    List<HashMap<String, Object>> selectMngrMemberSeVideoDetail(MngrMemberVO param) throws Exception;
    
    int selectMngrMemberCnt(PageInfoVO pageVO)throws Exception;

    void mngrUpdateProc(MngrMemberVO param)throws Exception;
    
    void updateMngrMemberNote(MngrMemberVO param)throws Exception;
    
    void updateMngrMemberEntrstDe(MngrMemberVO param)throws Exception;

    void delMember(MngrMemberVO param)throws Exception;

    void mngrInsertProc(MngrMemberVO param)throws Exception;

    List<HashMap<String, Object>> selectCommonExcel(PageInfoVO pageVO)throws Exception;

	void updateCertProc(MngrMemberVO certParam)throws Exception;

	void updateUserPwd(MngrMemberVO param)throws Exception;

    List<HashMap<String, Object>> selecSeDetail(MngrMemberVO param)throws Exception;

    int selectCntIssue(MngrMemberVO certParam) throws Exception;

    void insertIssue(MngrMemberVO certParam) throws Exception;

    void deleteIssue(MngrMemberVO certParam) throws Exception;
    void updateGrade(MngrMemberVO param)throws Exception;

	List<HashMap<String, Object>> getCodeByGroupField(String codeId)throws Exception;
	List<HashMap<String, Object>> getCodeByGroupLicense()throws Exception;

    HashMap<String, Object> selectCert(MngrMemberVO param)throws Exception;

    int getCertCnt(MngrMemberVO certParam)throws Exception;

    void insertCertProc(MngrMemberVO certParam)throws Exception;
    
    HashMap<String, Object> selectIdEmailChk(MngrMemberVO param)throws Exception;

    void isueCertProc(MngrMemberVO param)throws Exception;

    List<HashMap<String, Object>> getRuleList()throws Exception;

    void upDetailGrade(MngrMemberVO param)throws Exception;

    void upCertComple(MngrMemberVO param)throws Exception;

	int selectIsue(MngrMemberVO param)throws Exception;

	void insertFileConfirmAt(MngrMemberVO param)throws Exception;
	List<HashMap<String, Object>> selectFileConfirmList(PageInfoVO pageVO)throws Exception;
	int selectFileConfirmListTotCnt(PageInfoVO pageVO)throws Exception;

	void updateMngrMemberPackageAuthAt(MngrMemberVO param)throws Exception;

	int selectMemberNoteListTotCnt(PageInfoVO pageVO)throws Exception;
	List<HashMap<String, Object>> selectMemberNoteList(PageInfoVO pageVO)throws Exception;
	void insertMemberNote(MngrMemberVO param)throws Exception;
	void updateMemberNote(MngrMemberVO param)throws Exception;
	void deleteMemberNote(MngrMemberVO param)throws Exception;

	HashMap<String, Object> selectMemberNoteDetail(MngrMemberVO param)throws Exception;




}
