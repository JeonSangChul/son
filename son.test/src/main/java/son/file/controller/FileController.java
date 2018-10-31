package son.file.controller;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.util.EgovBasicLogger;
import egovframework.com.cmm.util.EgovResourceCloseHelper;
import egovframework.rte.fdl.property.EgovPropertyService;
import son.board.service.BoardService;
import son.file.service.FileService;

@Controller
public class FileController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileController.class);
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	
	/**
	 * 단일 이미지 저장 (DaumEditor 용)
	 * 이미지를 서버에 저장 한 후 (DB X) 해당정보를 이미지 팝업에 넘긴다.
	 * @param model
	 * @param multipartFile
	 * @param request
	 * @param httpSession
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/file/imageUpload.do")
	@ResponseBody
	public Map<String, Object> imageUpload(ModelMap model
											, @RequestParam("imageFile") MultipartFile multipartFile
											, HttpServletRequest request 
											, HttpSession httpSession) throws Exception {
		Map<String, Object> fileInfo = new HashMap<String, Object>(); 
		
		if(multipartFile != null && !(multipartFile.getOriginalFilename().equals(""))) {
			String originalName = multipartFile.getOriginalFilename();
			String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
			
			if( !( (originalNameExtension.equals("jpg")) 
					|| (originalNameExtension.equals("gif")) 
					|| (originalNameExtension.equals("png")) 
					|| (originalNameExtension.equals("bmp")) ) ){
				fileInfo.put("result", -1); 
				return fileInfo; 
			}
			
			
			long filesize = multipartFile.getSize(); // 파일크기 
			long limitFileSize = 1*1024*1024; // 1MB 
			/*
			if(limitFileSize < filesize){ // 제한보다 파일크기가 클 경우 
				fileInfo.put("result", -2); 
				return fileInfo;
			}*/
			
			String path = propertiesService.getString("board.upload.image");
			
			File file = new File(path);
			if(!file.exists()){
				file.mkdir();
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today = formatter.format(new Date());
			String modifyName = today +"-" + UUID.randomUUID().toString().substring(20)+"."+originalNameExtension;
			
			try{
				multipartFile.transferTo(new File(path+modifyName));
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String imageurl = httpSession.getServletContext().getContextPath()+"/son/file/imgView.do?fileName="+modifyName+"&filePath="+path;
			
			fileInfo.put("imageurl", imageurl);
			fileInfo.put("filename", modifyName);
			fileInfo.put("filesize", filesize);
			fileInfo.put("imagealign", "C");
			fileInfo.put("originalurl", imageurl);
			fileInfo.put("thumburl", imageurl);
			fileInfo.put("result", 1);   

		}
		return fileInfo;
	}
	
	/**
	 * 다중이미지 저장
	 * 서버에이미지를 저장 한 후 (DB X) 이미지등록 팝업에 이미지 정보 저장
	 * @param model
	 * @param multipartHttpServletRequest
	 * @param httpSession
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/file/multiImgUpload.do")
	@ResponseBody
	public Map<String, Object> multiImgUpload(ModelMap model
									, MultipartHttpServletRequest multipartHttpServletRequest
									, HttpSession httpSession) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> fileList = fileService.multiImgUpload(multipartHttpServletRequest, httpSession);
		
		resultMap.put("files", fileList);
		return resultMap;
	}
			
	
	/**
	 * 단일 파일 업로드
	 * DaumEdior 에서 등록한 파일정보 서버에 저장 (DB X) 후 파일정보를 파일등록 팝업에 넘겨줌
	 * @param model
	 * @param multipartFile
	 * @param request
	 * @param httpSession
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/file/fileUpload.do")
	@ResponseBody
	public Map<String, Object> fileUpload(ModelMap model
											, @RequestParam("uploadFile") MultipartFile multipartFile
											, HttpServletRequest request 
											, HttpSession httpSession) throws Exception {
		Map<String, Object> fileInfo = new HashMap<String, Object>(); 
		
		if(multipartFile != null && !(multipartFile.getOriginalFilename().equals(""))) {
			
			
			long filesize = multipartFile.getSize(); // 파일크기 
			long limitFileSize = 5*1024*1024; // 1MB 
			
			String path = propertiesService.getString("board.upload.file");
			File file = new File(path);
			if(!file.exists()){
				file.mkdir();
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today = formatter.format(new Date());
			String originalName = multipartFile.getOriginalFilename();
			String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
			String modifyName = today +"-" + UUID.randomUUID().toString().substring(20)+"."+originalNameExtension;
			
			try{
				multipartFile.transferTo(new File(path+modifyName));
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String fileMime = multipartFile.getContentType();
			String attachurl = httpSession.getServletContext().getContextPath()+"/son/file/imgView.do?fileName="+modifyName+"&filePath="+path;
			fileInfo.put("attachurl", attachurl);
			fileInfo.put("filemime", fileMime);
			fileInfo.put("filename", modifyName);
			fileInfo.put("filesize", filesize);
			fileInfo.put("result", 1);   

		}
		return fileInfo;
	}
	//다중 파일 업로드 추가 해야징..
	
	/**
	 * 이미지View
	 * 서버에 저장된 이미지를 화면에 바로 보여 주기 위한 용도.
	 * filename 과 filepath를 합쳐서.. 파라메터 하나로 변경할까?
	 * DB 설렉트해서 뿌려주는 방법은..? 부하 생각하자..
	 * @param fileName
	 * @param filePath
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value="/son/file/imgView.do")
	public void imageView(@RequestParam(value="fileName", required=false) String fileName,
							@RequestParam(value="filePath", required=false) String filePath,
							HttpServletResponse response,
							Model model) throws Exception {
		File file = null;
		FileInputStream fis = null;
		
		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;
		try{
			file = new File(filePath+fileName);
			fis = new FileInputStream(file);
			
			in = new BufferedInputStream(fis);
			bStream = new ByteArrayOutputStream();
			
			int imgByte;
			while ((imgByte = in.read()) != -1) {
				bStream.write(imgByte);
			}
			
			//jpeg가 아니라 확장자(타입)을 받아서 변경하자.. 우선 귀찮으니 jpeg로...
			response.setHeader("Content-Type", "image/jpeg");
			response.setContentLength(bStream.size());
			
			bStream.writeTo(response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}finally{
			if (bStream != null) {
				try{
					bStream.close();
				}catch (Exception ignore){
					LOGGER.debug("IGNORE: " + ignore.getMessage());
				}
			}
			
			if(in != null){
				try{
					in.close();
				}catch (Exception ignore){
					LOGGER.debug("IGNORE: " + ignore.getMessage());
				}
			}
			
			if(fis != null){
				try{
					fis.close();
				}catch (Exception ignore){
					LOGGER.debug("IGNORE: " + ignore.getMessage());
				}
			}
		}
	}
	
	/**
	 * 첨부파일 다운로드
	 * @param paramMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value="/son/file/fileDown.do")
	public void fileDown(@RequestParam Map<String, Object> paramMap, 
							HttpServletRequest request, 
							HttpServletResponse response,
							Model model) throws Exception {
		
		Map<String, Object> fileMap = fileService.selectFileInfo(paramMap);
		
		if(fileMap != null){
			String filePath = (String) fileMap.get("filePath");
			String storedFileName = (String) fileMap.get("storedFileName");
			String originFileName = (String) fileMap.get("originFileName");
			File file = new File(filePath+storedFileName);
			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);
			
			//Disposition 지정하자..
			setDisposition(originFileName, request, response);
			BufferedInputStream in = null;
			
			BufferedOutputStream out = null;

			try {
				in = new BufferedInputStream(new FileInputStream(file));
				out = new BufferedOutputStream(response.getOutputStream());

				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				// 다음 Exception 무시 처리
				// Connection reset by peer: socket write error
				EgovBasicLogger.ignore("IO Exception", ex);
			} finally {
				EgovResourceCloseHelper.close(in, out);
			}
		}else{
			response.setContentType("application/x-msdownload");

			PrintWriter printwriter = response.getWriter();
			
			printwriter.println("<html>");
			printwriter.println("<script>alert('Could not get file'); history.go(-1);</script>");
			printwriter.println("</html>");
			
			printwriter.flush();
			printwriter.close();
		}
		
		
	}
	
	/**
	 * Disposition 지정
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
	/**
	 * 브라우저 구분 열기
	 * @param request
	 * @return
	 */
	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) {
			return "MSIE";
		} else if (header.indexOf("Trident") > -1) { // IE11 문자열 깨짐 방지
			return "Trident";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		}
		return "Firefox";
	}
}
