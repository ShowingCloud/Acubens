function login(){
	$("#popup_dialog div").load ('/home/login-page .tabbed_area-login');
	$('#popup_shadow').css("display", "block");
	$('body').css ("overflow", "hidden");
	
	$('#popup_shadow').click (function() {
			location.href = "/";
		});
	//alert("xxx");
}