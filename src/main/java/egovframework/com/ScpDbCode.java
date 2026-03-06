package egovframework.com;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.penta.scpdb.ScpDbAgent;
import com.penta.scpdb.ScpDbAgentException;

import egovframework.com.cmm.service.EgovProperties;


@Component
public class ScpDbCode {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScpDbCode.class);
	
    private final String iniFilePath = EgovProperties.getProperty("Globals.iniFilePath");
    
	public String b64Str(String type, String value) throws Exception {
		if(StringUtils.isEmpty(value)) return value;
		
		try {
			
			ScpDbAgent agt = new ScpDbAgent();
			if(type == "E") value = agt.ScpEncB64(iniFilePath, "KEY1", value);
			else if(type == "D") value = agt.ScpDecB64(iniFilePath, "KEY1", value);
			
			return value;
			
		} catch (ScpDbAgentException e1) {
			LOGGER.debug(e1.getMessage());
		    e1.printStackTrace();
	    }
		catch (Exception e) {
			LOGGER.debug(e.getMessage());
			e.printStackTrace();      
		}
		
		return value;
	}
	
}

