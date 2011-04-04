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



