package son.file.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
import son.file.dao.FileMapper;
import son.file.service.FileService;

/**
 * 
 * @author JeonPc
 *
 */
@Service("fileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileServiceImpl.class);
	
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "fileMapper")
	private FileMapper fileMapper;

	@Override
	public Map<String, Object> selectFileInfo(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return fileMapper.selectFileInfo(paramMap);
	}

	@Override
	public List<Map<String, Object>> multiImgUpload(MultipartHttpServletRequest multipartHttpServletRequest,
			HttpSession httpSession) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
		Iterator<String> itr = multipartHttpServletRequest.getFileNames();
		MultipartFile attch;
		int i = 0;
		while (itr.hasNext()) {
			attch = multipartHttpServletRequest.getFile(itr.next());
			Map<String, Object> fileInfo = new HashMap<String, Object>(); 
			String originalName = attch.getOriginalFilename();
			String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
			
			long filesize = attch.getSize(); // 파일크기 
			long limitFileSize = 1*1024*1024; // 1MB 
			
			String path = propertiesService.getString("board.upload.image");
			
			File file = new File(path);
			if(!file.exists()){
				file.mkdir();
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today = formatter.format(new Date());
			String modifyName = today +"-" + UUID.randomUUID().toString().substring(20)+"."+originalNameExtension;
			
			try{
				attch.transferTo(new File(path+modifyName));
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String imageurl = httpSession.getServletContext().getContextPath()+"/son/file/imgView.do?fileName="+modifyName+"&filePath="+path;
			
			fileInfo.put("originFileName", originalName);
			fileInfo.put("storedFileName", modifyName);
			fileInfo.put("fileSize", filesize);
			fileInfo.put("filePath", path);
			fileInfo.put("fileExtsn", originalNameExtension);
			fileInfo.put("fileType", "image");
			fileInfo.put("fileUrl", imageurl);
			fileInfo.put("thumbUrl", imageurl);
			
			fileMapper.tempFileInsert(fileInfo);
			
			//파일 확장자 정보도 수정예쩡
			fileInfo.put("url", imageurl);
			fileInfo.put("imagealign", "C");
			fileInfo.put("_s_url", imageurl);
			fileInfo.put("result", 1);   
			
			fileList.add(fileInfo);
		}
		return fileList;
	}
	
	@Override
	public List<Map<String, Object>> multiFileUpload(MultipartHttpServletRequest multipartHttpServletRequest,
			HttpSession httpSession) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
		Iterator<String> itr = multipartHttpServletRequest.getFileNames();
		MultipartFile attch;
		int i = 0;
		while (itr.hasNext()) {
			attch = multipartHttpServletRequest.getFile(itr.next());
			Map<String, Object> fileInfo = new HashMap<String, Object>(); 
			String originalName = attch.getOriginalFilename();
			String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
			
			long filesize = attch.getSize(); // 파일크기 
			long limitFileSize = 1*1024*1024; // 1MB 
			
			String path = propertiesService.getString("board.upload.file");
			
			File file = new File(path);
			if(!file.exists()){
				file.mkdir();
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today = formatter.format(new Date());
			String modifyName = today +"-" + UUID.randomUUID().toString().substring(20)+"."+originalNameExtension;
			
			try{
				attch.transferTo(new File(path+modifyName));
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String imageurl = httpSession.getServletContext().getContextPath()+"/son/file/imgView.do?fileName="+modifyName+"&filePath="+path;
			
			fileInfo.put("originFileName", originalName);
			fileInfo.put("storedFileName", modifyName);
			fileInfo.put("fileSize", filesize);
			fileInfo.put("filePath", path);
			fileInfo.put("fileExtsn", originalNameExtension);
			fileInfo.put("fileType", "file");
			fileInfo.put("fileUrl", imageurl);
			fileInfo.put("thumbUrl", imageurl);
			
			fileMapper.tempFileInsert(fileInfo);
			
			
			//파일 확장자 정보도 수정예쩡
			fileInfo.put("url", imageurl);
			fileInfo.put("result", 1);   
			
			fileList.add(fileInfo);
		}
		return fileList;
	}

	@Override
	public List<Map<String, Object>> selectFileList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return fileMapper.selectFileList(paramMap);
	}


}

