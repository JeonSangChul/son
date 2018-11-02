/*
 * Copyright 2008-2009 the original author or authors.
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
package son.board.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * 
 * @author JeonPc
 *
 */
public interface BoardService {
	
	public Map<String, Object> selectBoardMasterInfo(Map<String, Object> paramMap) throws Exception;
	
	public List<Map<String, Object>> selectBoardList(Map<String, Object> paramMap) throws Exception;
	
	public int selectBoardListTotCnt(Map<String, Object> paramMap) throws Exception;
	
	public Map<String, Object> boardInsert(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	public Map<String, Object> selectBoardDetail(Map<String, Object> paramMap) throws Exception;
	
	public List<Map<String, Object>> selectImgList(Map<String, Object> paramMap) throws Exception;
	
	public Map<String, Object> boardUpdate(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	public void boardDelete(Map<String, Object> paramMap) throws Exception;
}

