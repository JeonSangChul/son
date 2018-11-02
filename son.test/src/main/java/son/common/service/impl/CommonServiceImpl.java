package son.common.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import son.common.dao.CommonMapper;
import son.common.service.CommonService;

/**
 * 
 * @author JeonPc
 *
 */
@Service("commonService")
public class CommonServiceImpl extends EgovAbstractServiceImpl implements CommonService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonServiceImpl.class);
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<Map<String, Object>> selectBoardMasterList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return commonMapper.selectBoardMasterList(paramMap);
	}
	
	


}
