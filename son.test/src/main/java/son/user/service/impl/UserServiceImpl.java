package son.user.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import son.common.util.ShaEncoder;
import son.user.dao.UserMapper;
import son.user.service.UserService;

/**
 * 
 * @author JeonPc
 *
 */
@Service("userService")
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);
	
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	
	@Resource(name = "shaEncoder")
	private ShaEncoder encoder;
	
	@Override
	public Map<String, Object> slectUserInfo(String username) throws Exception {
		// TODO Auto-generated method stub
		return userMapper.slectUserInfo(username);
	}

	@Override
	public void joinSave(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		
		String email = (String) paramMap.get("email");
		String password = (String) paramMap.get("userPassword");
		paramMap.put("userPassword", encoder.saltEncoding(password, email));
		
		userMapper.joinSave(paramMap);
	}



}

