package son.user.controller;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
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
	
	private RequestCache requestCache = new HttpSessionRequestCache();
	
	
	//@PreAuthorize("isAnonymous()")
	@RequestMapping(value="/son/user/login.do")
	public String login(ModelMap model, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String redirectYn = request.getParameter("redirectYn");
		String referer = request.getHeader("REFERER");
		String reuri = request.getRequestURI();
		
		Cookie cookies[] = request.getCookies();
		
		if(request.getCookies() != null) {
			for(int i=0; i< cookies.length; i++) {
				Cookie obj = cookies[i];
				if("loginId".equals(obj.getName())) {
					model.addAttribute("loginId", obj.getValue());
				}
			}
		}
		
		
		//request.get
		if("Y".equals(redirectYn)) {
			
			model.addAttribute("loginRedirect", referer);
			model.addAttribute("useReferer", "1");
		}
		
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
