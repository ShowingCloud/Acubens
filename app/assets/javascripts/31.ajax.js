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
		extensionnumber = $('#extensionnumber').val();
		
	var weibo = 0;
		if ($('#weibo').val().length > 0)
		weibo = $('#weibo').val();
			
	var weixin = 0;
		if ($('#weixin').val().length > 0)
		weibo = $('#weixin').val();
		
   
	$.ajax({
		url:        "/membership/fillinfo.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			fullname:			$('#name').val(),
			birthdate:			year + '-' + month + '-' + day + 'T00:00:00',
			gender:				gender,
			subscription:		magazine,
			phone:				$('#areacode').val() + '-' + $('#telephone').val() + '-' + $('#extensionnumber').val(),
			weibo:				$('#weibo').val(),
			wechat:				$('#weixin').val(),
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
			phone:				$('#areacode').val() + '-' + $('#telephone').val() + '-' + $('#extensionnumber').val(),
			weibo:				$('#weibo').val(),
			wechat:				$('#weixin').val(),
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
			
			
            $('#email').html (ret.email == null ? "" : ret.email);
			$('#name').html (ret.nick_name == null ? "" : ret.nick_name);
			/*生日*/
			if(ret.year != null && ret.month != null && ret.day != null)
				$('#birthday').html (ret.year+"年"+ret.month+"月"+ret.day+"日");			
			
			if (ret.gender_id == 69)
			{
				$('#gender').html ("男");
				$('input[id="male"]').attr("checked","checked") == true;
			}
			else if (ret.gender_id == 70)
			{
				$('#gender').html ("女");
				$('input[id="female"]').attr("checked","checked") == true;
			}
			if (ret.column1 == "是")
			{
				$('#magazine').html ("订阅");
				$('input[id="subscribe"]').attr("checked","checked") == true;
			}
			else if (ret.column1 == "否")
			{
				$('#magazine').html ("不订阅");
				$('input[id="notsubscribe"]').attr("checked","checked") == true;
			}
			
			/*省市区待添加*/	
			
			$('#address').html (ret.address == null ? "" : ret.address);
			$('#mobile').html (ret.mobile == null ? "" : ret.mobile);
			/*固定电话*/
			var phone = ret.column3 == null ? "" : ret.column3;
			
			var n = phone.split("-");
			//alert(n[0]);
			if(n[1] != null)
				$('#tel').html(n[0]+"-"+n[1]+"-"+n[2]);
			
			$('#taobao').html (ret.column6 == null ? "" : ret.column6);
			$('#yihao').html (ret.column7 == null ? "" : ret.column7);
			$('#weibo').html (ret.column4 == null ? "" : ret.column4);
			$('#weixin').html (ret.column5 == null ? "" : ret.column5);
			
			$('input[id="email"]').val(ret.email == null ? "" : ret.email);
			$('input[id="password"]').val("00000000000000000000");
			$('input[id="identification"]').val("00000000000000000000");
			$('input[id="name"]').val(ret.nick_name == null ? "" : ret.nick_name);
			$('input[id="mobile"]').val(ret.mobile == null ? "" : ret.mobile);
			$('input[id="address"]').val(ret.address == null ? "" : ret.address);
							
		} else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("请求失败，请稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}

function sendsurvey(){
	
	var skin_survey = {
		"user" : "15901940875",
	
		"style": $('input[name="type"]:checked').val(),
		
		"care": $('input[name="importance"]:checked').val(),
		
		"problems" : $("input[name='problem']:checked").val(),
    	
	"time" : $('input[name="time"]:checked').val(),
	
	"procedures" : $("input[name='step']:checked").val(),
       
    "effects" : $("input[name='mostimp']:checked").val(),
    
    "shortcomings" : $("input[name='reason']:checked").val(),
   	
	"cost" : $('input[name="cost"]:checked').val(),
		
	"markets" : $("input[name='channel']:checked").val(),
    
    "factors" : $("input[name='affect']:checked").val(),
    
    "brands" : $("input[name='brand']:checked").val(),
		
	"importance" : $('input[name="brandimp"]:checked').val(),
	
	"source" : $('input[name="know"]:checked').val(),
		
	"ways" : $("input[name='way']:checked").val(),
		
	"infos" : $("input[name='info']:checked").val(),
		
	"offline" : $('input[name="activ"]:checked').val(),
		
	"age" : $('input[name="age"]:checked').val()	}
				
	alert (skin_survey);
	$.ajax({
		url:        "/skin_surveys.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			skin_survey: skin_survey,
			
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


function addaddress(){
	

	if ($('#name').val().length < 2){
		alert("请输入您的名字");
		return;
	}
	
	if ($('#mobile').val().length < 2){
		alert("请输入您的名字");
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

	$.ajax({
		url:        "/membership/addaddr.json",
		type:       "POST",
		dataType:   "json",
		data:       {
			id:			1,
			mobile:		$('#mobile').val(),
			phone:		$('#areacode').val() + '-' + $('#telephone').val() + '-' + $('#extensionnumber').val(),
			name:		$('#name').val(),
			province:	province,
			city:		city, 
			district:	district,
			address: 	$('#address').val(),
		}
	}).done (function (resp) {
		if(parseInt (resp.status) == 1) {
			alert ("感谢您提交地址");       
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


