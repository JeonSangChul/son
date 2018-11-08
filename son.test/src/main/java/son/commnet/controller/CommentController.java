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
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
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
	public ModelAndView list(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		if(paramMap.containsKey("pageIndex") == false){
			paramMap.put("pageIndex","1");
		}
		
		paginationInfo.setCurrentPageNo(Integer.parseInt(paramMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertiesService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		paramMap.put("start",paginationInfo.getFirstRecordIndex());
		paramMap.put("pageSize", paginationInfo.getRecordCountPerPage());
		
		
		
		List<Map<String, Object>> cmtList = commentService.selectCommentList(paramMap); 
		int totCnt = commentService.selectCommentListTotCnt(paramMap);
		
		ModelAndView modelAndView = new ModelAndView();
		
		paginationInfo.setTotalRecordCount(totCnt);
		modelAndView.addObject("paginationInfo", paginationInfo);
		
		modelAndView.addObject("cmtList",cmtList);
		modelAndView.setViewName("son/comment/commentList");
		
		return modelAndView;
	}
	
	@RequestMapping(value="/son/comment/commentSave.do")
	public ModelAndView commentSave(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		commentService.commentSave(paramMap, request);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		if(paramMap.containsKey("pageIndex") == false){
			paramMap.put("pageIndex","1");
		}
		
		paginationInfo.setCurrentPageNo(Integer.parseInt(paramMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertiesService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		paramMap.put("start",paginationInfo.getFirstRecordIndex());
		paramMap.put("pageSize", paginationInfo.getRecordCountPerPage());
		
		List<Map<String, Object>> cmtList = commentService.selectCommentList(paramMap); 
		int totCnt = commentService.selectCommentListTotCnt(paramMap);
		
		ModelAndView modelAndView = new ModelAndView();
		
		paginationInfo.setTotalRecordCount(totCnt);
		modelAndView.addObject("paginationInfo", paginationInfo);
		
		modelAndView.addObject("cmtList",cmtList);
		modelAndView.setViewName("son/comment/commentList");
		return modelAndView;
	}
	
	
}
