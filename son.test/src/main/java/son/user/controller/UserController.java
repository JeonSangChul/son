package son.user.controller;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import son.user.service.UserService;

@Controller
public class UserController {
	private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
	
	@Resource(name = "userService")
	private UserService userService;
	
	@RequestMapping(value="/son/user/login.do")
	public String list(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		return "son/user/login";
	}
	
	@RequestMapping(value="/son/user/join.do")
	public String join(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		return "son/user/join";
	}
	
	@RequestMapping(value="/son/user/joinSave.do")
	public String joinSave(ModelMap model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		userService.joinSave(paramMap);
		return "son/user/joinComplete";
	}
	
}
