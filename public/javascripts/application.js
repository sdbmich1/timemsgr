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

// add date picker code and synch start & end dates
$(document).ready(function (){ 

  var dateFormat = "mm/dd/yy";

  $('#start-date').datepicker({ 
 	  minDate:'-0d',
      dateFormat:dateFormat,
      onSelect: function (dateText, inst) { 
          var nyd = $.datepicker.parseDate(dateFormat,dateText);
          $('#end-date').datepicker("option", 'minDate', nyd ).val($(this).val());
      }, 
      onClose: function () { $(this).focus(); } 
  	}).change(function () {  
  	 	$('#end-date').val($(this).val())
    }); 
  
  $('#end-date').datepicker({ 
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
		$('#gmaps').toggle();
		return false;
	});
	
	// Used to change list of events to display by date range
	$('.select-date').click(function() { 		
		alert(this.getAttribute("data-numdays"));
		var enddate = this.getAttribute("data-numdays");
		$.getScript('/events.js?end_date=' + enddate);
		return false;  
	});
	
});

$(function () {  
  	var timerId = 0;

	$('#events').each(function() {
    	timerId = setInterval(function(){
      		$.ajax({ url: "/events/clock", type: "GET", dataType: "script"
    		});
  		}, 60000 );
	});	
			
//	$('#manage-items, #edit-item, #show-item').click(function () {  
	$('.show-item, .manage-item').click(function () {  
 		clearInterval(timerId);
    	history.pushState(null, "", this.href);  
//    	return false;  
  	});    	
});

$(function () {  
  $(window).bind("popstate", function () {  
    $.getScript(location.href);  
  });  
});


​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​// remove_fields:  Used to delete fields from a given form
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
