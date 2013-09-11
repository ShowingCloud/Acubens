function login(){
	$("#popup_dialog div").load ('/home/login-page .tabbed_area-login');
	$('#popup_shadow').css("display", "block");
	$('body').css ("overflow", "hidden");
	
	$('#popup_shadow').click (function() {
			location.href = "/";
		});
	//alert("xxx");
}

function register(){
	$("#popup_dialog div").load ('/home/login-page .tabbed_area-login');
	$('#popup_shadow').css("display", "block");
	$('body').css ("overflow", "hidden");
	
	$('#popup_shadow').click (function() {
			location.href = "/";
		});
	$('#content_2').css("display", "block");
	$('#content_1').css("display", "none");
	$("#tab_2").addClass("active");
	
}
