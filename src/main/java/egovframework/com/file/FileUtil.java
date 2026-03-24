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

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public class FileUtil
{
    private ArrayList result = new ArrayList();

    /**
     * path내의 모든 파일을 조회한다
     * a.txt*128kb --> b.txt*12kb
     */
    public boolean readDirectory(String path)
    {
        boolean isSuccess = true;
        String tmp;

        try {
            File dir = new File(path);
            File[] list = dir.listFiles();

            
            for (int i=0; i<list.length; i++)
            {
                if (list[i].isHidden())
                    continue;

                tmp = new String();

                if (list[i].isDirectory())
                {
                    tmp = "Folder*";
                    tmp += list[i].getName() + "*" + toKiloBytes(list[i].length());
                    result.add(tmp);
                }
            }

           
            for (int i=0; i<list.length; i++)
            {
                if (list[i].isHidden())
                    continue;

                tmp = new String();

                if (!list[i].isDirectory())
                {
                    tmp = "File*";
                    tmp += list[i].getName() + "*" + toKiloBytes(list[i].length());
                    result.add(tmp);
                }
            }
        } catch (Exception e) {
            isSuccess = false;
        }

        return isSuccess;
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

	public boolean copyFile(String sourceFilePath, String targetFilePath)
	{
		File f1 = new File(sourceFilePath);
		boolean flag=true;
		try
		{
			if(f1.exists())
			{
				FileInputStream fin = new FileInputStream(sourceFilePath);
				FileOutputStream fout = new FileOutputStream(targetFilePath);
				byte buffer[] = new byte[1024];
				int j;
				while((j = fin.read(buffer)) >= 0)
				fout.write(buffer, 0, j);
				fout.close();
				fin.close();
			}
			else
			flag=false;
		}
		catch(IOException e)
		{
			System.out.println(e.toString());
		}
		return flag;
	};    
	
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