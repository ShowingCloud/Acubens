function sendfistinfo(){
	if ($('#email').val().length < 10){
		alert ("请输入您的邮箱");
		return;
	}else if ($('#password').val().length < 6){
		alert ("密码至少为6位，请重新输入");
		return;
	}else if ($('#password').val() != $('#identification').val()){
		alert("密码不匹配，请重新输入");
		return;
	}else if ($('#name').val().length < 2){
		alert("请输入您的名字");
		return;
	}
	
	if ($('input[name="year"]:checked').length > 0)
	    var year = $('input[name="year"]:checked').val();
	else {
		alert("请选择您的生日年份");
		return;
	}
	if ($('input[name="month"]:checked').length > 0)
	    var month = $('input[name="month"]:checked').val();
	else {
		alert("请选择您的生日月份");
		return;
	}
	if ($('input[name="day"]:checked').length > 0)
	    var day = $('input[name="day"]:checked').val();
	else {
		alert("请选择您的生日日期");
		return;
	}
	
	if ($('input[name="sex"]:checked').length > 0)
		var gender = $('input[name="sex"]:checked').val();
	else {
		alert ("请选择您的性别");
		return;
	}
	
	if ($('#mobile').val().length < 11){
		alert("请输入您的手机号码");
		return;
	}
	
	if ($('input[name="magazine"]:checked').length > 0)
	   var magazine = $('input[name="magazine"]:checked').val();
	else {
		alert ("请选择是否订阅电子杂志");
		return;
	}
	
	if ($('input[name="province"]:checked').length > 0)
	   var province = $('input[name="province"]:checked').val();
	else {
		alert ("请选择您所在的省");
		return;
	}
	if ($('input[name="city"]:checked').length > 0)
	   var city = $('input[name="city"]:checked').val();
	else {
		alert ("请选择您所在的市");
		return;
	}
	if ($('input[name="district"]:checked').length > 0)
	   var district = $('input[name="district"]:checked').val();
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
		url:        "/memberships/firstlogin.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			email:             $('email').val(),
			password:          $.sha256 ($('#session_username').html() + $('#password').val()),    
			identification:    $('identification').val(),
			name:              $('name').val(),
			year:              year,
			month:             month,
			day:               day,
			sex:               sex,
			mobile:            $('mobile').val(),
			magazine:          magazine,
			province:          province,
			city:              city,
			district:          district,
			address:           $('address').val(),
			postalcode:        $('postalcode').val(),
			areacode:          $('areacode').val(),
			telephone:         $('telephone').val(),
			extensionnumber:   $('extensionnumber').val(),
			weibo:             $('weibo').val(),
			weixin:            $('weixin').val(),
		}
	}).done (function (resp) {
		if(parseInt (resp.status) == 1) {
			alert ("感谢您填写完成您的个人信息");
			location.href = "/";               
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
		url:		"/memberships/memberinfo.json",
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
		url:        "/memberships/survey.json",
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
			location.href = "/";               
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
