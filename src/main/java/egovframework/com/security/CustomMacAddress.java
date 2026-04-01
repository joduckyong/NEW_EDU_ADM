package egovframework.com.security;

import java.applet.Applet;
import java.awt.Graphics;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.StringJoiner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.file.FileUtil;

public class CustomMacAddress extends Applet{
	 
	private static final Logger log = LoggerFactory.getLogger(CustomMacAddress.class);
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void init()
    {

    }


	//This method gets called when the applet is terminated
	//That's when the user goes to another page or exits the browser.
	public void stop()
	{
	    // no actions needed here now.
	}


	//The standard method that you have to use to paint things on screen
	//This overrides the empty Applet method, you can't called it "display" for example.

	public void paint(Graphics g)
	{
	     g.drawString(getMacAddr(),20,20);
	     g.drawString("Hello World",20,40);

	} 
	
//	public String getMacAddr() {
//	    String macAddr= ""; 
//	    InetAddress addr;
//	    try {
//	    	addr = InetAddress.getLocalHost();
//
//	        NetworkInterface dir = NetworkInterface.getByInetAddress(addr);
//	        byte[] dirMac = dir.getHardwareAddress();
//
//	        int count=0;
//	        for (int b:dirMac){
//	        if (b<0) b=256+b;
//	        if (b==0) {
//	            macAddr=macAddr.concat("00"); 
//	        }
//	        if (b>0){
//
//				int a=b/16;
//				if (a==10) macAddr=macAddr.concat("A");
//				else if (a==11) macAddr=macAddr.concat("B");
//				else if (a==12) macAddr=macAddr.concat("C");
//				else if (a==13) macAddr=macAddr.concat("D");
//				else if (a==14) macAddr=macAddr.concat("E");
//				else if (a==15) macAddr=macAddr.concat("F");
//				else macAddr=macAddr.concat(String.valueOf(a));
//				   a = (b%16);
//				if (a==10) macAddr=macAddr.concat("A");
//				else if (a==11) macAddr=macAddr.concat("B");
//				else if (a==12) macAddr=macAddr.concat("C");
//				else if (a==13) macAddr=macAddr.concat("D");
//				else if (a==14) macAddr=macAddr.concat("E");
//				else if (a==15) macAddr=macAddr.concat("F");
//				else macAddr=macAddr.concat(String.valueOf(a));
//	        }
//	        if (count<dirMac.length-1)macAddr=macAddr.concat("-");
//	        	count++;
//	        }
//
//	    } catch (UnknownHostException e) {
//	    	// TODO Auto-generated catch block
//	    	macAddr=e.getMessage();
//	    } catch (SocketException e) {
//	    	// TODO Auto-generated catch block
//	    	macAddr = e.getMessage();
//	    }
//	    return macAddr;
//	    
//	}

	public String getMacAddr() {

	    try {
	        InetAddress addr = InetAddress.getLocalHost();

	        // 1. NetworkInterface null 검증
	        //    가상 NIC, 루프백 등 환경에 따라 null 반환 가능
	        NetworkInterface networkInterface = NetworkInterface.getByInetAddress(addr);
	        if (networkInterface == null) {
	        	log.warn("getMacAddr: NetworkInterface를 찾을 수 없습니다.");
	            return "";
	        }

	        // 2. HardwareAddress null 검증
	        //    가상 인터페이스나 루프백은 MAC 주소가 없어 null 반환 가능
	        byte[] macBytes = networkInterface.getHardwareAddress();
	        if (macBytes == null || macBytes.length == 0) {
	        	log.warn("getMacAddr: MAC 주소를 가져올 수 없습니다.");
	            return "";
	        }

	        // 3. StringJoiner로 구분자("-") 자동 처리 → count 변수 불필요
	        //    String.format("%02X") 로 16진수 변환 직접 구현 제거
	        StringJoiner joiner = new StringJoiner("-");
	        for (byte b : macBytes) {
	            joiner.add(String.format("%02X", b));   // 부호 없는 1바이트 → 2자리 대문자 16진수
	        }

	        return joiner.toString();

	    } catch (UnknownHostException e) {
	        // 4. 예외 메시지를 반환값으로 사용하지 않고 로그 기록 후 빈 문자열 반환
	    	log.error("getMacAddr: 호스트를 확인할 수 없습니다.", e);
	        return "";
	    } catch (SocketException e) {
	    	log.error("getMacAddr: 네트워크 인터페이스 조회 중 오류 발생.", e);
	        return "";
	    }
	}	
}
