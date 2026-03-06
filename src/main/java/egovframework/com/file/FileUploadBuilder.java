package egovframework.com.file;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.BeanUtils;
import egovframework.com.file.service.FileMngService;
import egovframework.com.file.service.vo.FileVO;
import egovframework.com.vo.ProcType;

public class FileUploadBuilder {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUploadBuilder.class);
	
	private FileMngService fileMngService;
	private FileMngUtil fileUtil;
	private MultipartHttpServletRequest multiRequest;
	private List<FileVO> fileList = null;
	private Map<String, MultipartFile> files = null;
	private String atchFileId = "";
	private String keyStr;
	private int fileKey;
	private long fileMaxSize;
	private String storePath;
	
	private ProcType procType;
	
	private FileUploadBuilder() {
		fileMngService = (FileMngService)BeanUtils.getBean("FileMngService");
		fileUtil = (FileMngUtil)BeanUtils.getBean("FileMngUtil");
		fileMaxSize = 300 * 1024 * 1024;
		storePath = "";
	}
	
    public static FileUploadBuilder getInstance() {
		return new FileUploadBuilder();
    }

    public FileUploadBuilder multiRequest(MultipartHttpServletRequest multiRequest) {
        this.multiRequest = multiRequest;
        return this;
    }
    
    public FileUploadBuilder procType(ProcType procType) {
        this.procType = procType;
        return this;
    }
    
    public FileUploadBuilder atchFileId(String atchFileId) {
        this.atchFileId = atchFileId;
        return this;
    }
    
    public FileUploadBuilder keyStr(String keyStr) {
        this.keyStr = keyStr;
        return this;
    }
    
    public FileUploadBuilder fileKey(int fileKey) {
        this.fileKey = fileKey;
        return this;
    }
    
    public FileUploadBuilder fileMaxSize(long fileMaxSize) {
        this.fileMaxSize = fileMaxSize;
        return this;
    }
    
    public FileUploadBuilder storePath(String storePath) {
        this.storePath = storePath;
        return this;
    }
    
    

    public String build() throws Exception {
    	
    	HashMap<String, Object> resultMap = new HashMap();
    	this.files = multiRequest.getFileMap();
		FileVO fvo = new FileVO();
		if(procType == ProcType.UPDATE){
			if(!"".equals(this.atchFileId)){
				fvo.setAtchFileId(this.atchFileId);
				this.fileKey = fileMngService.getMaxFileSN(fvo) +1;
				
				String[] fileUplaodChk = multiRequest.getParameterValues("fileUplaodChk");
				String[] fileUplaodSn = multiRequest.getParameterValues("fileUplaodSn");
				
				for(int i=0 ; i < fileUplaodChk.length;i++){
					if("D".equals(fileUplaodChk[i])){
						fvo.setAtchFileId(this.atchFileId);
						fvo.setFileSn(fileUplaodSn[i]);
						fileMngService.deleteFileInf(fvo);
					}
				}
			}
			
		} 
		
		if(!this.files.isEmpty()){
			this.fileList = fileUtil.parseFileInf(files, this.keyStr, this.fileKey, this.atchFileId, this.storePath, fileMaxSize);
			this.atchFileId = fileMngService.insertFileInfs(fileList);  
		}
    	
    	return this.atchFileId;
    }
    
    
    public String build_each() throws Exception {
    	
    	HashMap<String, Object> resultMap = new HashMap();
    	
    	this.files = multiRequest.getFileMap();
    	String[] fileUplaodSn = multiRequest.getParameterValues("fileUplaodSn");
		FileVO fvo = new FileVO();
		
		if(procType == ProcType.UPDATE){
			if(!"".equals(this.atchFileId)){
				fvo.setAtchFileId(this.atchFileId);
				this.fileKey = fileMngService.getMaxFileSN(fvo) +1;
				
				String[] fileUplaodChk = multiRequest.getParameterValues("fileUplaodChk");
				
				for(int i=0 ; i < fileUplaodChk.length;i++){
					if("D".equals(fileUplaodChk[i])){
						fvo.setAtchFileId(this.atchFileId);
						fvo.setFileSn(fileUplaodSn[i]);
						fileMngService.deleteFileInf(fvo);
					}
				}
			}
			
		} 
		
		if(!this.files.isEmpty()){
			this.fileList = fileUtil.parseFileInf(files, this.keyStr, this.fileKey, this.atchFileId, this.storePath, fileMaxSize,fileUplaodSn);
			this.atchFileId = fileMngService.insertFileInfs(fileList);  
		}
    	
    	return this.atchFileId;
    }
    
}
