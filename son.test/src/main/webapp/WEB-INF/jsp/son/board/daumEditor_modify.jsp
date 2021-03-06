<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link rel="stylesheet" href="/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
            // 에디터UI load

		
	 $(document).ready(function (){
		 
		var attachments = {};
		attachments['image'] = [];
		attachments['file'] = [];
		if('${result!=null}'=='true'){
			
		//jquery로 조회 태어서 할까?? 소스가 지저분한데..
			<c:forEach var="result" items="${fileList}" varStatus="status">
				<c:choose>
					<c:when test="${result.fileType == 'image' }">
						attachments['image'].push({
							'attacher': 'image',
							'data' : {
								'imageurl' : '${result.fileUrl}',
								'filename' : '${result.originFileName}',
								'filesize' : '${result.fileSize}',
								'filepath' : '${result.filePath}',
								'storedName' : '${result.storedFileName}',
								'originalurl' : '${result.fileUrl}',
								'thumburl' : '${result.thumbUrl}',
								'imgId' : '${result.imgId}',
								'imgSrno' : '${result.imgSrno}'
							}
						});
					</c:when>
					<c:when test="${result.fileType == 'file' }">
						attachments['file'].push({
							'attacher': 'file',
							'data': {
								'attachurl' : '${result.fileUrl}',
								'filename' : '${result.originFileName}',
								'filesize' : '${result.fileSize}',
								'filepath' : '${result.filePath}',
								'storedName' : '${result.storedFileName}',
								'imgId' : '${result.imgId}',
								'imgSrno' : '${result.imgSrno}'
							}
						});
					</c:when>
				</c:choose>
			</c:forEach>
			Editor.modify({
				"attachments": function () { /* 저장된 첨부가 있을 경우 배열로 넘김, 위의 부분을 수정하고 아래 부분은 수정없이 사용 */
					var allattachments = [];
					for (var i in attachments) {
						allattachments = allattachments.concat(attachments[i]);
					}
					return allattachments;
				}(),
				"content": '${result.content}' /* 내용 문자열, 주어진 필드(textarea) 엘리먼트 */
			});
		}
		
		var config = {
			     txHost: '', 
			     txPath: '', 
			     txService: 'sample', 
			     txProject: 'sample',
			     initializedId: "", 
			     wrapper: "tx_trex_container",
			     form: "frm", 
			     txIconPath: "/daumeditor/images/icon/editor/", 
			     txDecoPath: "/daumeditor/images/deco/contents/", 
			     canvas: {
			         styles: {
			             color: "#123456", 
			             fontFamily: "굴림", 
			             fontSize: "10pt", 
			             backgroundColor: "#fff", 
			             lineHeight: "1.5", 
			             padding: "8px"
			         },
			         showGuideArea: false
			     },
			     events: {
			         preventUnload: false
			     },
			     sidebar: {
			         attachbox: {
			             show: true,
			             confirmForDeleteAll: true
			         },
			         attacher:{
			         	image:{
			         		features: { left:250, top:65, width:606, height:501 },
			         		popPageUrl: "/son/board/imagePopup.do"
			         	},
			         	file:{ 
			         		boxonly:true,
			         		features:{left:250,top:65,width:400,height:190,scrollbars:0},
			         		popPageUrl:"/son/board/filePopup.do" 
			         	} 
			         }
			     },
			
			     size: {
			         /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
			         contentWidth: 1000 
				}
			
			};
			
			 //에디터내에 환경설정 적용하기
			EditorJSLoader.ready(function(Editor) { var editor = new Editor(config); }); 
			 
			 
		$("#save_button").click(function(){
			setForm();
	    })
	    
	    $("#btnCancle").click(function(){
			var form = document.getElementById("frm")
			form.setAttribute('action', "<c:url value='/son/board/list.do?boardId=${result.boardId}'/>");
			form.submit();
		});
	 });
    //form submit 버튼 클릭

function validForm(editor) {

    var validator = new Trex.Validator();
    var content = editor.getContent();
	var title = $("#title").val();
	
	if (!validator.exists(title)) {
        alert('제목을 입력하세요');
        $("#title").focus();
        return false;
    }
	
    if (!validator.exists(content)) {
        alert('내용을 입력하세요');
        return false;
    }

    return true;

}

