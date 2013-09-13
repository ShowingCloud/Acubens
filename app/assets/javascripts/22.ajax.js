function sendmobile() {
	if ($('#mobile').val().length != 11) {
		alert ("请输入您的手机号码");
		return;
	}
	$.ajax ({
		url:		"/membership/verifymobile.json",
		type:		"POST",
		dataType:	"json",
		data:		{ mobile: $('#mobile').val() }
	}).done (function (resp) {
		if (parseInt (resp.status) == 1) {
			if (resp.return_value != null)
				$('#telidentification').val (resp.return_value);
			else
				alert ("验证码已发到您的手机，请注意查收");
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

function sendregister() {
	 if ($('#email').val().length < 10) {
		alert ("请输入您的邮箱");
		return;
	 }else if ($('#mobile').val().length != 11) {
		alert ("请输入您的手机号码");
		return;
	 } else if ($('#password2').val().length < 6) {
		alert ("密码太短了，为了安全起见请选择长一些的密码");
		return;
	 } else if ($('#identification').val() != $('#password2').val()) {
		alert ("两次输入的密码不同");
		return;
	}



	$.ajax ({
		url:		"/membership/register.json",
		type:		"POST",
		dataType:	"json",
		data:		{
			email:			$('#email').val(),
			mobile:			$('#mobile').val(),
			password:		$.sha256 ($('#mobile').val() + $('#password2').val()).slice (0, 23),
			verification:	$('#telidentification').val()
		}
	}).done (function (resp) {
		if (parseInt (resp.status) == 1)
			location.href = "/%E4%BC%9A%E5%91%98%E4%B8%93%E5%8C%BA/%E5%88%9D%E6%AC%A1%E7%99%BB%E5%BD%95";
		else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}

function sendchangepass() {
	 if ($('#mobile').val().length != 11) {
		alert ("请输入您的手机号码");
		return;
	 } else if ($('#password2').val().length < 6) {
		alert ("密码太短了，为了安全起见请选择长一些的密码");
		return;
	 } else if ($('#identification').val() != $('#password2').val()) {
		alert ("两次输入的密码不同");
		return;
	}



	$.ajax ({
		url:		"/membership/register.json",
		type:		"POST",
		dataType:	"json",
		data:		{
			email:			$('#email').val(),
			mobile:			$('#mobile').val(),
			password:		$.sha256 ($('#mobile').val() + $('#password2').val()).slice (0, 23),
			verification:	$('#telidentification').val()
		}
	}).done (function (resp) {
		if (parseInt (resp.status) == 1)
			location.href = "/%E4%BC%9A%E5%91%98%E4%B8%93%E5%8C%BA/%E6%89%BE%E5%9B%9E%E5%AF%86%E7%A0%813%EF%BC%88%E9%87%8D%E7%BD%AE%E6%88%90%E5%8A%9F%EF%BC%89";
		else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("请求失败，请再检查一遍您的输入并稍候再试");
		}
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}



function sendlogin() {
	if ($('#name').val().length == 0) {
		alert ("请输入您的用户名");
		return;
	}else if ($('#password').val().length == 0) {
		alert ("密码太短了");
		return;
	}else if ($('#captcha').val().length == 0) {
		alert ("请输入验证码");
		return;
	} 
	$.ajax ({
		url:		"/membership/login.json",
		type:		"POST",
		dataType:	"json",
		data:		{
			username:		$('#name').val(),
			password:		$.sha256 (
								$.sha256 ($('#name').val() + $('#password').val()).slice (0, 23)
								+ $('#captcha').val()),
			captcha:		$('#captcha').val(),
			captcha_key:	$('#captcha_key').val()
		}
	}).done (function (resp) {
		if (parseInt (resp.status) == 1) {
			location.reload();
		} else if (parseInt (resp.status) == 2){
			$('#loginerr').html ("验证码错误");
		}
			else {
			if (resp.description != null)
				alert (resp.description);
			else
				$('#loginerr').html ("登录信息错误");
		}
	}).fail (function() {
		$('#loginerr').html ("请求发送失败，请稍候再试");
	});
}
