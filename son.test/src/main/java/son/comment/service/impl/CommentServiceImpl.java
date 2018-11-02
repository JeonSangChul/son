package son.comment.service.impl;

import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import son.comment.dao.CommentMapper;
import son.comment.service.CommentService;
import son.common.util.CommonUtils;

/**
 * 
 * @author JeonPc
 *
 */
@Service("commentService")
public class CommentServiceImpl extends EgovAbstractServiceImpl implements CommentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommentServiceImpl.class);
	
	@Resource(name = "commentMapper")
	private CommentMapper commentMapper;

	@Override
	public List<Map<String, Object>> selectCommentList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return commentMapper.selectCommentList(paramMap);
	}

	@Override
	public void commentSave(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		paramMap.put("commentContent", CommonUtils.unscript(URLDecoder.decode((String) paramMap.get("commentContent"),"UTF-8")));
		commentMapper.commentSave(paramMap);
		
	}


}
