function sendmobile() {
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
				alert ("Verification code sent");
		} else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("Unknown error");
		}
	}).fail (function() {
		alert ("Error sending");
	});
}

function sendregister() {
	alert ($('#mobile').val());
	alert ($('#password2').val());
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
			location.href = "/";
		else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("Unknown error");
		}
	}).fail (function() {
		alert ("Error sending");
	});
}

function sendlogin() {
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
		} else {
			if (resp.description != null)
				alert (resp.description);
			else
				alert ("Unknown error");
		}
	}).fail (function() {
		alert ("Error sending");
	});
}
