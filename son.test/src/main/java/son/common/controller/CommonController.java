package son.common.controller;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.WebAttributes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import son.common.service.CommonService;

@Controller
public class CommonController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/main.do")
	public String main(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		List<Map<String, Object>> result = commonService.selectBoardMasterList(paramMap);
		
		model.addAttribute("boardMasterList", result);
		
		return "son/main/main";
	}
	
	@RequestMapping(value="/son/common/denied.do")
	public String denied(Model model, @RequestParam Map<String, Object> paramMap,
						Authentication auth, HttpServletRequest request) throws Exception {
		
		
		return "son/common/denied";
	}
}

