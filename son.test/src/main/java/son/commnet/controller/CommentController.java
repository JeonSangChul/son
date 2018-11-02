package son.commnet.controller;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.property.EgovPropertyService;
import son.comment.service.CommentService;
import son.file.service.FileService;

@Controller
public class CommentController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommentController.class);
	
	@Resource(name = "commentService")
	private CommentService commentService;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/**
	 * 게시판 목록조회
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/comment/commentList.do")
	public String list(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		
		return "son/board/list";
	}
	
	@RequestMapping(value="/son/comment/commentSave.do")
	public ModelAndView commentSave(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		commentService.commentSave(paramMap, request);
		
		List<Map<String, Object>> cmtList = commentService.selectCommentList(paramMap); 
		
		ModelAndView modelAndView = new ModelAndView();
		
		modelAndView.addObject("cmtList",cmtList);
		modelAndView.setViewName("son/comment/commentList");
		return modelAndView;
	}
	
	
}
