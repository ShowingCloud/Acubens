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
	
			var email = ret.email == null ? "" : ret.email;
			var nickname = ret.nick_name == null ? "" : ret.nick_name;
			var address = ret.address == null ? "" : ret.address;
			var mobile = ret.mobile == null ? "" : ret.mobile;
			var taobao = ret.column6 == null ? "" : ret.column6;
			var yihao = ret.column7 == null ? "" : ret.column7;
			var weibo = ret.column4 == null ? "" : ret.column4;
			var weixin = ret.column5 == null ? "" : ret.column5;
			var password = "00000000000000000000";

			if (ret.gender_id == 69) {
				var gender = "男";
				var gender_str = "male";
			} else if (ret.gender_id == 70) {
				var gender = "女";
				var gender_str = "female";
			} else {
				var gender = "";
				var gender_str = "";
			}

			if (ret.column1 == "是") {
				var subscription = "订阅";
				var subscriptoin_str = "subscribe";
			} else if (ret.column1 == "否") {
				var subscription = "不订阅";
				var subscription_str = "notsubscribe";
			} else {
				var subscription = "";
				var subscription_str = "";
			}

			if (ret.column3 == null)
				var phone_str = "";
			else {
				var phone = ret.column3.split('-');

				if (phone[1] == "")
					phone_str = "";
				else if (phone[0] == "" && phone[2] == "")
					phone_str = phone[1];
				else if (phone[0] == "")
					phone_str = phone[1] + '-' + phone[2];
				else if (phone[2] == "")
					phone_str = phone[0] + '-' + phone[1];
				else
					phone_str = phone[0] + '-' + phone[1] + '-' + phone[2];
			}

			if (ret.birthday_dt == null)
				var birthdate = "";
			else {
				var birthdate = ret.birthday_dt.split('T')[0].split('-');

				if (birthdate[0] == null || birthdate[1] == null || birthdate[2] == null)
					birthdate = "";
				else
					birthdate = birthdate[0]+"年"+birthdate[1]+"月"+birthdate[2]+"日";			
			}

			if ($('#email').length)
				$('#email').html (email);
			if ($('#name').length)
				$('#name').html (nickname);
			if ($('#birthday').length)
				$('#birthday').html (birthdate);
			if ($('#gender').length)
				$('#gender').html (gender);

			if (gender_str != "")
				if ($('input[id="' + gender_str + '"]').length)
					$('input[id="' + gender_str + '"]').attr("checked","checked") == true;

			if ($('#magazine').length)
				$('#magazine').html (subscription);

			if (subscription_str != "")
				if ($('input[id="' + subscription_str + '"]').length)
					$('input[id="' + subscription_str + '"]').attr("checked","checked") == true;

			if ($('#address').length)
				$('#address').html (address);
			if ($('#mobile').length)
				$('#mobile').html (mobile);
			if ($('#tel').length)
				$('#tel').html (phone_str);
			if ($('#taobao').length)
				$('#taobao').html (taobao);
			if ($('#yihao').length)
				$('#yihao').html (yihao);
			if ($('#weibo').length)
				$('#weibo').html (weibo);
			if ($('#weixin').length)
				$('#weixin').html (weixin);

			if ($('input[id="areacode"]').length && phone[0] != "")
				$('input[id="areacode"]').val (phone[0]);
			if ($('input[id="telephone"]').length && phone[1] != "")
				$('input[id="telephone"]').val (phone[1]);
			if ($('input[id="extensionnumber"]').length && phone[2] != "")
				$('input[id="extensionnumber"]').val (phone[2]);

			if ($('input[id="email"]').length)
				$('input[id="email"]').val (email);
			if ($('input[id="password"]').length)
				$('input[id="password"]').val (password);
			if ($('input[id="identification"]').length)
				$('input[id="identification"]').val (password);
			if ($('input[id="name"]').length)
				$('input[id="name"]').val (nickname);
			if ($('input[id="mobile"]').length)
				$('input[id="mobile"]').val (mobile);
			if ($('input[id="address"]').length);
				$('input[id="address"]').val (address);
			if ($('input[id="taobao"]').length);
				$('input[id="taobao"]').val (taobao);
			if ($('input[id="yihao"]').length);
				$('input[id="yihao"]').val (yihao);
			if ($('input[id="weibo"]').length);
				$('input[id="weibo"]').val (weibo);
			if ($('input[id="weixin"]').length);
				$('input[id="weixin"]').val (weixin);

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

		"age" : $('input[name="age"]:checked').val()
	}

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
