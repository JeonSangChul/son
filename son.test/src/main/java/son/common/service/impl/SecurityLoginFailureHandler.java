package son.common.service.impl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

/**
 * 
 * @author JeonPc
 *
 */
public class SecurityLoginFailureHandler implements AuthenticationFailureHandler {
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityLoginFailureHandler.class);
	
	private String loginIdName;
	private String loginPasswordName;
	private String loginRedirectName;
	
	
	public SecurityLoginFailureHandler() {
		this.loginIdName = "j_username";
		this.loginPasswordName = "j_password";
		this.loginRedirectName = "loginRedirect";
	}
	
	public String getLoginIdName() {
		return loginIdName;
	}
	public void setLoginIdName(String loginIdName) {
		this.loginIdName = loginIdName;
	}
	
	public String getLoginPasswordName() {
		return loginPasswordName;
	}
	public void setLoginPasswordName(String loginPasswordName) {
		this.loginPasswordName = loginPasswordName;
	}
	public String getLoginRedirectName() {
		return loginRedirectName;
	}
	public void setLoginRedirectName(String loginRedirectName) {
		this.loginRedirectName = loginRedirectName;
	}

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		// TODO Auto-generated method stub
		String loginId = request.getParameter(loginIdName);
		String loginPassword = request.getParameter(loginPasswordName);
		String loginRedirect = request.getParameter(loginRedirectName);
		
		request.setAttribute(loginIdName, loginId);
		request.setAttribute(loginPasswordName, loginPassword);
		request.setAttribute(loginRedirectName, loginRedirect);
		
		
		request.getRequestDispatcher("/son/user/login.do?fail=true").forward(request, response);
	}
	
	
}
