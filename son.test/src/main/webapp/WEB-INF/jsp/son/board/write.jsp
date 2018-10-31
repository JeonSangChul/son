<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link rel="stylesheet" href="/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-2.1.3.js"></script>
<script src="/js/common.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
            // 에디터UI load

		
	 $(document).ready(function (){
		 
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
			         //contentWidth: 1000 
			     }
			
			 };
			
			 //에디터내에 환경설정 적용하기
			 EditorJSLoader.ready(function(Editor) { var editor = new Editor(config); }); 
			 
			 
		 $("#save_button").click(function(){
		        //다음에디터가 포함된 form submit
		        //Editor.save();
			 setForm();
		    })
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
function setForm() {
	var i, input;
	var content = Editor.getContent();
	var fff = Editor.getForm();
			
	var _filedata = new Array();

    var allAttachmentList = Editor.getAttachBox().datalist;
    var nCount = 0;
    var szfileDatas = "";
    var data = {};
    var fileItem = [];
    
    
    for( var j=0, n=allAttachmentList.length; j<n; j++ ){
        var entry = allAttachmentList[j];
        var fileData = {};
        if(entry.type == "file"){
        	
        }else if(entry.type == "image"){
        	fileData.tempFileId = entry.data.tempFileId;
        	fileData.filePath = entry.data.filepath;
        	fileData.storedFileName = entry.data.storedName;
        	fileData.fileExtsn = entry.data.fileExtsn;
        	fileData.fileType = entry.type;
       		/* szfileDatas += "&tempFileId="+entry.data.tempFileId;
       		szfileDatas += "&filePath="+entry.data.filePath;
       		szfileDatas += "&storedFileName="+entry.data.storedName;
       		 */
       		if(entry.deletedMark == true){
       			fileData.delYn ="Y";
        		//szfileDatas += "&delYn=Y";
        	}else if(entry.existStage == false){
        		fileData.delYn ="Y";
        		//szfileDatas += "&delYn=Y";
        	}else{
        		fileData.delYn ="N";
        		//szfileDatas += "&delYn=N";
        		nCount++;
        	}
        }
        fileItem.push(fileData);
        
    }
    
    data["fileData"] = JSON.stringify(fileItem);
    
    var frmData = $("#frm").serializeJSON();
    frmData["content"] = encodeURIComponent(content);
    frmData["count"] = nCount;
    
    data["frmData"] = "["+JSON.stringify(frmData)+"];";
    
    $.ajax({
    	type:"POST",
    	cache:false,
    	async:false,
    	url:"<c:url value='/son/board/save.do'/>",
    	data:data,
    	success : function(data) {
    		location.href = "/son/board/detail.do?idx="+data.idx;
    	},
    	error: function(request,status,e){
    		alert("code:"+request.status+"\n"+"messgae:"+request.responseText+"\n"+"error:"+e);
    		//alert("업로드 중 오류가 발생하였습니다.");
    		
    		return false;
    	}
    });
}


</script>

	<div class="pagetit">
		<h3>글등록</h3>
	</div>
	<div class="inputForm">
	
    <form name="frm" id="frm" method="post" accept-charset="utf-8">
    <dl class="sec">
		<dd><input type="text" class="inp" id="title" name="title" placeholder="제목을 입력해 주세요." /> </dd>
	</dl>
    <dl class="sec">
    <!-- 다음에디터 jsp include.. iframe 으로 변경할까 고민중..
         유튜브 등등 기능 더 추가 하자..
     -->
    <jsp:include page="/daumeditor/editor_frame.jsp"></jsp:include>
    </dl>
    
    <div class="btnArea">
		<button type="button" class="btnW btnCancle">취소하기</button>
		<button type="button" id="save_button" name="save_button">등록하기</button>
	</div>
	</form>
	</div>
