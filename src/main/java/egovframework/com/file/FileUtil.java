package egovframework.com.file;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.ncts.cmm.login.web.EgovNctsLoginController;

public class FileUtil
{
	private static final Logger log = LoggerFactory.getLogger(FileUtil.class);
    private ArrayList result = new ArrayList();

    /**
     * path내의 모든 파일을 조회한다
     * a.txt*128kb --> b.txt*12kb
     */
//    public boolean readDirectory(String path)
//    {
//        boolean isSuccess = true;
//        String tmp;
//
//        try {
//            File dir = new File(path);
//            File[] list = dir.listFiles();
//
//            
//            for (int i=0; i<list.length; i++)
//            {
//                if (list[i].isHidden())
//                    continue;
//
//                tmp = new String();
//
//                if (list[i].isDirectory())
//                {
//                    tmp = "Folder*";
//                    tmp += list[i].getName() + "*" + toKiloBytes(list[i].length());
//                    result.add(tmp);
//                }
//            }
//
//           
//            for (int i=0; i<list.length; i++)
//            {
//                if (list[i].isHidden())
//                    continue;
//
//                tmp = new String();
//
//                if (!list[i].isDirectory())
//                {
//                    tmp = "File*";
//                    tmp += list[i].getName() + "*" + toKiloBytes(list[i].length());
//                    result.add(tmp);
//                }
//            }
//        } catch (Exception e) {
//            isSuccess = false;
//        }
//
//        return isSuccess;
//    }
    
    public boolean readDirectory(String path) {

        // 1. path 사전 검증
        if (path == null || path.trim().isEmpty()) {
        	log.warn("readDirectory: path가 null 또는 빈 값입니다.");
            return false;
        }

        // 2. 경로 조작 방어: 정규화 후 허용 경로 내인지 확인
        File dir = new File(path).toPath().normalize().toFile();
        if (!dir.exists() || !dir.isDirectory()) {
        	log.warn("readDirectory: 유효하지 않은 디렉터리 경로입니다. path={}", path);
            return false;
        }

        // 3. listFiles() null 검증 → 접근 권한 없거나 IO 오류 시 null 반환
        File[] list = dir.listFiles();
        if (list == null) {
        	log.warn("readDirectory: 디렉터리 목록 조회 실패 (권한 문제 가능). path={}", path);
            return false;
        }

        // 4. 단일 순회로 폴더/파일 분리 수집 (2회 순회 제거)
        List<String> folders = new ArrayList<>();
        List<String> files   = new ArrayList<>();

        for (File entry : list) {                          // 향상된 for문 사용
            if (entry.isHidden()) continue;

            if (entry.isDirectory()) {
                // 5. new String() → 문자열 연결로 단순화
                folders.add("Folder*" + entry.getName() + "*" + toKiloBytes(entry.length()));
            } else {
                files.add("File*" + entry.getName() + "*" + toKiloBytes(entry.length()));
            }
        }

        // 폴더 먼저, 파일 나중 순서 유지
        result.addAll(folders);
        result.addAll(files);

        return true;
    }      

    public ArrayList getDirectoryInfo()
    {
        return this.result;
    }
    /**
     * byte를 입력받아 kilo byte로 변환한 스트링을 리턴
     */
    public String toKiloBytes(long size)
    {
        if (size < 1024)
            return "1kb";

        size /= 1024;

        return (Long.toString(size) + "kb");
    }

    /**
     * 입력받은 파일을 삭제한다
     */
    public boolean deleteFile(String filepath) throws Exception
    {
        boolean result = true;

        File f = new File(filepath);
        result = f.delete();

        return result;
    }
    
	public void makeDir(String fullPath)
	{
		File dirToMake = new File(fullPath);
		if(!dirToMake.exists())
		{
			dirToMake.mkdirs();
		}
	};

//	public boolean copyFile(String sourceFilePath, String targetFilePath)
//	{
//		File f1 = new File(sourceFilePath);
//		boolean flag=true;
//		try
//		{
//			if(f1.exists())
//			{
//				FileInputStream fin = new FileInputStream(sourceFilePath);
//				FileOutputStream fout = new FileOutputStream(targetFilePath);
//				byte buffer[] = new byte[1024];
//				int j;
//				while((j = fin.read(buffer)) >= 0)
//				fout.write(buffer, 0, j);
//				fout.close();
//				fin.close();
//			}
//			else
//			flag=false;
//		}
//		catch(IOException e)
//		{
//			System.out.println(e.toString());
//		}
//		return flag;
//	};   
	
	public boolean copyFile(String sourceFilePath, String targetFilePath) {

	    File sourceFile = new File(sourceFilePath);
	    File targetFile = new File(targetFilePath);

	    if (!sourceFile.exists()) {
	        return false;
	    }

	    // try-with-resources: 예외 발생 여부와 무관하게 fin/fout 자동 close()
	    try (FileInputStream  fin  = new FileInputStream(sourceFile);
	         FileOutputStream fout = new FileOutputStream(targetFile)) {

	        // NIO 채널 복사: OS 레벨 전송으로 성능 향상, 수동 버퍼 불필요
	        fin.getChannel().transferTo(0, sourceFile.length(), fout.getChannel());
	        return true;

	    } catch (IOException e) {
	        // 복사 실패 시 불완전하게 생성된 타겟 파일 정리
	        if (targetFile.exists()) {
	            targetFile.delete();
	        }
	        log.error("파일 복사 실패: {} -> {}", sourceFilePath, targetFilePath, e);
	        return false;
	    }
	}	
	
