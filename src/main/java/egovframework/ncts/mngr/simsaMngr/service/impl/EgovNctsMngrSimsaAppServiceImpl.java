package egovframework.ncts.mngr.simsaMngr.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import com.ibm.icu.util.BytesTrie.Entry;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.file.FileViewMarkupBuilder;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.shareMngr.service.impl.EgovNctsMngrShareServiceImpl;
import egovframework.ncts.mngr.simsaMngr.mapper.EgovNctsMngrSimsaAppMapper;
import egovframework.ncts.mngr.simsaMngr.mapper.EgovNctsMngrSimsaMapper;
import egovframework.ncts.mngr.simsaMngr.service.EgovNctsMngrSimsaAppService;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaApplicantVO;
import egovframework.ncts.mngr.simsaMngr.vo.MngrSimsaManageVO;

@Service
public class EgovNctsMngrSimsaAppServiceImpl implements EgovNctsMngrSimsaAppService{

	@Autowired
	private EgovNctsMngrSimsaAppMapper egovNctsMngrSimsaAppMapper;

	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	
	@Override
	public List<HashMap<String, Object>> selectSimsaAppList(MngrSimsaApplicantVO VO) throws Exception {
		List<HashMap<String, Object>> list = egovNctsMngrSimsaAppMapper.selectSimsaAppList(VO);
		
		for(int i=0; i < list.size(); i++) {
			HashMap<String, Object> result = list.get(i);
		        String fileView = FileViewMarkupBuilder.newInstance()
		                .atchFileId(StringUtils.defaultIfEmpty((String) result.get("ATCH_FILE_ID"), ""))
		                .wrapMarkup("p")
		                .isIcon(true)
		                .isSize(true)
		                .build()
		                .toString(); 
		        list.get(i).put("fileView", fileView);
		 }
		
		 return list;
       
	}


	@Override
	public void updateSimsaAppList(MngrSimsaApplicantVO param) throws Exception {
		ProcType procType = ProcType.findByProcType(param.getProcType());
		if (ProcType.UPDATE.equals(procType)) {
			List<MngrSimsaApplicantVO> appList = param.getAppList();
			if(null != appList){
				for(MngrSimsaApplicantVO vo : appList){
					egovNctsMngrSimsaAppMapper.updateSimsaAppList(vo);
				}
            }			
		} else {
			throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
		}
	}

	@Override
	public HashMap<String, Object> selectSimsaAppExcelDownload(MngrSimsaApplicantVO param) throws Exception {
        HashMap<String, Object> rs = new HashMap<>();
        HashMap<String, Object> paramMap = new HashMap<>();
        String fileName = "";
        String templateFile = "";
        
        List<HashMap<String, Object>> rsTp = egovNctsMngrSimsaAppMapper.selectSimsaAppExcelDownload(param);

        paramMap.put("rsList",rsTp);
        fileName = param.getExcelFileNm();
        templateFile = param.getExcelPageNm();
        rs.put("paramMap", paramMap);
        rs.put("fileName", fileName);
        rs.put("templateFile", templateFile);
        
        return rs;
    }

	

}
