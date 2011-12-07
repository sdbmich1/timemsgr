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

// add iphone orientation change handler
$(function (){ 
    if (navigator.userAgent.match(/iPhone/i)) {
        $(window).bind('orientationchange', function(event) {
            if (window.orientation == 90 || window.orientation == -90 || window.orientation == 270) {
                $('meta[name="viewport"]').attr('content', 'height=device-width,width=device-height,initial-scale=1.0,maximum-scale=1.0');
            } else {
                $('meta[name="viewport"]').attr('content', 'height=device-height,width=device-width,initial-scale=1.0,maximum-scale=1.0');
            }
        }).trigger('orientationchange');
    }	
}); 

// add spinner to ajax events
$(function (){ 
  var toggleLoading = function() { $("#spinner").toggle() };

  $("#connect_btn, #search_btn")
    .bind("ajax:beforeSend",  toggleLoading)
    .bind("ajax:complete", toggleLoading)
    .bind("ajax:success", function(event, data, status, xhr) {
      $("#response").html(data);
    });
}); 

$(function (){ 

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

$(function (){

  // when the #event type field changes
  $("select[id*=event_type]").live('change',function() {

     // make a POST call and replace the content
     var etype = $(this).val().toLowerCase();
     if(etype == "anniversary" || etype == "birthday")
        {
         $('#end-dt').hide('fast');
         return false;
        }
     else
        {
         $('#end-dt').show('slow');
         return false;
        }
    });
});

$(function(){
    $("#mform label").inFieldLabels();
  });
  
$(function () {
   $("#ev-results .pagination a, #event_form .pagination a").live('click', function () {
         $.getScript(this.href);
         return false;   
   });
});