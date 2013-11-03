// JavaScript Document
function tabSwitch(new_tab, new_content) {  
      
    document.getElementById('content_1').style.display = 'none';  
    document.getElementById('content_2').style.display = 'none';            
    document.getElementById(new_content).style.display = 'block';     
      
  
    document.getElementById('tab_1').className = '';  
    document.getElementById('tab_2').className = '';            
    document.getElementById(new_tab).className = 'active';        
  
}

$(document).ajaxSend(function(e, xhr, options) {
	var sid = $("meta[name='csrf-token']").attr("content");
	xhr.setRequestHeader("X-CSRF-Token", sid);
});

$(document).ajaxStart(function() {
	$("#spinner").show();
}).ajaxStop(function() {
	$("#spinner").hide();
}).ajaxError(function() {
	$("#spinner").hide();
});

(function () {
	if ($('#pro_name').length) {
		$("#spinner").show();
		window.onload = function() { $("#spinner").hide(); }
	}
})();
