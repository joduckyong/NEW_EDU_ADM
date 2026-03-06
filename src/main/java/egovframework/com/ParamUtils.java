package egovframework.com;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

public class ParamUtils {
	
	 /**
	  * request printParameter
      * @param request
      * @return
      */
    public static String printParameter(HttpServletRequest request){
    	
		String paramsMsg = "\n";
		
		paramsMsg += "==================== printParameter S ====================" + "\n";
		
		paramsMsg += "==== IP : " + request.getRemoteAddr() + "\n";
		paramsMsg += "==== URL : " + request.getRequestURI() + "\n";
		
		Map map = request.getParameterMap();
		
		if( map != null ){
		
			Set set = map.keySet();
			Iterator it = set.iterator();
			while( it.hasNext() ){
				String key	 = (String)it.next();
				String value = "";
				
				if( map.get(key) instanceof String[]) {
					String [] tempStr = (String[]) map.get(key);
					for( String temp : tempStr ){
						value += (value.length()==0?"":",") + temp;
					}
				}else{
					value = map.get(key).toString();
				}
				
				paramsMsg += "==== " + key + " : " + value + "\n";
				
			}
		}
		
		paramsMsg += "==================== printParameter E ====================" + "\n";
		
		
		return paramsMsg;
	}
    
    /**
     * getParameter
     * @param request
     * @param param		key null
     * @return
     */
    public static String getParameter(HttpServletRequest request, String param) {
    	
    	return getParameter(request, param, null);
    }
    
    /**
     * getParameter null 일 경우 defaultValuewlwjd
     * @param request
     * @param param			key 
     * @param defaultValue	null 
     * @return
     */
    public static String getParameter(HttpServletRequest request, String param, String defaultValue) {
    	
    	String str = request.getParameter(param);
    	
    	return str==null || "".equals(str)?defaultValue:str;
    }
    
    /**
     * getParameterInt
     * @param request
     * @param param		value -1
     * @return
     */
    public static int getParameterInt(HttpServletRequest request, String param) {
    	return getParameterInt(request, param, -1);
    }
    
    /**
     * XSS 대응
     * @param request
     * @param param			key 
     * @param defaultValue	null 
     * @return
     */
    public static String getParameterXSS(HttpServletRequest request, String param, String defaultValue) {
    	
    	String str = request.getParameter(param);
    	
    	return str==null || "".equals(str)?defaultValue:getCleanXSS(str);
    }
    
    /**
     * getParameterInt
     * @param request
     * @param param		value
     * @return			
     */
    public static int getParameterInt(HttpServletRequest request, String param, int defaultValue) {
    	
    	int returnValue = 0;
    	String str = request.getParameter(param);
    	
    	str = str==null?"":str.trim();
    	
    	if( str.equals("") ){
    		returnValue = defaultValue;
    	}else{
    		returnValue = Integer.parseInt( str ); 
    	}
    	
    	return returnValue;
    }
    
    /**
     * getParameterLong ( long )
     * @param request
     * @param param		value
     * @return
     */
    public static long getParameterLong(HttpServletRequest request, String param) {
    	return getParameterLong(request, param, 0L);
    }
    
    /**
     * getParameterLong
     * @param request
     * @param param		value
     * @return			
     */
    public static long getParameterLong(HttpServletRequest request, String param, long defaultValue) {
    	
    	long returnValue = 0L;
    	String str = request.getParameter(param);
    	
    	str = str==null?"":str.trim();
    	
    	if( str.equals("") ){
    		returnValue = defaultValue;
    	}else{
    		returnValue = Long.parseLong( str ); 
    	}
    	
    	return returnValue;
    }
    
    /**
     * getParameterBool true ( boolean )
     * @param request
     * @param param
     * @return
     */
    public static boolean getParameterBool(HttpServletRequest request, String param) {
    	
    	boolean returnValue = false;
    	String str = request.getParameter(param);
    	
    	str = str==null?"":str.trim();
    	
    	if( str.equals("true") ){
    		returnValue = true;
    	}
    	
    	return returnValue;
    }
 
    /**
     * getParameterComma true ( boolean )
     * @param request
     * @param param
     * @return String[]
     */
    public static String[] getParameterComma(HttpServletRequest request, String param, String regex) {
    	String value = getParameter(request, param, "");
    	if( value.trim().length() == 0 ){
    		return new String[0];
    	}else{    	
    		return value.split(regex);
    	}
    }
    
