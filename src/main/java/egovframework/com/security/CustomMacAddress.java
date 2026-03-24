package egovframework.com.security;

import java.applet.Applet;
import java.awt.Graphics;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

public class CustomMacAddress extends Applet{
	 
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
	
	public String getMacAddr() {
	    String macAddr= ""; 
	    InetAddress addr;
	    try {
	    	addr = InetAddress.getLocalHost();

	        NetworkInterface dir = NetworkInterface.getByInetAddress(addr);
	        byte[] dirMac = dir.getHardwareAddress();

	        int count=0;
	        for (int b:dirMac){
	        if (b<0) b=256+b;
	        if (b==0) {
	            macAddr=macAddr.concat("00"); 
	        }
	        if (b>0){

				int a=b/16;
				if (a==10) macAddr=macAddr.concat("A");
				else if (a==11) macAddr=macAddr.concat("B");
				else if (a==12) macAddr=macAddr.concat("C");
				else if (a==13) macAddr=macAddr.concat("D");
				else if (a==14) macAddr=macAddr.concat("E");
				else if (a==15) macAddr=macAddr.concat("F");
				else macAddr=macAddr.concat(String.valueOf(a));
				   a = (b%16);
				if (a==10) macAddr=macAddr.concat("A");
				else if (a==11) macAddr=macAddr.concat("B");
				else if (a==12) macAddr=macAddr.concat("C");
				else if (a==13) macAddr=macAddr.concat("D");
				else if (a==14) macAddr=macAddr.concat("E");
				else if (a==15) macAddr=macAddr.concat("F");
				else macAddr=macAddr.concat(String.valueOf(a));
	        }
	        if (count<dirMac.length-1)macAddr=macAddr.concat("-");
	        	count++;
	        }

	    } catch (UnknownHostException e) {
	    	// TODO Auto-generated catch block
	    	macAddr=e.getMessage();
	    } catch (SocketException e) {
	    	// TODO Auto-generated catch block
	    	macAddr = e.getMessage();
	    }
	    return macAddr;
	    
	}

}