	public String copyFile(String sourceFilePath, String targetFilePath, String targetFileName)
	{
    	String returnStr = "";
    	File f1 = new File(sourceFilePath);
		try
		{
			if(f1.exists())
			{
				
				File f2 = new File(targetFilePath + File.separator + targetFileName);
				String temp = f2.getName();
				for(int i = 1; f2.exists(); i++) {
	                int st=temp.indexOf(".");
	                String temp1 = temp.substring(0,st);
	                String temp2 = temp.substring(st);

					f2 = new File(f2.getParent(), temp1+ "_"+i+temp2);
				}
				targetFileName = f2.getName();
				
				returnStr = targetFilePath + File.separator + targetFileName;

				FileInputStream fin = new FileInputStream(sourceFilePath);
				FileOutputStream fout = new FileOutputStream(returnStr);
				byte buffer[] = new byte[1024];
				int j;
				while((j = fin.read(buffer)) >= 0)
					fout.write(buffer, 0, j);
				fout.close();
				fin.close();
				
			}
		}
		catch(IOException e)
		{
			returnStr = "";
		}
		return returnStr;
	}
	
	public boolean writer(File file, StringBuffer data) {
		try {
			if(!file.isFile()) {
				file.createNewFile();
			}
	
			PrintWriter output = new PrintWriter(
								 new BufferedWriter(
								 new FileWriter(file)));
			output.print(data.toString());
			output.close();
		} catch(IOException e) {
			return false;
		}
		return true;
	}
	
	public boolean writer(String path, String fileName, StringBuffer data) {
		File file = new File(path, fileName);
		return writer(file, data);
	}
	
	/**
	 * File Move
	 * @param orgFileName original File Path
	 * @param targetFileName target File Path
	 * @param fileEtcYn Exe Exist
	 * @return
	 */
	public static HashMap<String, String> setFileRename( String orgFileName, String targetFileName, boolean fileEtcYn ) {
		HashMap<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("result", "success");
		try {
			File oriFile = new File(orgFileName);
			File targetFile = getRenameFile(new File(targetFileName), "_", fileEtcYn);
			
			//Change Name
			if( oriFile.renameTo(targetFile) ) {
				resultMap.put("fileSysName", targetFile.getName());
				
				long size = targetFile.length();
				if( size < 1024 ) size = 1;
				else size /= 1024;
				
				resultMap.put("fileSize", Long.toString(size) + "kb");
				
			} else {
				resultMap.put("result", "rename_error");
			}
			
		} catch ( Exception e) {
			resultMap.put("result", "error");
		}
		
		return resultMap;
	}
	
	/**
	 * Return change File Name
	 * @param f1 
	 * @param fileEtcYn
	 * @param renameType
	 * @return
	 */
	public static File getRenameFile( File f1, String renameType, boolean fileEtcYn  ) {
		try {
			String tempName = f1.getName();
			
			while( f1.exists() ) {
				if( fileEtcYn ) { //Ext Exist
					int st = tempName.indexOf(".");
					String temp1 = tempName.substring(0,st);
	                String temp2 = tempName.substring(st);
	                f1 = new File(f1.getParent(), temp1 + renameType + temp2);
				} else { //Ext No Exist
					tempName += renameType;
					f1 = new File( f1.getParent(), tempName);
				}
			}
			
		}  catch ( Exception e ) {
			return f1;
		}
		
		return f1;
	}
	
	/**
	 * 파일업로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> setFileMakeToList(MultipartHttpServletRequest request,  String uploadPath, String[] ext) throws Exception{
				
		Map<String, Object> returnMap = new HashMap<String, Object>();		
		String result = "success";
		int upload_size = 1024 * 1024 * 100;
		int real_total = 0;
		String childFolder = request.getParameter("file_dir");
		//folder mkdir
		File saveFolder = new File(uploadPath+File.separator+childFolder);
		if(!saveFolder.exists() || saveFolder.isFile()){
			saveFolder.mkdirs();
		}
		
		//iterator
		Iterator<String> files = request.getFileNames();
		MultipartFile multipartFile;
		String filePath;
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		int i = 0;
		try{
			
			//while
			while(files.hasNext()){			
				
				//file생성
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				multipartFile = request.getFile((String)files.next());
				String originalFileName = multipartFile.getOriginalFilename();
				String fileext = multipartFile.getOriginalFilename().substring(originalFileName.lastIndexOf(".")+1 );
				String filename = uuid+"."+fileext;
				filePath = uploadPath+File.separator+childFolder+File.separator+filename;
				boolean file_extention_check = false;
			    for( int k=0; k<ext.length; k++) {
			    	if( ext[k].equals(fileext.toLowerCase()) ) {
			    		file_extention_check = true;
			    		break;
			    	}
			    }
			    i++;
				if( originalFileName != null && !"".equals(originalFileName) ){
					
					if(file_extention_check == false){
				    	result = "extension_error";
				    }else{
						multipartFile.transferTo(new File(filePath));
						real_total ++;
						long size = multipartFile.getSize();
						if( size < 1024 ) size = 1;
						else size /= 1024;
						String sizeStr = Long.toString(size) + "kb";
						
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("file_no", i + "");
						map.put("file_info", filename + "*" + originalFileName + "*" + sizeStr + "*" + fileext);
						
						list.add(map);
				    }
				}
			}
			
		}catch(IOException e){
//			e.printStackTrace();
		}
		returnMap.put("list", list);
		returnMap.put("upload_size",upload_size);
		returnMap.put("real_total",real_total);
		
		returnMap.put("result",result);
		return returnMap;
		
	}
	
}