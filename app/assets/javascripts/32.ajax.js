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

		$(document).ready (function() {
	$("#province").html ("<option id=\"prov_0\" value=\"0\">--请选择--</option>");
	$("#city").html ("<option id=\"city_0\" value=\"0\">--请选择--</option>");
	$("#district").html ("<option id=\"area_0\" value=\"0\">--请选择--</option>");

	$.ajax ({
		url:		"/localities/1.json",
		type:		"GET",
		dataType:	"json"
	}).done (function (resp) {
		for (var i = 0; i < resp.children.length; i++) {
			if (resp.children[i].sort == -1)
				continue;
			$("#province").append ("<option id=\"prov_" + resp.children[i].id + "\">"
				+ resp.children[i].name + "</option>");
	   }
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
});

function changeProvince (id) {
	$("#city").html ("<option id=\"city_0\" value=\"0\">--请选择--</option>");
	$("#district").html ("<option id=\"area_0\" value=\"0\">--请选择--</option>");
	
	
	if (id == 0)
		return;
	$.ajax ({
		url:		"/localities/" + id + ".json",
		type:		"GET",
		dataType:	"json"
	}).done (function (resp) {
		for (var i = 0; i < resp.children.length; i++) {
			if (resp.children[i].sort == -1)
				continue;
			$("#city").append ("<option id=\"city_" + resp.children[i].id + "\">"
			   	+ resp.children[i].name + "</option>");
	   }
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}

function changeCity (id) {
	$("#district").html ("<option id=\"area_0\" value=\"0\">--请选择--</option>");
	

	if (id == 0)
		return;
	$.ajax ({
		url:		"/localities/" + id + ".json",
		type:		"GET",
		dataType:	"json"
	}).done (function (resp) {
		for (var i = 0; i < resp.children.length ; i++) {
			if (resp.children[i].sort == -1)
				continue;

			$("#district").append ("<option id=\"area_" + resp.children[i].id + "\">" + resp.children[i].name + "</option>");
		}		
	}).fail (function() {
		alert ("请求发送失败，请稍候再试");
	});
}
