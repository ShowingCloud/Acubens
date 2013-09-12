function sendfirstinfo(){
	if ($('#name').val().length < 2){
		alert("请输入您的名字");
		return;
	}
	
	
	var year = $('#year').val();
		
	var month = $('#month').val();
		
	var day = $('#day').val();


	if ($('input[name="sex"]:checked').length > 0)
		var gender = $('input[name="sex"]:checked').val();
	else {
		alert ("请选择您的性别");
		return;
	}
	
	
	if ($('input[name="magazine"]:checked').length > 0)
	   var magazine = $('input[name="magazine"]:checked').val();
	else {
		alert ("请选择是否订阅电子杂志");
		return;
	}
	
	if ($('#province').val().length > 0)
	   var province = $('#province').val();
	else {
		alert ("请选择您所在的省");
		return;
	}
	if ($('#city').val().length > 0)
	   var city = $('#city').val();
	else {
		alert ("请选择您所在的市");
		return;
	}
	if ($('#district').val().length > 0)
	   var district = $('#district').val();
	else {
		alert ("请选择您所在的区");
		return;
	}	
	
	if($('#address').val().length < 0){
		alert ("请输入您的详细地址");
		return;
	}else if($('#postalcode').val().length <6){
		alert  ("请输入邮政编码");
		return;
	}
	
	var extensionnumber = 0;
		if ($('#extensionnumber').val().length > 0)
		extensionnumber = $('#extensionnumber').val()
	
	var weibo = 0;
		if ($('#weibo').val().length > 0)
		weibo = $('#weibo').val()
	
	var weixin = 0;
		if ($('#weixin').val().length > 0)
		weibo = $('#weixin').val()

	$.ajax({
		url:        "/membership/fillinfo.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			fullname:			$('name').val(),
			birthdate:			year + '-' + month + '-' + day,
			gender:				sex,
			subscription:		magazine,
			phone:				$('areacode').val() + '-' + $('telephone').val() + '-' + $('extensionnumber').val(),
			weibo:				$('weibo').val(),
			wechat:				$('weixin').val(),
		}
	}).done (function (resp) {
		if(parseInt (resp.status) == 1) {
			alert ("感谢您填写完成您的个人信息");
			location.href = "/home/%E8%B0%83%E6%9F%A5%E9%97%AE%E5%8D%B7";               
		}else {
			    if (resp.description != null)
				     alert (resp.description);
			    else
				     alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}

function sendchangeinfo(){
	

	if ($('input[name="magazine"]:checked').length > 0)
	   var magazine = $('input[name="magazine"]:checked').val();
	else {
		alert ("请选择是否订阅电子杂志");
		return;
	}
	
	if ($('#province').val().length > 0)
	   var province = $('#province').val();
	else {
		alert ("请选择您所在的省");
		return;
	}
	if ($('#city').val().length > 0)
	   var city = $('#city').val();
	else {
		alert ("请选择您所在的市");
		return;
	}
	if ($('#district').val().length > 0)
	   var district = $('#district').val();
	else {
		alert ("请选择您所在的区");
		return;
	}	
	
	if($('#address').val().length < 0){
		alert ("请输入您的详细地址");
		return;
	}else if($('#postalcode').val().length <6){
		alert  ("请输入邮政编码");
		return;
	}
	
	var extensionnumber = 0;
		if ($('#extensionnumber').val().length > 0)
		extensionnumber = $('#extensionnumber').val()
	
	var weibo = 0;
		if ($('#weibo').val().length > 0)
		weibo = $('#weibo').val()
	
	var weixin = 0;
		if ($('#weixin').val().length > 0)
		weibo = $('#weixin').val()

	$.ajax({
		url:        "/membership/fillinfo.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			subscription:		magazine,
			phone:				$('areacode').val() + '-' + $('telephone').val() + '-' + $('extensionnumber').val(),
			weibo:				$('weibo').val(),
			wechat:				$('weixin').val(),
		}
	}).done (function (resp) {
		if(parseInt (resp.status) == 1) {
			alert ("感谢您填写完成您的个人信息");
			location.href = "/%E4%BC%9A%E5%91%98%E4%B8%93%E5%8C%BA/%E4%BC%9A%E5%91%98%E4%B8%AD%E5%BF%83/%E4%B8%AA%E4%BA%BA%E4%BF%A1%E6%81%AF";               
		}else {
			    if (resp.description != null)
				     alert (resp.description);
			    else
				     alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}



function getmeminfo() {

	$.ajax ({
		url:		"/membership/getinfo.json",
		type:		"GET",
		dataType:	"json"
	}).done (function (resp) {
		if (parseInt (resp.status) == 1) {
			var ret = resp.return_value;
			var id_year=0;
			var id_month_id=0;
			var id_day=0;
			
            $('#email').html (ret.email == null ? "" : ret.email);
			$('#name').html (ret.name == null ? "" : ret.name);
			/*生日*/
			$('#birthday').html (ret.year+"年"+ret.month+"月"+ret.day+"日");			
			
			if (parseInt (ret.sex_id) == 69)
				$('#gender').html ("男");
			else if (parseInt (ret.sex_id) == 70)
				$('#gender').html ("女");
			if (parseInt (ret.magazine_id) == 0)
				$('#magazine').html ("订阅");
			else if (parseInt (ret.magazine_id) == 1)
				$('#magazine').html ("不订阅");	
			$('#postalcode').html (ret.postalcode == null ? "" : ret.postalcode);
			/*省市区待添加*/	
			
			$('#address').html (ret.address == null ? "" : ret.address);
			$('#mobile').html (ret.mobile == null ? "" : ret.mobile);
			/*固定电话*/
			$('#areacode').html (ret.areacode == null ? "" : ret.areacode);
			$('#telephone').html (ret.telephone == null ? "" : ret.telephone);
			$('#extensionnumber').html (ret.extensionnumber == null ? "" : ret.extensionnumber);
			
			$('#taobao').html (ret.taobao == null ? "" : ret.taobao);
			$('#yihao').html (ret.yihao == null ? "" : ret.yihao);
			$('#weibo').html (ret.weibo == null ? "" : ret.weibo);
			$('#weixin').html (ret.weixin == null ? "" : ret.weixin);
			
							
		} else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}

function sendsurvey(){
	if ($('input[name="type"]:checked').length > 0)
		type = $('input[name="type"]:checked').val();
		
	if ($('input[name="importance"]:checked').length > 0)
		importance = $('input[name="importance"]:checked').val();
		
	if ($('input[name="time"]:checked').length > 0)
		time = $('input[name="time"]:checked').val();
		
	if ($('input[name="cost"]:checked').length > 0)
		cost = $('input[name="cost"]:checked').val();
		
	if ($('input[name="brandimp"]:checked').length > 0)
		brandimp = $('input[name="brandimp"]:checked').val();
	
	if ($('input[name="know"]:checked').length > 0)
		know = $('input[name="know"]:checked').val();
		
	if ($('input[name="activ"]:checked').length > 0)
		activ = $('input[name="activ"]:checked').val();	
		
	if ($('input[name="age"]:checked').length > 0)
		age = $('input[name="age"]:checked').val();	
		
    var problemselect = new Array();
    $("input[@name='problem[]']:checked").each(function() {problemselect.push($(this).val());});
	
	var stepselect = new Array();
    $("input[@name='step[]']:checked").each(function() {stepselect.push($(this).val());});
	
	var mostimpselect = new Array();
    $("input[@name='mostimp[]']:checked").each(function() {mostimpselect.push($(this).val());});	
	
	var reasonselect = new Array();
    $("input[@name='reason[]']:checked").each(function() {reasonselect.push($(this).val());});
	
	var channelselect = new Array();
    $("input[@name='channel[]']:checked").each(function() {channelselect.push($(this).val());});
	
	var affectselect = new Array();
    $("input[@name='affect[]']:checked").each(function() {affectselect.push($(this).val());});
	
	var brandselect = new Array();
    $("input[@name='brand[]']:checked").each(function() {brandselect.push($(this).val());});
	
	var wayselect = new Array();
    $("input[@name='way[]']:checked").each(function() {wayselect.push($(this).val());});
	
	var infoselect = new Array();
    $("input[@name='info[]']:checked").each(function() {infoselect.push($(this).val());});
		
	$.ajax({
		url:        "/skin_survey.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			type:              type,
			importance:        importance,
			time:              time,
			cost:              cost,
			brandimp:          brandimp,
			know:              know,
			activ:             activ,
			age:               age,
			problem:           problem,
			step:              step,
			mostimp:           mostimp,
			reason:            reason,
			channel:           channel,
			affect:            affect,
			brand:             brand,
			way:               way,
			info:              info,
			
		}
	}).done (function (resp) {
		if(parseInt (resp.status) == 1) {
			alert ("感谢您填写完成您的个人信息");
			location.href = "/home/%E9%97%AE%E5%8D%B7%E5%AE%8C%E6%88%90";               
		}else {
			    if (resp.description != null)
				     alert (resp.description);
			    else
				     alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}
