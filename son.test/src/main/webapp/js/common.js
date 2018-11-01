$.fn.serializeJSON = function(field){
	var $this = $(this);
	var obj = {};
	var param ="";
	var disabled = $this.find('[disabled]').prop('disabled',false);
	
	$.each($this.serializeArray() , function(i,o){
		var n = o.name, v = o.value;
		
		v = v.replace(/%/g,'');
		obj[n] = obj[n] === undefined ? v : $.isArray(obj[n]) ? obj[n].concat(v) : [
			obj[n],v
		];
	});
	
	if(field != undefined){
		$.each(field, function(i,o){
			if(obj[o] == undefined){
				obj[o] == "";
			}
		});
	}
	
	disabled.prop('disabled', true);
	return obj;
};

/**
 * inputbox hidden bype으로 객체 생성
 * @param form {obj} 폼객체
 * @param name {String} inputbox의 name
 * @param value {String} inputbox의 value
 * @returns
 */
function createInputByName(form, name, value){
	var input = document.createElement('input');
	input.type = 'hidden';
    input.name = name;
    input.value = value;  // 예에서는 이미지경로만 받아서 사용
    form.appendChild(input);
};