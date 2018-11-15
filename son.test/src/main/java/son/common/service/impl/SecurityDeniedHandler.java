package son.common.service.impl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import com.sun.star.lang.IllegalArgumentException;

/**
 * 
 * @author JeonPc
 *
 */
public class SecurityDeniedHandler implements AccessDeniedHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityDeniedHandler.class);
	
	private String errorPage;

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		String ajaxHeader = request.getHeader("AJAX-CALL");
		String result ="";
		
		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		response.setCharacterEncoding("UTF-8");
		
		if(ajaxHeader == null) {
			request.setAttribute("errMsg", accessDeniedException.getMessage());
			request.getRequestDispatcher(errorPage).forward(request, response);
		}else {
			result = "{\"result\" : \"fali\", \"message\" : \""+accessDeniedException.getMessage()+"\"}";
		}
		
		response.getWriter().print(result);
		response.getWriter().flush();
		
//		request.setAttribute("errMsg", accessDeniedException.getMessage());
//		request.getRequestDispatcher("/WEB-INF/jsp/son/common/denied.jsp").forward(request, response);
	}
	
	
	public void setErrorPage(String errorPage) {
		this.errorPage = errorPage;
		
	}
}

