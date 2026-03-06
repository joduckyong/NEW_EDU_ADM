package egovframework.ncts.personalInfo.service.impl;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.ScpDbCode;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.ncts.personalInfo.mapper.EgovNctsPersonalInfoMapper;
import egovframework.ncts.personalInfo.service.EgovNctsPersonalInfoService;

@Service("personalInfoBatchService")
public class EgovNctsPersonalInfoServiceImpl implements EgovNctsPersonalInfoService {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsPersonalInfoServiceImpl.class);
	
	@Autowired
	private EgovNctsPersonalInfoMapper egovNctsPersonalInfoMapper;
	private static final String persionalInfoPath = EgovProperties.getProperty("Globals.persionalInfoPath");
	
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Autowired
	private ScpDbCode scp;

	@Override
	public void personalInfoBatchProcess() throws Exception {
		List<HashMap<String, Object>> list = egovNctsPersonalInfoMapper.personalInfoBatchProcess();
		
        String filePath = persionalInfoPath; // 원하는 경로로 수정하세요

        File file = new File(filePath);
        if (file.exists()) {
            file.delete();
        } 
        
        try (FileWriter writer = new FileWriter(filePath)) {
        	// BOM 추가
        	writer.write("\uFEFF");
            // CSV 헤더 작성
            writer.write("LOGIN_USER_ID,USER_NAME,IPADDR,DEPT1,DEPT2,DEPT_CD1,DEPT_CD2,POSITION,EMAIL,RETIRE_YN\n");
            // CSV 데이터 작성
            for (HashMap<String, Object> map : list) {
                writer.write(String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", 
                		map.get("LOGIN_USER_ID") != null ? map.get("LOGIN_USER_ID") : "", 
                	    map.get("USER_NAME") != null ? map.get("USER_NAME") : "",  
                	    map.get("IPADDR") != null ? map.get("IPADDR") : "",  
                		map.get("DEPT1") != null ? map.get("DEPT1") : "",  
                		map.get("DEPT2") != null ? map.get("DEPT2") : "",  
                		map.get("DEPT_CD1") != null ? map.get("DEPT_CD1") : "",  
                		map.get("DEPT_CD2") != null ? map.get("DEPT_CD2") : "",  
                		map.get("POSITION") != null ? map.get("POSITION") : "",  
                		scp.b64Str("D", String.valueOf(map.get("EMAIL"))) != null ? scp.b64Str("D", String.valueOf(map.get("EMAIL"))) : "",  
                		map.get("RETIRE_YN") != null ? map.get("RETIRE_YN") : ""
                		));
            }
            
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 755 권한 부여
        set755Permission(Paths.get(filePath));
        
		LOGGER.info("list : "+list);
	}

	// 755 권한 부여 메서드 추가
	private static void set755Permission(Path path) {
	    try {
	        if (Files.getFileStore(path).supportsFileAttributeView("posix")) {
	            Set<PosixFilePermission> perms = new HashSet<>();
	            // Owner: rwx
	            perms.add(PosixFilePermission.OWNER_READ);
	            perms.add(PosixFilePermission.OWNER_WRITE);
	            perms.add(PosixFilePermission.OWNER_EXECUTE);
	            // Group: r-x
	            perms.add(PosixFilePermission.GROUP_READ);
	            perms.add(PosixFilePermission.GROUP_EXECUTE);
	            // Others: r-x
	            perms.add(PosixFilePermission.OTHERS_READ);
	            perms.add(PosixFilePermission.OTHERS_EXECUTE);

	            Files.setPosixFilePermissions(path, perms);
	        } else {
	            System.out.println("POSIX permissions not supported on this OS.");
	        }
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}
	
}
