package son.board.controller;
import java.util.ArrayList;
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

import son.board.service.BoardService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class BoardController {
	private static final Logger LOGGER = LoggerFactory.getLogger(BoardController.class);
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
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
	public String detail(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		Map<String, Object> resultMap = boardService.selectBoardDetail(paramMap);
		List<Map<String, Object>> imgList = new ArrayList<Map<String,Object>>();
		model.addAttribute("result", resultMap);
		
		//파일id가 있을시 파일정보조회
		//imgId 컬럼 fileId로 향후 수정
		if(resultMap.get("imgId") != null){
			imgList = boardService.selectImgList(resultMap);
		}
		model.addAttribute("imgList", imgList);
		
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
	public String write(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		return "son/board/write";
	}
	
	/**
	 * 게시판 글 수정 페이지로 이동
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/son/board/modify.do")
	public String modify(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		Map<String, Object> resultMap = boardService.selectBoardDetail(paramMap);
		
		//파일정보 조회 로직 추가 해야함..
		model.addAttribute("result", resultMap);
		return "son/board/modify";
	}
	
	/**
	 * daumEditor 이미지등록 팝업 호출
	 * @param model
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
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
	@RequestMapping(value="/son/board/save.do")
	public String save(ModelMap model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		int idx = boardService.boardInsert(paramMap, request);
		
		return "redirect:/son/board/list.do";
	}
	
}
