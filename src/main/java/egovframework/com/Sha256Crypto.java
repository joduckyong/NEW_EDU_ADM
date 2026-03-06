package egovframework.com;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;

import org.apache.commons.codec.binary.Base64;

public class Sha256Crypto {

	/**
	 * Logger for this class
	 */
	public static final int ITERATION_NUMBER = 1000;//
	public static final String INIT_PWD = "1111"; // 초기 비밀번호
	public static byte[] getHash(int iterationNb, String password, byte[] salt) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		digest.reset();
		digest.update(salt);
		byte[] input = digest.digest(password.getBytes("UTF-8"));
		for (int i = 0; i < iterationNb; i++) {
			digest.reset();
			input = digest.digest(input);
		}
		return input;
	}

   /**
    * From a base 64 representation, returns the corresponding byte[].
    * 
    * @param data String The base64 representation
    * @return byte[]
    * @throws IOException
    */
	private static byte[] base64ToByte(String data) throws IOException {
		return Base64.decodeBase64(data);
	}
 
	/**
	 * From a byte[] returns a base 64 representation.
	 * 
	 * @param data byte[]
	 * @return String
	 * @throws IOException
	 */
	private static String byteToBase64(byte[] data){
		return Base64.encodeBase64String(data);
	}

	/**
	 * Encrypt text password to digest, salt.
	 * 
	 * @param inputPassword
	 * @return
	 */
	public static String encryption(String inputPassword) {
	   	String result = "";
	   	
	   	if (inputPassword!=null && inputPassword.length()>0) {
   			try {
				String sDigest = null;
				String sSalt = null;
				
				SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
				
				// Salt generation 64 bits long
				byte[] bSalt = new byte[8];
				random.nextBytes(bSalt);
				
				// Digest computation
				byte[] bDigest = getHash(ITERATION_NUMBER,inputPassword,bSalt);
				sDigest = byteToBase64(bDigest);
				sSalt = byteToBase64(bSalt);

				result = sDigest + "&&"+ sSalt;
				
			} catch (IOException e) {
				System.out.println("Encryption Fail : IOException");
			} catch (NoSuchAlgorithmException e) {
				System.out.println("Encryption Fail : NoSuchAlgorithmException");
			} catch (Exception e) {
				System.out.println("Encryption Fail : Exception");
			}
	   	}
	   	
	   	return result;
	}
   
   /**
    * Authenticates the user with a given password.
    * If password is null then always returns false.
    * 
    * @throws NoSuchAlgorithmException If the algorithm SHA-1 is not supported by the JVM
    */
   public static boolean authenticate(String inputPassword, String sDigestSalt) {
	   boolean result = false;
	   
	   String sDSarray[];
	   String sDigest = "";
	   String sSalt = "";
	   
	   sDSarray = sDigestSalt.split("&&");
	   try {
		   if ( sDSarray.length > 0 ) {
			   sDigest = sDSarray[0];
			   sSalt = sDSarray[1];
		   } 
	   } catch (IndexOutOfBoundsException e) {
		   System.out.println("Authenticate Fail : DigestSalt split");
	   } 
	   
	   if (inputPassword!=null && inputPassword.length()>0) {
		   try {
	           byte[] bDigest = base64ToByte(sDigest);
	           byte[] bSalt = base64ToByte(sSalt);

	           byte[] proposedDigest = getHash(ITERATION_NUMBER, inputPassword, bSalt);
	           result = Arrays.equals(proposedDigest, bDigest);
		       
			} catch (IOException e) {
				System.out.println("Authenticate Fail : IOException");
			} catch (NoSuchAlgorithmException e) {
				System.out.println("Authenticate Fail : NoSuchAlgorithmException");
			} catch (Exception e) {
				System.out.println("Authenticate Fail : Exception");
			}
	   }
	   
	   return result;
   }
   
	/**
	 * run test
	 * 
	 * @param args
	 */
	public static final void main(String[] args) {
		String inputPw = "1111";
		String encryption= Sha256Crypto.encryption(inputPw);
		
		boolean isRightYN = Sha256Crypto.authenticate(inputPw, encryption);
		
		System.out.println(isRightYN);		
		System.out.println(encryption);		
	}

}
