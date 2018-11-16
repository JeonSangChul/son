package son.common.util;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

@Component("CommonUtils")
public class CommonUtils {
	/**
	 * XSS 방지 처리
	 * @param data
	 * @return
	 */
	public static String unscript(String data) {
        if (data == null || data.trim().equals("")) {
            return "";
        }
        
        String ret = data;
        
        ret = ret.replaceAll("<(S|s)(C|c)(R|r)(I|i)(P|p)(T|t)", "&lt;script");
        ret = ret.replaceAll("</(S|s)(C|c)(R|r)(I|i)(P|p)(T|t)", "&lt;/script");
        
        ret = ret.replaceAll("<(O|o)(B|b)(J|j)(E|e)(C|c)(T|t)", "&lt;object");
        ret = ret.replaceAll("</(O|o)(B|b)(J|j)(E|e)(C|c)(T|t)", "&lt;/object");
        
        ret = ret.replaceAll("<(A|a)(P|p)(P|p)(L|l)(E|e)(T|t)", "&lt;applet");
        ret = ret.replaceAll("</(A|a)(P|p)(P|p)(L|l)(E|e)(T|t)", "&lt;/applet");
        
        ret = ret.replaceAll("<(E|e)(M|m)(B|b)(E|e)(D|d)", "&lt;embed");
        ret = ret.replaceAll("</(E|e)(M|m)(B|b)(E|e)(D|d)", "&lt;embed");
        
        ret = ret.replaceAll("<(F|f)(O|o)(R|r)(M|m)", "&lt;form");
        ret = ret.replaceAll("</(F|f)(O|o)(R|r)(M|m)", "&lt;form");

        return ret;
    }
	
	public static boolean viewCntCookieChk(HttpServletRequest request
										, HttpServletResponse response
										, Map<String, Object> paramMap) {
		
		
		Cookie cookies[] = request.getCookies();
		Map<String, Object> ckMap = new HashMap<String, Object>();
		
		if(request.getCookies() != null) {
			for(int i=0; i< cookies.length; i++) {
				Cookie obj = cookies[i];
				if("viewCnt".equals(obj.getName())) {
					ckMap.put(obj.getName(), obj.getValue());
				}
				
				
			}
		}
		
		String cookieCnt = (String) ckMap.get("viewCnt");
		String newCookieCnt = "||"+ paramMap.get("boardId")+"||"+ paramMap.get("idx");
		
		if(StringUtils.indexOfIgnoreCase(cookieCnt, newCookieCnt) == -1) {
			Cookie cookie = new Cookie("viewCnt", cookieCnt+newCookieCnt );
			response.addCookie(cookie);
			return true;
		}
		
		return false;
	}
	
	public static String getUserIp(HttpServletRequest request) {
		String userIp = request.getHeader("X-Forwarded-For");
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getHeader("Proxy-Client-IP");
		}
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getHeader("WL-Proxy-Client-IP");
		}
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getHeader("HTTP_CLIENT_IP");
		}
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getHeader("REMOTE_ADDR");
		}
		
		if(userIp ==null || userIp.length() ==0 || userIp.toLowerCase().equals("unknown")) {
			userIp = request.getRemoteAddr();
		}
		
		return userIp;
	}
}
