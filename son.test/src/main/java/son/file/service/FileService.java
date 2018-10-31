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
package son.file.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 
 * @author JeonPc
 *
 */
public interface FileService {
	
	public List<Map<String, Object>> multiImgUpload(MultipartHttpServletRequest multipartHttpServletRequest, HttpSession httpSession) throws Exception; 
	
	public Map<String, Object> selectFileInfo(Map<String, Object> paramMap) throws Exception;
}

