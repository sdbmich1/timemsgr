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

// Used to check password strength
$(function(){
	$('.password').pstrength();
});

jQuery.event.add(window, "load", resizeFrame);
jQuery.event.add(window, "resize", resizeFrame);

function resizeFrame() 
{
    var h = $(window).height();
    var w = $(window).width();
        $(".left-nav").css('left',(w < 1024 || h < 768) ? 150 : 350 );
        $(".right-nav").css('right',(w < 1024 || h < 768) ? 50 : 200 );
		$(".push").css('margin-top', function() {
	  		   var c = $(".container").height();
			   return c + 20;
		});
}
