package egovframework.com.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.ParamUtils;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovResourceCloseHelper;
import egovframework.com.exception.FileException;
import egovframework.com.file.service.vo.FileVO;
import egovframework.com.sequence.SequenceService;

@Component("FileMngUtil") 
public class FileMngUtil {

	public static final int BUFF_SIZE = 2048;
	public static final String fileStorePath = EgovProperties.getProperty("Globals.fileStorePath");
	
	@Autowired
	private SequenceService sequenceService;

	
	
	/**
	 * 첨부파일에 대한 목록 정보를 취득한다.
	 *
	 * @param files
	 * @return
	 * @throws Exception
	 */
	public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
		int fileKey = fileKeyParam;
		
		String storePathString = fileStorePath + File.separator + storePath;
		String atchFileIdString = "";

		if ("".equals(atchFileId) || atchFileId == null) {
			atchFileIdString = sequenceService.getFileSequence();
		} else {
			atchFileIdString = atchFileId;
		}

		File saveFolder = new File(ParamUtils.filePathBlackList(storePathString));

		if (!saveFolder.exists() || saveFolder.isFile()) {
			saveFolder.mkdirs();
		}

		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		String filePath = "";
		List<FileVO> result = new ArrayList<FileVO>();
		FileVO fvo;

		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();

			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();

			//--------------------------------------
			// 
			// 
			//--------------------------------------
			if ("".equals(orginFileName)) {
				continue;
			}
			////------------------------------------

			int index = orginFileName.lastIndexOf(".");
			//String fileName = orginFileName.substring(0, index);
			String fileExt = orginFileName.substring(index + 1);
			String newName = KeyStr + getTimeStamp() + fileKey;
			long size = file.getSize();

			if (!"".equals(orginFileName)) {
				filePath = storePathString + File.separator + newName;
				file.transferTo(new File(ParamUtils.filePathBlackList(filePath)));
			}
			
			fvo = new FileVO();
			fvo.setFileExtsn(fileExt);
			fvo.setFileStreCours(storePathString);
			fvo.setFileMg(Long.toString(size));
			fvo.setOrignlFileNm(orginFileName);
			fvo.setStreFileNm(newName);
			fvo.setAtchFileId(atchFileIdString);
			fvo.setFileSn(String.valueOf(fileKey));

			result.add(fvo);