//validForm 함수까지 true값을 받으면 이어서 form submit을 시켜주는  setForm함수
function setForm(editor) {
	if(!validForm(Editor)) return;
	if(!confirm("저장 하시겠습니까?")) return;
	
	var i, input;
	var content = Editor.getContent();
	
	var fff = Editor.getForm();
			
	var _filedata = new Array();

    var allAttachmentList = Editor.getAttachBox().datalist;
    var nCount = 0;
    var szfileDatas = "";
    var data = {};
    var newFileItem = [];
    var delFileItem = [];
    
    for( var j=0, n=allAttachmentList.length; j<n; j++ ){
        var entry = allAttachmentList[j];
        
        if(entry.data.tempFileId == undefined || entry.data.tempFileId == "" || entry.data.tempFileId == "NaN") {
        	if(entry.deletedMark == true){
        		var delFileData = {};
        		delFileData.imgId =  entry.data.imgId;
        		delFileData.imgSrno =  entry.data.imgSrno;
        		delFileData.filePath =  entry.data.filepath;
        		delFileData.storedFileName =  entry.data.storedName;
        		delFileItem.push(delFileData);
        	}
        }else{
        	var newFileData = {};
        	newFileData.tempFileId = entry.data.tempFileId;
            newFileData.filePath = entry.data.filepath;
            newFileData.storedFileName = entry.data.storedName;
            newFileData.fileExtsn = entry.data.fileExtsn;
            newFileData.fileType = entry.type;
          		if(entry.deletedMark == true){
          			newFileData.delYn ="Y";
           	}else if(entry.existStage == false){
           		if(entry.type == "file"){
           			newFileData.delYn ="N";
           			nCount++;
           		}else{
           			newFileData.delYn ="Y";	
           		}
           		
           	}else{
           		newFileData.delYn ="N";
           		nCount++;
           	}
          		
        	newFileItem.push(newFileData);
        }
        
        
        
    }
    
    data["newFileData"] = JSON.stringify(newFileItem);
    data["delFileData"] = JSON.stringify(delFileItem);
    
    var frmData = $("#frm").serializeJSON();
    frmData["content"] = encodeURIComponent(content);
    frmData["count"] = nCount;
    frmData["boardId"] = '${result.boardId}';
    frmData["idx"] = '${result.idx}';
    frmData["imgId"] = '${result.imgId}';
    frmData["userId"] = '${result.userId}';
    
    data["frmData"] = "["+JSON.stringify(frmData)+"];";
    $.ajax({
    	type:"POST",
    	cache:false,
    	async:false,
    	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
    	url:"<c:url value='/son/board/update.do'/>",
    	data:data,
    	beforeSend : function(xhr){
    		xhr.setRequestHeader("AJAX-CALL", "true");
    	},
    	success : function(data) {
    		if(data.resultCd == "Success"){
    			var form = document.createElement("form");
        		form.setAttribute('method', "POST");
        		form.setAttribute('action', "<c:url value='/son/board/detail.do'/>"+"?boardId="+data.boardId+"&idx="+data.idx);
        		form.target ="_self";
        		document.body.appendChild(form);
    			form.submit();
    		}else{
    			alert("작업중 오류가 발생했습니다.");
    			return false;
    		}
    	},
    	error: function(request,status,e){
    		alert("작업중 오류가 발생했습니다.");
			return false;
    	}
    });
}


</script>

	<div class="pagetit">
		<h3><c:out value="${master.boardName }" /></h3>
	</div>
	<div class="inputForm">
	
    <form name="frm" id="frm" action="/son/board/save.do" method="post" accept-charset="utf-8">
    <dl class="sec">
		<dd><input type="text" class="inp" id="title" name="title" value='<c:out value="${result.title}" />' placeholder="제목을 입력해 주세요." /> </dd>
	</dl>
    <dl class="sec">
    <jsp:include page="/daumeditor/editor_frame.jsp"></jsp:include>
    </dl>
    
    <div class="btnArea">
		<button type="button" class="btnW btnCancle" id="btnCancle">취소하기</button>
		<button type="button" id="save_button" name="save_button">저장하기</button>
	</div>
	</form>
	</div>

