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

function toggleLoading () { 
	$("#spinner").toggle(); 
}

// add spinner to ajax events
$(function (){ 
  $("#connect_btn, #search_btn, #notify_form, #schedule_btn, #import_form, #rel_id, #chlist_btn, #edit_btn, #subscribe_btn, #unsub_btn, #remove_btn")
    .bind("ajax:beforeSend", toggleLoading)
    .bind("ajax:complete", toggleLoading)
    .bind("ajax:success", function(event, data, status, xhr) {
      $("#response").html(data);
    });
}); 

$(function() {
	$("#schedule_btn, #subscribe_btn").click(function() {
    $.bind("ajax:beforeSend", toggleLoading)
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
   $("#ev-results .pagination a, #event_form .pagination a, #sub-list .pagination a,#channel_form .pagination a, #notice_list .pagination a, #pres-list .pagination a, #sess-list .pagination a").live('click', function () {
         $.getScript(this.href);
         return false;   
   });
});

$(function () {
   $("#submit-btn").live('click', function () {
   	$.fancybox.close();
   });
});

$(function () {
  $(".notice_id").live('click',function() {
    $.getScript('/events/notice.js');
  })
});

$(function () {
  $(".channel_menu").live('click',function() {
    var intid = $(this).attr("data-intid");
    var loc = $('#location_id').val();
    
    $('ul.menu li ul li a').css('background-color', '#ccc');
	$(this).css('background-color', '#C2E1EF');
    $.getScript('/select.js?location=' + loc + "&interest_id=" + intid);
  })
});


// toggle navigation menu background color to denote active selection
$(function (){
   $(".all_btn, .prv_btn, .soc_btn, .ext_btn, .pend_btn, .def_btn, .nav_btn").live('click', function () {
	 $('ul.menu li a').css('background-color', '#0C6FCB');
	 $(this).css('background-color', '#f08103');
	})
});

$(function (){

  // when the #location id field changes
  $("select[id*=location_id]").live('change',function() {

     	// grab the selected location
     	var loc = $(this).val().toLowerCase();

     	// check if interest is selected to call appropriate script
     	if ( $('#interest_id').length != 0 )
     	{
     		var intid = $('#interest_id').val();
     		var url = '/select.js?location=' + loc + "&interest_id=" + intid;
     	}
     	else
     	{
 			// check which dom is current to call appropriate url
 			if ( $('.chanlist').length != 0 )
 				{
 					var url = '/categories.js?location=' + loc;
 					var Slider = false;
 				}
 			else
 				{
 					var url = '/events.js?location=' + loc;
 					var Slider = true;
 				}    		
     	}
     	
		$.ajax({
  			url: url,
  			dataType: 'script',
  			'beforeSend': function() {
  				toggleLoading();
  			},
  			'complete':  function() {  				
  				toggleLoading();
    		},
  			'success': function() {
  				if (Slider)
  					{ 
  					toggleLoading();	
  					reset_slider();
  						}
  			}  
		});
		return false;       
  })
});

// when the #start time field changes
$(function (){
  $("#start-time").live('change',function() {
     $("#end-time").val($(this).val());
  });
});