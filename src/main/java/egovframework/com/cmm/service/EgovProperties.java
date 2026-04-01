package egovframework.com.cmm.service;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.util.EgovResourceCloseHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *  Class Name : EgovProperties.java
 *  Description : properties값들을 파일로부터 읽어와   Globals클래스의 정적변수로 로드시켜주는 클래스로
 *   문자열 정보 기준으로 사용할 전역변수를 시스템 재시작으로 반영할 수 있도록 한다.
 *  Modification Information
 *
 *     수정일         수정자                   수정내용
 *   -------    --------    ---------------------------
 *   2009.01.19    박지욱          최초 생성
 *	 2011.07.20    서준식 	      Globals파일의 상대경로를 읽은 메서드 추가
 *	 2014.10.13    이기하 	      Globals.properties 값이 null일 경우 오류처리
 *  @author 공통 서비스 개발팀 박지욱
 *  @since 2009. 01. 19
 *  @version 1.0
 *  @see
 *
 */

public class EgovProperties {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovProperties.class);

	//파일구분자
	final static  String FILE_SEPARATOR = System.getProperty("file.separator");

	
	//public static final String GLOBALS_PROPERTIES_FILE = System.getProperty("user.home") + FILE_SEPARATOR + "egovProps" +FILE_SEPARATOR + "globals.properties";

	//public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath()	+ FILE_SEPARATOR+ ".." + FILE_SEPARATOR  + ".." + FILE_SEPARATOR;

//	public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("com"));
	
	public static final String RELATIVE_PATH_PREFIX;

	static {
	    // 1. getResource("") 단 1회 호출, null 검증
	    URL resource = EgovProperties.class.getResource("");
	    if (resource == null) {
	        throw new IllegalStateException(
	            "[EgovProperties] 클래스 리소스 경로를 확인할 수 없습니다. " +
	            "클래스 로더 환경을 점검하세요.");
	    }

	    String path = resource.getPath();

	    // 2. "com" 세그먼트 존재 여부 검증 → lastIndexOf가 -1이면 substring 오류 방지
	    int comIdx = path.lastIndexOf("com");
	    if (comIdx < 0) {
	        throw new IllegalStateException(
	            "[EgovProperties] 경로에서 'com' 세그먼트를 찾을 수 없습니다. " +
	            "패키지 구조를 확인하세요. 경로: " + path);
	    }

	    RELATIVE_PATH_PREFIX = path.substring(0, comIdx);
	}	

	public static final String GLOBALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "egovProps" + FILE_SEPARATOR + "globals.properties";

	/**
	 * 인자로 주어진 문자열을 Key값으로 하는 상대경로 프로퍼티 값을 절대경로로 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
//	public static String getPathProperty(String keyName) {
//		String value = "";
//		
//		LOGGER.debug("getPathProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);
//		
//		FileInputStream fis = null;
//		try {
//			Properties props = new Properties();
//			
//			fis = new FileInputStream(EgovWebUtil.filePathBlackList(GLOBALS_PROPERTIES_FILE));
//			props.load(new BufferedInputStream(fis));
//			
//			value = props.getProperty(keyName).trim();
//			value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;
//		} catch (FileNotFoundException fne) {
//			LOGGER.debug("Property file not found.", fne);
//			throw new RuntimeException("Property file not found", fne);
//		} catch (IOException ioe) {
//			LOGGER.debug("Property file IO exception", ioe);
//			throw new RuntimeException("Property file IO exception", ioe);
//		} finally {
//			EgovResourceCloseHelper.close(fis);
//		}
//		
//		return value;
//	}
	public static String getPathProperty(String keyName) {
		String value = "";

		LOGGER.debug("getPathProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);

		// 1. BufferedInputStream을 try-with-resources로 직접 선언
//		    → 정상/예외 모두에서 bis.close() 자동 호출 (내부 fis도 함께 닫힘)
//		    → 별도 fis 변수 및 finally 블록 불필요
		Properties props = new Properties();

		try (BufferedInputStream bis = new BufferedInputStream(
		        new FileInputStream(EgovWebUtil.filePathBlackList(GLOBALS_PROPERTIES_FILE)))) {

		    props.load(bis);

		} catch (FileNotFoundException fne) {
		    LOGGER.debug("Property file not found.", fne);
		    throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
		    LOGGER.debug("Property file IO exception", ioe);
		    throw new RuntimeException("Property file IO exception", ioe);
		}

		// 2. getProperty() null 반환 시 .trim() NPE 방지
		String raw = props.getProperty(keyName);
		if (raw == null) {
		    throw new RuntimeException("Property key not found: " + keyName);
		}

		value = raw.trim();
		value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;

		return value;
	}

	/**
	 * 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
	public static String getProperty(String keyName) {
		String value = "";
		
		LOGGER.debug("getProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);
		
		FileInputStream fis = null;
		try {
			Properties props = new Properties();
			
			fis = new FileInputStream(EgovWebUtil.filePathBlackList(GLOBALS_PROPERTIES_FILE));
			
			props.load(new BufferedInputStream(fis));
			if (props.getProperty(keyName) == null) {
				return "";
			}
			value = props.getProperty(keyName).trim();
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			EgovResourceCloseHelper.close(fis);
		}
		
		return value;
	}

	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 상대 경로값을 절대 경로값으로 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getPathProperty(String fileName, String key) {
		FileInputStream fis = null;
		try {
			Properties props = new Properties();
			
			fis = new FileInputStream(EgovWebUtil.filePathBlackList(fileName));
			props.load(new BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);
			value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;
			
			return value;
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			EgovResourceCloseHelper.close(fis);
		}
	}

	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getProperty(String fileName, String key) {
		FileInputStream fis = null;
		try {
			Properties props = new Properties();
			
			fis = new FileInputStream(EgovWebUtil.filePathBlackList(fileName));
			props.load(new BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);
			
			return value;
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			EgovResourceCloseHelper.close(fis);
		}
	}

	/**
	 * 주어진 프로파일의 내용을 파싱하여 (key-value) 형태의 구조체 배열을 반환한다.
	 * @param property String
	 * @return ArrayList
	 */
	public static ArrayList<Map<String, String>> loadPropertyFile(String property) {

		
		ArrayList<Map<String, String>> keyList = new ArrayList<Map<String, String>>();

		String src = property.replace('\\', File.separatorChar).replace('/', File.separatorChar);
		FileInputStream fis = null;
		try {

			File srcFile = new File(EgovWebUtil.filePathBlackList(src));
			if (srcFile.exists()) {

				Properties props = new Properties();
				fis = new FileInputStream(src);
				props.load(new BufferedInputStream(fis));
				fis.close();

				Enumeration<?> plist = props.propertyNames();
				if (plist != null) {
					while (plist.hasMoreElements()) {
						Map<String, String> map = new HashMap<String, String>();
						String key = (String) plist.nextElement();
						map.put(key, props.getProperty(key));
						keyList.add(map);
					}
				}
			}
		} catch (IOException ex) {
			LOGGER.debug("IO Exception", ex);
			throw new RuntimeException(ex);
		} finally {
			EgovResourceCloseHelper.close(fis);
		}

		return keyList;
	}
}
