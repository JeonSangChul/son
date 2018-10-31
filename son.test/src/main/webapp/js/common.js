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