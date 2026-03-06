package egovframework.com.utl.fcc.service;

/**
 *
 * 번호유효성체크 에 대한 Util 클래스
 * @author 공통컴포넌트 개발팀 윤성록
 * @since 2009.06.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.06.10  윤성록          최초 생성
 *   2012.02.27  이기하          법인번호 체크로직 수정
 *
 * </pre>
 */
public class EgovNumberCheckUtil {

	 /**
     * <p>XXXXXX - XXXXXXX 형식의 주민번호 앞, 뒤 문자열 2개 입력 받아 유효한 주민번호인지 검사.</p>
     *
     *
     * @param   6자리 주민앞번호 문자열 , 7자리 주민뒷번호 문자열
     * @return  유효한 주민번호인지 여부 (True/False)
     */
    @SuppressWarnings("static-access")
	public static boolean checkJuminNumber(String jumin1, String jumin2) {

    	EgovDateUtil egovDateUtil = new EgovDateUtil();
    	String juminNumber = jumin1 + jumin2;
    	String  IDAdd = "234567892345"; 	

		int count_num = 0;
    	int add_num = 0;
        int total_id = 0;      

        if (juminNumber.length() != 13) return false;	 

       	for (int i = 0; i <12 ; i++){
       		if(juminNumber.charAt(i)< '0' || juminNumber.charAt(i) > '9') return false;		
       		count_num = Character.getNumericValue(juminNumber.charAt(i));
       		add_num = Character.getNumericValue(IDAdd.charAt(i));
        	total_id += count_num * add_num;      
        }

       	if(Character.getNumericValue(juminNumber.charAt(0)) == 0 || Character.getNumericValue(juminNumber.charAt(0)) == 1){
       		if(Character.getNumericValue(juminNumber.charAt(6)) > 4) return false;
       		String temp = "20" + juminNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}else{
       		if(Character.getNumericValue(juminNumber.charAt(6)) > 2) return false;
       		String temp = "19" + juminNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}	

       	if(Character.getNumericValue(juminNumber.charAt(12)) == (11 - (total_id % 11)) % 10) 
        	return true;
        else
        	return false;
    }

    /**
     * <p>XXXXXXXXXXXXX 형식의 13자리 주민번호 1개를 입력 받아 유효한 주민번호인지 검사.</p>
     *
     *
     * @param   13자리 주민번호 문자열
     * @return  유효한 주민번호인지 여부 (True/False)
     */
    public static boolean checkJuminNumber(String jumin) {

    	if(jumin.length() != 13) return false;

        return checkJuminNumber(jumin.substring(0,6), jumin.substring(6,13));	//주민번호
    }

    /**
     * <p>XXXXXX - XXXXXXX 형식의 법인번호 앞, 뒤 문자열 2개 입력 받아 유효한 법인번호인지 검사.</p>
     *
     *
     * @param   6자리 법인앞번호 문자열 , 7자리 법인뒷번호 문자열
     * @return  유효한 법인번호인지 여부 (True/False)
     */
    public static boolean checkBubinNumber(String bubin1, String bubin2) {

    	String bubinNumber = bubin1 + bubin2;

    	int hap = 0;
    	int temp = 1;	

    	if(bubinNumber.length() != 13) return false;	

    	for(int i=0; i < 13; i++){
    		if (bubinNumber.charAt(i) < '0' || bubinNumber.charAt(i) > '9') 
    			return false;
    	}


    	// 2012.02.27  법인번호 체크로직 수정( i<13 -> i<12 )
    	
    	for ( int i=0; i<12; i++){
    		if(temp ==3) temp = 1;
    		hap = hap + (Character.getNumericValue(bubinNumber.charAt(i)) * temp);
    		temp++;
    	}	

    	if ((10 - (hap%10))%10 == Character.getNumericValue(bubinNumber.charAt(12)))
    		return true;
    	else
    		return false;
    	}

    /**
     * <p>XXXXXXXXXXXXX 형식의 13자리 법인번호 1개를 입력 받아 유효한 법인번호인지 검사.</p>
     *
     *
     * @param   13자리 법인번호 문자열
     * @return  유효한 법인번호인지 여부 (True/False)
     */
    public static boolean checkBubinNumber(String bubin) {

    	if(bubin.length() != 13) return false;

    	return checkBubinNumber(bubin.substring(0,6), bubin.substring(6,13));
    	}


