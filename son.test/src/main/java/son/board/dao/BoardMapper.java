/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package son.board.dao;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 
 * @author JeonPc
 *
 */
@Mapper("boardMapper")
public interface BoardMapper {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBoardList(Map<String, Object> paramMap) throws Exception;
	
	public int selectBoardListTotCnt(Map<String, Object> paramMap) throws Exception;
	
	public int boardInsert(Map<String, Object> paramMap) throws Exception;
	
	public Map<String, Object> selectBoardDetail(Map<String, Object> paramMap) throws Exception;
	
	public List<Map<String, Object>> selectImgList(Map<String, Object> paramMap) throws Exception;


}
