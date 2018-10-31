<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link rel="stylesheet" href="/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>

<script type="text/javascript">
            // 에디터UI load

		
	 $(document).ready(function (){
		 
		//수정을 위해서
		//그냥 write 페이지 하나에서 입력 수정 다 할까??
		//result가 있으면 수정.do 로 태우면 되잖아?? 
		if('${result!=null}'=='true') Editor.modify({'content': '${result.content}'});
		 
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
	        //다음에디터가 포함된 form submit
			Editor.save();
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
function setForm(editor) {
	var i, input;
	var form = editor.getForm();
	var content = editor.getContent();
	
	var textarea = document.createElement("textarea");
	textarea.name = "content";
	textarea.value = content;
	form.createField(textarea);
	
	
	//우선 등록화면에 있는걸 그대로 옴겨옴..
	//추가 및 삭제 여부 등 체크 해서 처리 해야겠지??
	var images = editor.getAttachments('image');
    for (i = 0; i < images.length; i++) {
        // existStage는 현재 본문에 존재하는지 여부
        if (images[i].existStage) {
        	alert('attachment information - image[' + i + '] \r\n' + JSON.stringify(images[i].data));
        	
            // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
            input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'originFileName';
            input.value = images[i].data.filename;  // 예에서는 이미지경로만 받아서 사용
            form.createField(input);
            
            input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'filePath';
            input.value = images[i].data.filepath;  // 예에서는 이미지경로만 받아서 사용
            form.createField(input);
            
            input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'storedName';
            input.value = images[i].data.storedName;  // 예에서는 이미지경로만 받아서 사용
            form.createField(input);
            
            input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'fileSize';
            input.value = images[i].data.filesize;  // 예에서는 이미지경로만 받아서 사용
            
            form.createField(input);
            
            
        }
    }
    return true;
}


</script>

	<div class="pagetit">
		<h3>글등록</h3>
	</div>
	<div class="inputForm">
	
    <form name="frm" id="frm" action="/son/board/save.do" method="post" accept-charset="utf-8">
    <dl class="sec">
		<dd><input type="text" class="inp" id="title" name="title" placeholder="제목을 입력해 주세요." /> </dd>
	</dl>
    <dl class="sec">
    <jsp:include page="/daumeditor/editor_frame.jsp"></jsp:include>
    </dl>
    
    <div class="btnArea">
		<button type="button" class="btnW btnCancle">취소하기</button>
		<button type="button" id="save_button" name="save_button">저장하기</button>
	</div>
	</form>
	</div>

