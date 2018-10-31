package son.file.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import son.file.dao.FileMapper;
import son.file.service.FileService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 
 * @author JeonPc
 *
 */
@Service("fileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileServiceImpl.class);
	
	@Resource(name = "fileMapper")
	private FileMapper fileMapper;

	@Override
	public Map<String, Object> selectFileInfo(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return fileMapper.selectFileInfo(paramMap);
	}


}
