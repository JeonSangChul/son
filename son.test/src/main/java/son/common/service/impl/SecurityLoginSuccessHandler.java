package son.common.service.impl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.util.StringUtils;

import son.common.vo.SecurityDto;

/**
 * 
 * @author JeonPc
 *
 */
public class SecurityLoginSuccessHandler implements AuthenticationSuccessHandler {
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityLoginSuccessHandler.class);
	
	private RequestCache requestCache = new HttpSessionRequestCache();
	
	private String targetUrlParameter;
	
	private String defaultUrl;
	
	private boolean useReferer;
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	public SecurityLoginSuccessHandler() {
		targetUrlParameter = "";
		defaultUrl = "/";
		useReferer = false;
	}
	
	public String getTargetUrlParameter() {
		return targetUrlParameter;
	}
	
	public void setTargetUrlParameter(String targetUrlParameter) {
		this.targetUrlParameter = targetUrlParameter;
	}
	
	public String getDefaultUrl() {
		return defaultUrl;
	}
	
	public void setDefaultUrl(String defaultUrl) {
		this.defaultUrl = defaultUrl;
	}
	
	public boolean getUseReferer() {
		return useReferer;
	}
	
	public void setUseReferer(boolean useReferer) {
		this.useReferer = useReferer;
	}
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		clearAuthenticationAttributes(request);
		
		int intRedirectStrategy = deciedRedirectStrategy(request, response);
		
		SecurityDto securityDto = (SecurityDto)authentication.getPrincipal();
		Cookie cookie = new Cookie("loginId",securityDto.getEmail());
		response.addCookie(cookie);
		
		switch (intRedirectStrategy) {
		case 1:
			useTargetUrl(request, response);
			break;
		case 2:
			useSessionUrl(request, response);
			break;
		case 3:
			useRefererUrl(request, response);
			break;

		default:
			useDefaultUrl(request, response);
			break;
		}
	}
	
	
	private void clearAuthenticationAttributes(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		
		if(session == null) {
			return;
		}
		
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}
	
	private int deciedRedirectStrategy(HttpServletRequest request, HttpServletResponse response) {
		int result = 0;
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if(!"".equals(targetUrlParameter)) {
			String targetUrl = request.getParameter(targetUrlParameter);
			
			if(StringUtils.hasText(targetUrl)) {
				result = 1;
			}else {
				if(savedRequest != null) {
					result = 2;
				}else {
					String refererUrl = request.getHeader("REFERER");
					
					if(useReferer && StringUtils.hasText(refererUrl)) {
						result = 3;
					}else {
						result = 0;
					}
				}
			}
			return result;
		}
		
		if(savedRequest != null) {
			result = 2;
			return result;
		}
		
		String refererUrl = request.getHeader("REFERER");
		
		if(useReferer && StringUtils.hasText(refererUrl)) {
			result = 3;
		}else {
			result = 0;
		}
		
		return result;
				
		
	}
	
	private void useTargetUrl(HttpServletRequest request, HttpServletResponse response) throws IOException {
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if(savedRequest != null) {
			requestCache.removeRequest(request, response);
		}
		
		String targetUrl = request.getParameter(targetUrlParameter);
		redirectStrategy.sendRedirect(request, response, targetUrl);
	}
	
	private void useSessionUrl(HttpServletRequest request, HttpServletResponse response) throws IOException {
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		String targetUrl = savedRequest.getRedirectUrl();
		redirectStrategy.sendRedirect(request, response, targetUrl);
	}
	
	private void useRefererUrl(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String targetUrl = request.getHeader("REFERER");
		redirectStrategy.sendRedirect(request, response, targetUrl);
	}
	
	private void useDefaultUrl(HttpServletRequest request, HttpServletResponse response) throws IOException {
		redirectStrategy.sendRedirect(request, response, defaultUrl);
	}
}