			fileKey++;
		}

		return result;
	}
	
	
	public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath, long fileMaxSize) throws FileException {
		int fileKey = fileKeyParam;

		String storePathString = fileStorePath + File.separator + storePath;
		String atchFileIdString = "";

		if ("".equals(atchFileId) || atchFileId == null) {
			try {
				atchFileIdString = sequenceService.getFileSequence();
			} catch (Exception e) {
				throw new FileException("파일 시퀀스 에러"); 
			}
			
		} else {
			atchFileIdString = atchFileId;
		}

		File saveFolder = new File(ParamUtils.filePathBlackList(storePathString));

		if (!saveFolder.exists() || saveFolder.isFile()) {
			saveFolder.mkdirs();
		}

		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		String filePath = "";
		List<FileVO> fileList = new ArrayList<FileVO>();
		HashMap<String, Object> result = new HashMap<String, Object>();
		FileVO fvo;
		
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();

			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();

			//--------------------------------------
			// 
			// 
			//--------------------------------------
			if ("".equals(orginFileName)) {
				continue;
			}
			////------------------------------------

			int index = orginFileName.lastIndexOf(".");
			//String fileName = orginFileName.substring(0, index);
			String fileExt = orginFileName.substring(index + 1);
			String newName = KeyStr + getTimeStamp() + fileKey;
			long size = file.getSize();
			if(size  > fileMaxSize ) throw new FileException("첨부파일 용량 제한");

			if (!"".equals(orginFileName)) {
				filePath = storePathString + File.separator + newName;
				try {
					file.transferTo(new File(ParamUtils.filePathBlackList(filePath)));
				} catch (Exception e) {
					throw new FileException("파일 생성 에러");
				}
			}
			
			fvo = new FileVO();
			fvo.setFileExtsn(fileExt);
			fvo.setFileStreCours(storePathString);
			fvo.setFileMg(Long.toString(size));
			fvo.setOrignlFileNm(orginFileName);
			fvo.setStreFileNm(newName);
			fvo.setAtchFileId(atchFileIdString);
			fvo.setFileSn(String.valueOf(fileKey));

			fileList.add(fvo);

			fileKey++;
		}
		
		return fileList;
	}
	
	
	
	public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath, long fileMaxSize, String[] fileUplaodSn) throws FileException {
		int fileKey = fileKeyParam;

		String storePathString = fileStorePath + File.separator + storePath;
		String atchFileIdString = "";

		if ("".equals(atchFileId) || atchFileId == null) {
			try {
				atchFileIdString = sequenceService.getFileSequence();
			} catch (Exception e) {
				throw new FileException("파일 시퀀스 에러"); 
			}
			
		} else {
			atchFileIdString = atchFileId;
		}

		File saveFolder = new File(ParamUtils.filePathBlackList(storePathString));

		if (!saveFolder.exists() || saveFolder.isFile()) {
			saveFolder.mkdirs();
		}

		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		String filePath = "";
		List<FileVO> fileList = new ArrayList<FileVO>();
		HashMap<String, Object> result = new HashMap<String, Object>();
		FileVO fvo;
		
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			String entryKey = entry.getKey().replaceAll("input_file", "");
			int sn = Integer.parseInt(entryKey)-1;

			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();

			//--------------------------------------
			// 
			// 
			//--------------------------------------
			if ("".equals(orginFileName)) {
				continue;
			}
			////------------------------------------

			int index = orginFileName.lastIndexOf(".");
			//String fileName = orginFileName.substring(0, index);
			String fileExt = orginFileName.substring(index + 1);
			String newName = KeyStr + getTimeStamp() + fileUplaodSn[sn];
			long size = file.getSize();
			if(size  > fileMaxSize ) throw new FileException("첨부파일 용량 제한");

			if (!"".equals(orginFileName)) {
				filePath = storePathString + File.separator + newName;
				try {
					file.transferTo(new File(ParamUtils.filePathBlackList(filePath)));
				} catch (Exception e) {
					throw new FileException("파일 생성 에러");
				}
			}
			
			fvo = new FileVO();
			fvo.setFileExtsn(fileExt);
			fvo.setFileStreCours(storePathString);
			fvo.setFileMg(Long.toString(size));
			fvo.setOrignlFileNm(orginFileName);
			fvo.setStreFileNm(newName);
			fvo.setAtchFileId(atchFileIdString);
			fvo.setFileSn(String.valueOf(fileUplaodSn[sn]));

			fileList.add(fvo);

			fileKey++;
		}
		
		return fileList;
	}
	
	/**
	 * 첨부파일을 서버에 저장한다.
	 *
	 * @param file
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	protected void writeUploadedFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;

		try {
			stream = file.getInputStream();
			File cFile = new File(stordFilePath);

			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdir();
				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}

			bos = new FileOutputStream(stordFilePath + File.separator + newName);

			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];

			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} finally {
			EgovResourceCloseHelper.close(bos, stream);
		}
	}

	/**
	 * 서버의 파일을 다운로드한다.
	 *
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public static void downFile(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String downFileName = "";
		String orgFileName = "";

		if ((String) request.getAttribute("downFile") == null) {
			downFileName = "";
		} else {
			downFileName = (String) request.getAttribute("downFile");
		}

		if ((String) request.getAttribute("orgFileName") == null) {
			orgFileName = "";
		} else {
			orgFileName = (String) request.getAttribute("orginFile");
		}

		orgFileName = orgFileName.replaceAll("\r", "").replaceAll("\n", "");

		File file = new File(ParamUtils.filePathBlackList(downFileName));

		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		byte[] buffer = new byte[BUFF_SIZE]; //buffer size 2K.

		response.setContentType("application/x-msdownload");
		response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(), "UTF-8"));
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");

		BufferedInputStream fin = null;
		BufferedOutputStream outs = null;

		try {
			fin = new BufferedInputStream(new FileInputStream(file));
			outs = new BufferedOutputStream(response.getOutputStream());
			int read = 0;

			while ((read = fin.read(buffer)) != -1) {
				outs.write(buffer, 0, read);
			}
		} finally {
			EgovResourceCloseHelper.close(outs, fin);
		}
	}

	/**
	 * 첨부로 등록된 파일을 서버에 업로드한다.
	 *
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> uploadFile(MultipartFile file) throws Exception {

		HashMap<String, String> map = new HashMap<String, String>();
		
		String newName = "";
		String stordFilePath = fileStorePath;
		String orginFileName = file.getOriginalFilename();

		int index = orginFileName.lastIndexOf(".");
		//String fileName = orginFileName.substring(0, _index);
		String fileExt = orginFileName.substring(index + 1);
		long size = file.getSize();

		newName = getTimeStamp(); // 2012.11 KISA 보안조치
		writeFile(file, newName, stordFilePath);
		
		map.put("originalFileName", orginFileName);
		map.put("uploadFileName", newName);
		map.put("fileExtension", fileExt);
		map.put("filePath", stordFilePath);
		map.put("fileSize", String.valueOf(size));

		return map;
	}

	/**
	 * 파일을 실제 물리적인 경로에 생성한다.
	 *
	 * @param file
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	protected static void writeFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;

		try {
			stream = file.getInputStream();
			File cFile = new File(ParamUtils.filePathBlackList(stordFilePath));

			if (!cFile.isDirectory())
				cFile.mkdir();

			bos = new FileOutputStream(ParamUtils.filePathBlackList(stordFilePath + File.separator + newName));

			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];

			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} finally {
			EgovResourceCloseHelper.close(bos, stream);
		}
	}

	/**
	 * 서버 파일에 대하여 다운로드를 처리한다.
	 *
	 * @param response
	 * @param streFileNm 파일저장 경로가 포함된 형태
	 * @param orignFileNm
	 * @throws Exception
	 */
	public void downFile(HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
		String downFileName = streFileNm;
		String orgFileName = orignFileNm;

		File file = new File(downFileName);
		
		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		int fSize = (int) file.length();
		if (fSize > 0) {
			BufferedInputStream in = null;

			try {
				in = new BufferedInputStream(new FileInputStream(file));

				String mimetype = "application/x-msdownload";

				//response.setBufferSize(fSize);
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition:", "attachment; filename=" + orgFileName);
				response.setContentLength(fSize);
				//response.setHeader("Content-Transfer-Encoding","binary");
				//response.setHeader("Pragma","no-cache");
				//response.setHeader("Expires","0");
				FileCopyUtils.copy(in, response.getOutputStream());
			} finally {
				EgovResourceCloseHelper.close(in);
			}
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}

		/*
		String uploadPath = propertiesService.getString("fileDir");

		File uFile = new File(uploadPath, requestedFile);
		int fSize = (int) uFile.length();

		if (fSize > 0) {
		    BufferedInputStream in = new BufferedInputStream(new FileInputStream(uFile));

		    String mimetype = "text/html";

		    //response.setBufferSize(fSize);
		    response.setContentType(mimetype);
		    response.setHeader("Content-Disposition", "attachment; filename=\"" + requestedFile + "\"");
		    response.setContentLength(fSize);

		    FileCopyUtils.copy(in, response.getOutputStream());
		    in.close();
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		} else {
		    response.setContentType("text/html");
		    PrintWriter printwriter = response.getWriter();
		    printwriter.println("<html>");
		    printwriter.println("<br><br><br><h2>Could not get file name:<br>" + requestedFile + "</h2>");
		    printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
		    printwriter.println("<br><br><br>&copy; webAccess");
		    printwriter.println("</html>");
		    printwriter.flush();
		    printwriter.close();
		}
		//*/

		/*
		response.setContentType("application/x-msdownload");
		response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(),"UTF-8" ));
		response.setHeader("Content-Transfer-Encoding","binary");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","0");

		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		int read = 0;

		while ((read = fin.read(b)) != -1) {
		    outs.write(b,0,read);
		}
		log.debug(this.getClass().getName()+" BufferedOutputStream Write Complete!!! ");

		outs.close();
		fin.close();
		//*/
	}

	/**
	 * 공통 컴포넌트 utl.fcc 패키지와 Dependency제거를 위해 내부 메서드로 추가 정의함
	 * 응용어플리케이션에서 고유값을 사용하기 위해 시스템에서17자리의TIMESTAMP값을 구하는 기능
	 *
	 * @param
	 * @return Timestamp 값
	 * @see
	 */
	private static String getTimeStamp() {

		String rtnStr = null;

		
		String pattern = "yyyyMMddhhmmssSSS";

		SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
		Timestamp ts = new Timestamp(System.currentTimeMillis());

		rtnStr = sdfCurrent.format(ts.getTime());

		return rtnStr;
	}


	
}