    /*
	 *XSS 대응
	 */
	public static String getCleanXSS(String value) {
		if("".equals(StringUtils.trimToEmpty(value)))return "";
		
		
		value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
		value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
		value = value.replaceAll("'", "&#39;");
		value = value.replaceAll("eval\\((.*)\\)", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		
		value = lowerReplaceAll(value,"base64","base_64");
		value = lowerReplaceAll(value,"script","_");
		value = lowerReplaceAll(value,"object","_");
		value = lowerReplaceAll(value,"applet","_");
		value = lowerReplaceAll(value,"embed","_");
		value = lowerReplaceAll(value,"alert","_");
		value = lowerReplaceAll(value,"onclick","_");
		value = lowerReplaceAll(value,"onerror","_");
		value = lowerReplaceAll(value,"iframe","_");
		value = lowerReplaceAll(value,"autofocus","_");
		value = lowerReplaceAll(value,"onfocus","_");
		value = lowerReplaceAll(value,"throw","_");
		value = lowerReplaceAll(value,"document.cookie","_");
		value = lowerReplaceAll(value,"u00","U_00");
		
		value = lowerReplaceAll(value,"form","_");

		value = lowerReplaceAll(value,"select", "q-selec-t");
		value = lowerReplaceAll(value,"insert", "q-inser-t");
		value = lowerReplaceAll(value,"drop", "q-dro-p");
		value = lowerReplaceAll(value,"update", "q-updat-e");
		value = lowerReplaceAll(value,"delete", "q-delet-e");
		value = lowerReplaceAll(value,"join", "q-joi-n");
		value = lowerReplaceAll(value,"from", "q-fro-m");
		value = lowerReplaceAll(value,"where", "q-wher-e");
		
	
		return value;
	}

	
	public static String lowerReplaceAll(String regex, String replacement, String toReplacement){
		if("".equals(StringUtils.trimToEmpty(regex)))return "";
		String retVal="";
		String valueLower= regex.toLowerCase();
		if(valueLower.contains(replacement)){
			int idxReplace = valueLower.indexOf(replacement);
			retVal = regex.substring(0, idxReplace)+toReplacement+regex.substring(idxReplace+replacement.length(), regex.length());	
			if(retVal.contains(replacement)){
				retVal = lowerReplaceAll(retVal,replacement,toReplacement);
			}
			return retVal;
		}
		else{
			return regex;
		}
	}
    
    /*
	 * 태그 제거
	 */
	
	public static String removeHtmlTag(String value) {
		if("".equals(StringUtils.trimToEmpty(value)))return "";
		value = value.replaceAll("&amp;lt;", "<").replaceAll("&amp;gt;", ">");
		value = value.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
		value = value.replaceAll("&amp;#40;", "\\(").replaceAll("&amp;#41;", "\\)");
		value = value.replaceAll("&#40;", "\\(").replaceAll("&#41;", "\\)");
		value = value.replaceAll("&#39;", "'");
		value = value.replaceAll("&nbsp;", " ");
		value = value.replaceAll("q-selec-t", "select");
		value = value.replaceAll("q-inser-t", "insert");
		value = value.replaceAll("q-dro-p", "drop");
		value = value.replaceAll("q-updat-e", "update");
		value = value.replaceAll("q-delet-e", "delete");
		value = value.replaceAll("q-joi-n", "join");
		value = value.replaceAll("q-fro-m", "from");
		value = value.replaceAll("q-wher-e", "where");
		value = value.replaceAll("<!--StartFragment-->", "");
		
	    if(value != null && !value.equals("")){
	    	value = value.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	    }else{
	    	value = "";
	    }
	    return value;
	}
	
	public static String reverseHtmlTag(String value) {
		if("".equals(StringUtils.trimToEmpty(value)))return "";
		value = value.replaceAll("&amp;lt;", "<").replaceAll("&amp;gt;", ">");
		value = value.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
		value = value.replaceAll("&amp;#40;", "\\(").replaceAll("&amp;#41;", "\\)");
		value = value.replaceAll("&#40;", "\\(").replaceAll("&#41;", "\\)");
		value = value.replaceAll("&#39;", "'");
		value = value.replaceAll("&nbsp;", " ");
		value = value.replaceAll("&quot;", "\"");
		value = value.replaceAll("&amp;", "&");
		value = value.replaceAll("q-selec-t", "select");
		value = value.replaceAll("q-inser-t", "insert");
		value = value.replaceAll("q-dro-p", "drop");
		value = value.replaceAll("q-updat-e", "update");
		value = value.replaceAll("q-delet-e", "delete");
		value = value.replaceAll("q-joi-n", "join");
		value = value.replaceAll("q-fro-m", "from");
		value = value.replaceAll("q-wher-e", "where");
		value = value.replaceAll("<!--StartFragment-->", "");
		value = value.replaceAll("&quot;", "[\"]");
		value = value.replaceAll("\\[", "");
		value = value.replaceAll("\\]", "");
		value = value.replaceAll("amp;", "");		
	  
	    return value;
	}

    /*
	 * 모바일 접근인지 판단
	 */	
	public static boolean isMobile(HttpServletRequest request) {
		String strUserAgent = StringUtils.trimToEmpty(request.getHeader("User-Agent")).toUpperCase();
		String deviceMobile = "IPHONE,IPOD,ANDROID,WINDOWS CE,BLACKBERRY,SYMBIAN,WINDOWS PHONE,WEBOS,OPERA MINI,OPERA MOBI,POLARIS,IEMOBILE,LGTELECOM,NOKIA,SONYERICSSON";
		String[] deviceArray = deviceMobile.split(",");
		for(int i=0;i<deviceArray.length;i++){
			if(strUserAgent.indexOf(deviceArray[i]) > -1){
				return true;
			}
		}
		return false;		
	}
	
    /*
	 * 모바일 Iphone 및 Ipad 접근인지 판단
	 */	
	public static boolean isIphoneOrIpod(HttpServletRequest request) {		
		String strUserAgent = StringUtils.trimToEmpty(request.getHeader("User-Agent")).toUpperCase();
		String deviceMobile = "IPHONE,IPOD";
		String[] deviceArray = deviceMobile.split(",");
		for(int i=0;i<deviceArray.length;i++){
			if(strUserAgent.indexOf(deviceArray[i]) > -1){
				return true;
			}
		}
		return false;		
	}
	
    /*
	 * 모바일 Android 접근인지 판단
	 */	
	public static boolean isAndroid(HttpServletRequest request) {
		String strUserAgent = StringUtils.trimToEmpty(request.getHeader("User-Agent")).toUpperCase();
		String deviceMobile = "ANDROID";
		String[] deviceArray = deviceMobile.split(",");
		for(int i=0;i<deviceArray.length;i++){
			if(strUserAgent.indexOf(deviceArray[i]) > -1){
				return true;
			}
		}
		return false;		
	}
	
	public static String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("\\.\\./", ""); // ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", ""); // ..\

		return returnValue;
	}
}
