// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
}); 

$('.submittable').live('change', function() {
  $(this).parents('form:first').submit();
  return false;
});

// add time picker
$(document).ready(function (){ 

	$('#start-time').timepicker({
		ampm: true,
		stepMinute: 15
	});
	
	$('#end-time').timepicker({
		ampm: true,
		stepMinute: 15
	});
}); 

// add date picker code and synch start & end dates
$(document).ready(function (){ 

  var dateFormat = "mm/dd/yy";

  $('#start-date').datepicker({ 
 	  minDate:'-0d',
  	  showOn: 'button', 
      buttonImage: '../images/calendar_icon.jpg', 
      buttonImageOnly: true, 
      dateFormat:dateFormat,
      onSelect: function (dateText, inst) { 
          var nyd = $.datepicker.parseDate(dateFormat,dateText);
          $('#end-date').datepicker("option", 'minDate', nyd );
      }, 
      onClose: function () { $(this).focus(); } 
  	}).change(function () {  
  	 	$('#end-date').val($(this).val())
    }); 
  
  $('#end-date').datepicker({ showOn: 'button', 
      buttonImage: '../images/calendar_icon.jpg', 
      buttonImageOnly: true, 
      onClose: function () { $(this).focus(); }, 
      dateFormat:dateFormat,
      onSelect: function(dateText, inst){

    }                       
  }); 
  
  	
  // toggle divs for adding type of event	
  $(":radio[name='activity_type']").change(function(){
  	var newVal = $(":radio[name='activity_type']:checked").val(); 
  	var url = '/get_drop_down_options?radio_val=' + newVal;
  
	//  $("#event_event_type option").remove();
   $.get(url, function(data) {
	$("#eventtype").html(data);
   });
   
   if (newVal == "Activity") {
     	$("#life_event").hide();
     }
   else {
     	$("#life_event").show("fast");
     }
     
  });

	// toggle google map
	$('.showmap').click(function() {
		$('#gmaps').show();
		return false;
	});

});

$(document).ready(function (){
	$.ajaxStart(function(){
    	$("#ajaxSpinnerImage").show();
	})
	$.ajaxStop(function(){
    	$("#ajaxSpinnerImage").hide();
	});
});
​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​
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

function updateEvents() {  
      var num_days = $('#select-date').attr('data-numdays');  
      $.getScript('/events.js?end_date=' + num_days )
      .ajaxStart(function() {
        $("#ajaxSpinnerImage").show();
    })
    .ajaxStop(function() {
        $("#ajaxSpinnerImage").hide();
    });

}  
        
// add fancy box
$(document).ready(function() {

	/* This is basic - uses default settings */
	
	$("a#single_image").fancybox();
	
	/* Using custom settings */
	
	$("a#inline").fancybox({
		'hideOnContentClick': true
	});

	/* Apply fancybox to multiple items */
	
	$("a#modalGroup").fancybox({
    	'width'			:   '200',
    	'height'		: 	'200',
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	600, 
		'speedOut'		:	400, 
		'overlayShow'	:	true
	});	
});

$(document).ready(function() {
	$('a#popopen').live('click', function(e) {
 		$("#modalGroup").trigger('click'); 
 
  	}); 
  
  	$('a#popstart').bind("ajax:success", function(data, status, xhr) {
	      $().fancybox({
 				'transitionIn'	:	'elastic',
				'transitionOut'	:	'elastic'
           });
	  });
  
	$('.show_event').bind('ajax:success', function() {
		$("#modalGroup").trigger('click');
	});

 });