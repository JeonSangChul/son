package son.board.service.impl;

import java.io.File;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import son.board.dao.BoardMapper;
import son.board.service.BoardService;
import son.common.util.CommonUtils;
import son.file.dao.FileMapper;

/**
 * 
 * @author JeonPc
 *
 */
@Service("boardService")
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardServiceImpl.class);
	
	@Resource(name = "boardMapper")
	private BoardMapper boardMapper;
	
	@Resource(name = "fileMapper")
	private FileMapper fileMapper;
	
	@Override
	public Map<String, Object> selectBoardMasterInfo( 
			Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardMasterInfo(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> selectBoardList(
			Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardList(paramMap);
	}

	@Override
	public int selectBoardListTotCnt(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardListTotCnt(paramMap);
	}

	@Override
	public Map<String, Object> boardInsert(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String,Object>> frmList = new ArrayList<Map<String, Object>>();
		List<Map<String,Object>> fileList = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(paramMap.get("frmData") != null) {
			frmList =  mapper.readValue((String) paramMap.get("frmData"), List.class);
		}
		
		if(paramMap.get("fileData") != null) {
			fileList =  mapper.readValue((String) paramMap.get("fileData"), List.class);
		}
		
		for(Map<String, Object> map : frmList) {
			
			if( (Integer)map.get("count") > 0) {
				fileMapper.fileInsert(map);
			}
			
			for(Map<String, Object> fileMap : fileList) {
				if( "Y".equals(fileMap.get("delYn"))) {
					String filePath = (String) fileMap.get("filePath");
					String storedFileName = (String) fileMap.get("storedFileName");
					File file = new File(filePath+storedFileName);
					
					if(file.exists()) file.delete();
					
					fileMapper.deleteTempFile(fileMap);
				}else {
					fileMap.put("imgId", map.get("imgId"));
					fileMapper.insertFileDetail(fileMap);
					fileMapper.deleteTempFile(fileMap);
				}
			}
			
			map.put("content", CommonUtils.unscript(URLDecoder.decode((String) map.get("content"),"UTF-8")));
			map.put("title", CommonUtils.unscript((String) map.get("title")));
			boardMapper.boardInsert(map);
			
			resultMap.put("idx", map.get("idx"));
		}
		
		return resultMap;
	}

	@Override
	public Map<String, Object> selectBoardDetail(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectBoardDetail(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectImgList(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return boardMapper.selectImgList(paramMap);
	}

	@Override
	public Map<String, Object> boardUpdate(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String,Object>> frmList = new ArrayList<Map<String, Object>>();
		List<Map<String,Object>> newFileList = new ArrayList<Map<String, Object>>();
		List<Map<String,Object>> delFileList = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(paramMap.get("frmData") != null) {
			frmList =  mapper.readValue((String) paramMap.get("frmData"), List.class);
		}
		
		if(paramMap.get("newFileData") != null) {
			newFileList =  mapper.readValue((String) paramMap.get("newFileData"), List.class);
		}
		
		if(paramMap.get("delFileData") != null) {
			delFileList =  mapper.readValue((String) paramMap.get("delFileData"), List.class);
		}
		
		for(Map<String, Object> delFileMap : delFileList) {
			String filePath = (String) delFileMap.get("filePath");
			String storedFileName = (String) delFileMap.get("storedFileName");
			
			File file = new File(filePath+storedFileName);
			
			if(file.exists()) file.delete();
			
			fileMapper.deleteFileDetail(delFileMap);
		}
		
		for(Map<String, Object> map : frmList) {
			if("".equals(String.valueOf(map.get("imgId")))) {
				if( (Integer)map.get("count") > 0) {
					fileMapper.fileInsert(map);
				}
			}
			
			for(Map<String, Object> fileMap : newFileList) {
				if( "Y".equals(fileMap.get("delYn"))) {
					String filePath = (String) fileMap.get("filePath");
					String storedFileName = (String) fileMap.get("storedFileName");
					File file = new File(filePath+storedFileName);
					
					if(file.exists()) file.delete();
					
					fileMapper.deleteTempFile(fileMap);
				}else {
					fileMap.put("imgId", map.get("imgId"));
					fileMapper.insertFileDetail(fileMap);
					fileMapper.deleteTempFile(fileMap);
				}
			}
			
			if(!"".equals(String.valueOf(map.get("imgId")))) {
				int fileCnt = fileMapper.selectFileCnt(map);
				
				if(fileCnt == 0) {
					fileMapper.deleteFile(map);
					map.put("imgId", null);
				}
			}
			
			map.put("content", CommonUtils.unscript(URLDecoder.decode((String) map.get("content"),"UTF-8")));
			map.put("title", CommonUtils.unscript((String) map.get("title")));
			boardMapper.boardUpdate(map);
			
			resultMap.put("idx", map.get("idx"));
		}
		
		return resultMap;
	}


}
