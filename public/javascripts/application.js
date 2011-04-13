// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
}); 

$('.submittable').live('change', function() {
  $(this).parents('form:first').submit();
  return false;
});

$(".password_test").passStrength({
  password: "#password"
});

$(document).ready(function(){  
$('#alert').live('click', (function () {  
alert('Hello, world!');  
return false;  
})) ; 
});  

	// remove_fields:  Used to delete fields from a given form
	function remove_fields(link) {  
        $(link).prev("input[type=hidden]").val("1");  
        $(link).closest(".fields").hide();  
    }  
     
    // add_fields:  Used to add fields to a given form  
    function add_fields(link, association, content) {  
        var new_id = new Date().getTime();  
        var regexp = new RegExp("new_" + association, "g");  
        $(link).before(content.replace(regexp, new_id));  
    }  

