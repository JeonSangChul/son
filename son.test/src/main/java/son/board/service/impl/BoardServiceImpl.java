package son.board.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import son.board.dao.BoardMapper;
import son.board.service.BoardService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

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
	public int boardInsert(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		
		
		String[] storedName = request.getParameterValues("storedName");
		String[] filePath = request.getParameterValues("filePath");
		String[] originFileName = request.getParameterValues("originFileName");
		String[] fileSize = request.getParameterValues("fileSize");
		
		if(storedName != null){
			
			boardMapper.boardImgInsert(paramMap);
			
			for(int i=0; i<storedName.length; i++){
				Map<String, Object> imgMap = new HashMap<String, Object>();
				imgMap.put("imgId", paramMap.get("imgId"));
				imgMap.put("originFileName",originFileName[i]);
				imgMap.put("storedName", storedName[i]);
				imgMap.put("filePath", filePath[i]);
				imgMap.put("fileSize", fileSize[i]);
				System.out.println(imgMap);
				boardMapper.boardImgDetailInsert(imgMap);
			}
			
			
		}
		
		int idx = boardMapper.boardInsert(paramMap);
		
		System.out.println(paramMap);
		
		return idx;
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


}
