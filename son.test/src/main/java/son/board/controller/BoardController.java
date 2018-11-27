package son.board.controller;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import son.board.service.BoardService;
import son.comment.service.CommentService;
import son.common.util.CommonUtils;
import son.common.vo.SecurityDto;
import son.file.service.FileService;

@Controller
public class BoardController {
	private static final Logger LOGGER = LoggerFactory.getLogger(BoardController.class);
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@Resource(name = "commentService")
	private CommentService commentService;
	
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/**
	 * 게시판 목록조회
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/board/list.do")
	public String list(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		//나중에 공통으로 
		Map<String, Object> masterMap = boardService.selectBoardMasterInfo(paramMap);
		
		if(masterMap == null) {
			ModelAndView modelAndView = new ModelAndView("forward:/code404.jsp");
			
			throw new ModelAndViewDefiningException(modelAndView);
		}
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		if(paramMap.containsKey("pageIndex") == false){
			paramMap.put("pageIndex","1");
		}
		
		paginationInfo.setCurrentPageNo(Integer.parseInt(paramMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertiesService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		paramMap.put("start",paginationInfo.getFirstRecordIndex());
		paramMap.put("pageSize", paginationInfo.getRecordCountPerPage());
		
		List<Map<String, Object>> resultList = boardService.selectBoardList(paramMap);
		int totCnt = boardService.selectBoardListTotCnt(paramMap);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("resultList", resultList);
		model.addAttribute("searchMap", paramMap);
		model.addAttribute("master", masterMap);
		
		return "son/board/list";
	}
	
	/**
	 * 게시판 상세 조회
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/board/detail.do")
	public String detail(ModelMap model, @RequestParam Map<String, Object> paramMap
						,HttpServletRequest request
						,HttpServletResponse response) throws Exception {
		
		if(CommonUtils.viewCntCookieChk(request, response, paramMap)) boardService.updateViewCnt(paramMap);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		if(paramMap.containsKey("pageIndex") == false){
			paramMap.put("pageIndex","1");
		}
		
		paginationInfo.setCurrentPageNo(Integer.parseInt(paramMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertiesService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertiesService.getInt("pageSize"));
		
		paramMap.put("start",paginationInfo.getFirstRecordIndex());
		paramMap.put("pageSize", paginationInfo.getRecordCountPerPage());
		
		
		
			
		Map<String, Object> masterMap = boardService.selectBoardMasterInfo(paramMap);
		Map<String, Object> resultMap = boardService.selectBoardDetail(paramMap);
		List<Map<String, Object>> imgList = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> cmtList = new ArrayList<Map<String,Object>>();
		
		Map<String, Object> recommedMap = boardService.selectRecommend(paramMap);
		
		model.addAttribute("result", resultMap);
		
		//파일id가 있을시 파일정보조회
		//imgId 컬럼 fileId로 향후 수정
		if(resultMap.get("imgId") != null){
			imgList = boardService.selectImgList(resultMap);
		}
		
		if("Y".equals(masterMap.get("commentYn"))) {
			cmtList = commentService.selectCommentList(paramMap); 
		}
		
		int totCnt = commentService.selectCommentListTotCnt(paramMap);
		
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);
		
		model.addAttribute("imgList", imgList);
		model.addAttribute("cmtList", cmtList);
		model.addAttribute("master", masterMap);
		model.addAttribute("recommedMap", recommedMap);
		return "son/board/detail";
	}
	
	/**
	 * 게시판 글등록 페이지로 이동
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value="/son/board/write.do")
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	public String write(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		Map<String, Object> masterMap = boardService.selectBoardMasterInfo(paramMap);
		model.addAttribute("master", masterMap);
		
		return "son/board/write2";
	}
	
	/**
	 * 게시판 글 수정 페이지로 이동
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/modify.do")
	public String modify(ModelMap model, @RequestParam Map<String, Object> paramMap
				,HttpServletRequest request, HttpServletResponse response
				,Authentication auth) throws Exception {
		Map<String, Object> masterMap = boardService.selectBoardMasterInfo(paramMap);
		Map<String, Object> resultMap = boardService.selectBoardDetail(paramMap);
		
		SecurityDto securityDto = (SecurityDto)auth.getPrincipal();
		
		if(securityDto.getUserId() != Integer.parseInt((String) resultMap.get("userId"))) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "게시물 수정 권한이 없습니다");
		}else {
			List<Map<String, Object>> fileList = new ArrayList<Map<String,Object>>();
			if(resultMap.get("imgId") != null){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("imgId", resultMap.get("imgId"));
				fileList = fileService.selectFileList(map);
			}
			//파일정보 조회 로직 추가 해야함..
			model.addAttribute("result", resultMap);
			model.addAttribute("master", masterMap);
			model.addAttribute("fileList", fileList);
		}
		
		return "son/board/modify";
	}
	
	/**
	 * daumEditor 이미지등록 팝업 호출
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/imagePopup.do")
	public String imagePopup(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		return "son/board/popup/imagePopup";
	}
	
	/**
	 * DaumEditor 파일 등록 팝업 호출
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/filePopup.do")
	public String filePopup(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		return "son/board/popup/filePopup";
	}
	
	/**
	 * 게시판 글저장
	 * @param model
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/save.do")
	public @ResponseBody Map<String, Object> save(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		Map<String, Object> map = boardService.boardInsert(paramMap, request);
		map.put("resultCd", "Success");
		return map;
	}
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/update.do")
	public @ResponseBody Map<String, Object> update(ModelMap model, @RequestParam Map<String, Object> paramMap
			,HttpServletRequest request, HttpServletResponse response
			,Authentication auth) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		SecurityDto securityDto = (SecurityDto)auth.getPrincipal();
		
		if((Integer) paramMap.get("userId") != securityDto.getUserId()) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "게시물 수정 권한이 없습니다");
		}else {
			map = boardService.boardUpdate(paramMap, request);
			map.put("resultCd", "Success");
		}
		return map;
	}
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/delete.do")
	public @ResponseBody Map<String, Object> delete(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		boardService.boardDelete(paramMap);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resultCd", "Success");
		return map;
	}
	
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/recommend.do")
	public @ResponseBody Map<String, Object> recommend(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		SecurityDto securityDto = (SecurityDto)auth.getPrincipal();
		
		paramMap.put("userId", securityDto.getUserId());
		boardService.recommendSave(paramMap);
		paramMap.remove("userId");
		Map<String, Object> map = boardService.selectRecommend(paramMap);
		map.put("resultCd", "Success");
		return map;
	}
	
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/save2.do")
	public @ResponseBody Map<String, Object> save2(ModelMap model, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, Authentication auth) throws Exception {
		
		List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
		
		if(request.getParameterValues("tempFileId") != null) {
			String[] value =request.getParameterValues("tempFileId");
			for (int i = 0; i < value.length; i++) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tempFileId", value[i]);
				fileList.add(map);
			}
		}
		
		Map<String, Object> map = boardService.boardInsert2(paramMap, fileList, auth, request);
		map.put("resultCd", "Success");
		return map;
	}
	
	@Secured({"ROLE_ADMIN","ROLE_USER"})
	@RequestMapping(value="/son/board/update2.do")
	public @ResponseBody Map<String, Object> update2(ModelMap model, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, Authentication auth) throws Exception {
		
		List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> delFileList = new ArrayList<Map<String, Object>>();
		
		if(request.getParameterValues("tempFileId") != null) {
			String[] value =request.getParameterValues("tempFileId");
			for (int i = 0; i < value.length; i++) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tempFileId", value[i]);
				fileList.add(map);
			}
		}
		
		if(request.getParameterValues("imgSrno") != null) {
			String[] value =request.getParameterValues("imgSrno");
			for (int i = 0; i < value.length; i++) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("imgSrno", value[i]);
				delFileList.add(map);
			}
		}
		
		Map<String, Object> map = boardService.boardUpdate2(paramMap, delFileList, fileList, auth, request);
		map.put("resultCd", "Success");
		return map;
	}
	
}