    /**
     * <p>XXX - XX - XXXXX 형식의 사업자번호 앞,중간, 뒤 문자열 3개 입력 받아 유효한 사업자번호인지 검사.</p>
     *
     *
     * @param   3자리 사업자앞번호 문자열 , 2자리 사업자중간번호 문자열, 5자리 사업자뒷번호 문자열
     * @return  유효한 사업자번호인지 여부 (True/False)
     */
	public static boolean checkCompNumber(String comp1, String comp2, String comp3) {

		String compNumber = comp1 + comp2 + comp3;

		int hap = 0;
		int temp = 0;
		int check[] = {1,3,7,1,3,7,1,3,5};  

		if(compNumber.length() != 10)    
			return false;

		for(int i=0; i < 9; i++){
			if(compNumber.charAt(i) < '0' || compNumber.charAt(i) > '9')  
				return false;

			hap = hap + (Character.getNumericValue(compNumber.charAt(i)) * check[temp]); 
			temp++;
		}

		hap += (Character.getNumericValue(compNumber.charAt(8))*5)/10;

		if ((10 - (hap%10))%10 == Character.getNumericValue(compNumber.charAt(9)))
			return true;
		else
			return false;
 	}

	 /**
     * <p>XXXXXXXXXX 형식의 10자리 사업자번호 3개를 입력 받아 유효한 사업자번호인지 검사.</p>
     *
     *
     * @param   10자리 사업자번호 문자열
     * @return  유효한 사업자번호인지 여부 (True/False)
     */
	public static boolean checkCompNumber(String comp) {

		if(comp.length() != 10) return false;
		return checkCompNumber(comp.substring(0,3), comp.substring(3,5), comp.substring(5,10));
 	}

	 /**
     * <p>XXXXXX - XXXXXXX 형식의 외국인등록번호 앞, 뒤 문자열 2개 입력 받아 유효한 외국인등록번호인지 검사.</p>
     *
     *
     * @param   6자리 외국인등록앞번호 문자열 , 7자리 외국인등록뒷번호 문자열
     * @return  유효한 외국인등록번호인지 여부 (True/False)
     */
	@SuppressWarnings("static-access")
	public static boolean checkforeignNumber( String foreign1, String foreign2  ) {

		EgovDateUtil egovDateUtil = new EgovDateUtil();
		String foreignNumber = foreign1 + foreign2;
		int check = 0;

		if( foreignNumber.length() != 13 )   
			return false;

		for(int i=0; i < 13; i++){
    		if (foreignNumber.charAt(i) < '0' || foreignNumber.charAt(i) > '9') 
    			return false;
    	}

     	if(Character.getNumericValue(foreignNumber.charAt(0)) == 0 || Character.getNumericValue(foreignNumber.charAt(0)) == 1){
       		if(Character.getNumericValue(foreignNumber.charAt(6)) == 5 && Character.getNumericValue(foreignNumber.charAt(6)) == 6) return false;
       		String temp = "20" + foreignNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}else{
       		if(Character.getNumericValue(foreignNumber.charAt(6)) == 5 && Character.getNumericValue(foreignNumber.charAt(6)) == 6) return false;
       		String temp = "19" + foreignNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}	

		for( int i = 0 ; i < 12 ; i++ ) {
			check += ( ( 9 - i % 8 ) * Character.getNumericValue( foreignNumber.charAt( i ) ) );
		}

		if ( check % 11 == 0 ){
			check = 1;
		}else if ( check % 11==10 ){
			check = 0;
		}else
			check = check % 11;

		if ( check + 2 > 9 ){
			check = check + 2- 10;
		}else check = check+2;	

		if( check == Character.getNumericValue( foreignNumber.charAt( 12 ) ) )
			return true;
		else
			return false;
		}


	 /**
     * <p>XXXXXXXXXXXXX 형식의 13자리 외국인등록번호 1개를 입력 받아 유효한 외국인등록번호인지 검사.</p>
     *
     *
     * @param   13자리 외국인등록번호 문자열
     * @return  유효한 외국인등록번호인지 여부 (True/False)
     */
	public static boolean checkforeignNumber( String foreign  ) {

		if(foreign.length() != 13) return false;
		return checkforeignNumber(foreign.substring(0,6), foreign.substring(6,13));
	}
}


