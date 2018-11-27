package son.common.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import son.common.vo.SecurityDto;
import son.user.dao.UserMapper;

/**
 * 
 * @author JeonPc
 *
 */
public class SecurityServiceImpl implements UserDetailsService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityServiceImpl.class);
	
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		
		Map<String, Object> user = new HashMap<String, Object>();
		try {
			user = userMapper.slectUserInfo(username);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		UserDetails loginUser = null;
		
		List<GrantedAuthority> gas = new ArrayList<GrantedAuthority>();
		
		gas.add(new SimpleGrantedAuthority(user.get("authority").toString()));
		
		loginUser = new SecurityDto(user.get("username").toString(), 
				user.get("password").toString(), 
				true, true, true, true, gas,
				(Integer) user.get("userId"),
				user.get("name").toString(),
				user.get("email").toString(), 
				user.get("authority").toString());
		return loginUser;
	}

}

