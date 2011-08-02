// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript");
    	$('#spinner').show()
    },
  	'complete': function(){
     $('#spinner').hide()
  },
  	'success': function() {}  
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

$(document).ready(function (){ 

  // add date picker code and synch start & end dates
  var dateFormat = "mm/dd/yy";

  $('#start-date').datepicker({ 
 	  minDate:'-0d',
      dateFormat:dateFormat,
      onSelect: function (dateText, inst) { 
          var nyd = $.datepicker.parseDate(dateFormat,dateText);
          $('#end-date').datepicker("option", 'minDate', nyd ).val($(this).val());
      }, 
      onClose: function () { $(this).focus() } 
  	 }).change(function () {  
  	 	$('#end-date').val($(this).val())
     }); 
  
  $('#end-date').datepicker({ 
      onClose: function () { $(this).focus(); }, 
      dateFormat:dateFormat,
      onSelect: function(dateText, inst){ }                       
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
		$('#gmaps').toggle();
		return false;
	});
	
});

$(function () {  
  	var timerId = 0;
	var qtimerId = 0;

	$('#events').each(function() {
    	timerId = setInterval(function(){
      		$.ajax({ url: "/events/clock", type: "GET", dataType: "script"
    		});
  		}, 60000 );
	});	
	
 	$('#quotes').each(function() {
    	qtimerId = setInterval(function(){
      		$.ajax({ url: "/events/getquote", type: "GET", dataType: "script"
    		});
  		}, 60000 );
	});		
	
	$('.show-item, .manage-item').click(function () {  
 		clearInterval(timerId);
 		clearInterval(qtimerId);
//    	return false;  
  	});   
  	
});

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
    	'width'			:   '560',
    	'height'		: 	'340',
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	600, 
		'speedOut'		:	600, 
		'overlayShow'	:	true
	});	
	
	$('.show_event').bind('ajax:success', function() {
		$("#modalGroup").trigger('click');
	});
});

// add dropdown menu functionality
$(function() {
	$(".dropdown dt a").click(function() {
    	$(".dropdown dd ul").toggle();
	});
});

$(function() {
	$(".dropdown dd ul li a").click(function() {
    	var text = $(this).html();
    	$(".dropdown dt a span").html(text);
    	$(".dropdown dd ul").hide();
	}); 
});

$(document).bind('click', function(e) {
    var $clicked = $(e.target);
    if (! $clicked.parents().hasClass("dropdown"))
        $(".dropdown dd ul").hide();
});

function getSelectedValue(id) {
    return $("#" + id).find("dt a span.value").html();
}
