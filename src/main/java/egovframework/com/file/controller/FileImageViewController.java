package egovframework.com.file.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.utl.fcc.service.EgovFormBasedFileUtil;


@RestController
public class FileImageViewController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(FileImageViewController.class);
	
	@RequestMapping(method = RequestMethod.GET, value = "/image/**")
	public void getFile(HttpServletResponse response, HttpServletRequest request, String fileName) throws Exception{
        String uploadDir = "";
        fileName = request.getRequestURI().replace("/image", "");
        uploadDir = EgovProperties.getProperty("Globals.imageStorePath");
        EgovFormBasedFileUtil.viewFile2(response, uploadDir, fileName);	
	}
}
