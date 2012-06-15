// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript");
    	$('#spinner').show('fast')
    },
  	'complete': function(){
     $('#spinner').hide('slow')
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
      $("#response").html(data).toggleLoading();
    });
}); 

$(function (){ 
	
  // add date picker code and synch start & end dates
  if ( $('#start-date').length != 0 ) {

  	var dateFormat = "mm/dd/yy";
	
	$('#start-date').datepicker({ 
 	  minDate:'-0d',
      dateFormat:dateFormat,
      buttonImage: '../images/date_picker1.gif', 
      buttonImageOnly: true, 
      showOn: 'button',
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
 	  minDate: '-0d',
      dateFormat:dateFormat,
      buttonImage: '../images/date_picker1.gif', 
      buttonImageOnly: true, 
      showOn: 'button'                       
    }); 
  }  	
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
  if ( $('.password').length != 0 ) {
	$('.password').pstrength();
  }
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
  if ( $('#mform label').length != 0 ) {
    $("#mform label").inFieldLabels();
  }
});
  
$(function () {
   $("#ev-results .pagination a, #event_form .pagination a, #sub-list .pagination a,#channel_form .pagination a, #notice_list .pagination a, #pres-list .pagination a, #sess-list .pagination a").live('click', function () {
         $.getScript(this.href);
         return false;   
   });
});

// close light box pop-up window
$(function () {
   $("#submit-btn, #notice-id").live('click', function () {
   	$.fancybox.close();
   });
});

$(function () {
  $(".notice_id").live('click',function() {
    $.getScript('/events/notice.js');
  })
});

// process channel selection changes
$(function () {
  $(".channel_menu").live('click',function() {
    var intid = $(this).attr("data-intid");
    var loc = $('#location_id').val();
    var url = '/select.js?location=' + loc + "&interest_id=" + intid
    
    $('ul.menu li ul li a').css('background-color', '#ccc');
	$(this).css('background-color', '#C2E1EF');
	
    process_url(url);    
  })
});


// toggle navigation menu background color to denote active selection
$(function (){
   $(".all_btn, .prv_btn, .soc_btn, .ext_btn, .pend_btn, .def_btn, .nav_btn").live('click', function () {
	 $('ul.menu li a').css('background-color', '#0C6FCB');
	 $(this).css('background-color', '#f08103');
	})
});

// capitalize first letter
function capitalize(string)
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// toggle city name in dropdown list where appropriate
$(function (){
   $("#search_btn").live('click', function () {
   	 if ($("input[name='search']").length != 0) {
   	 	var srchText = $("input[name='search']").val();
   	 	if ( $('#location_id').length != 0 )
 		  {
   	 		$("#location_id option:contains(" + capitalize(srchText) + ")").attr('selected', 'selected');
   	 	 }
   	 }
	})
});

function get_categories (loc, flg) {
	var url = '/categories.js?location=' + loc;
	process_url(url, flg);
}

function process_url (url, Slider) {
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
  				toggleLoading();	
  				if (Slider)
  					{ reset_slider(); }
  			}  
		});
}

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
     		process_url(url, false); 
     	}
     	else
     	{
 			// check channel page is current to call appropriate url
 			if ( $('.chanlist').length != 0 )
 				{
      				var Slider = false;
     				var catid = $('.active').attr('data-catid');
      				if (typeof catid === 'undefined') 
     						{ get_categories(loc, Slider) }
     				else
     						{ get_channels(catid, loc) }
  				}
 			else
 				{
 					var url = '/events.js?location=' + loc;
 					var Slider = true;
 					process_url(url, Slider); 
 				}    		
     	}
     	
		return false;       
  })
});

// add accordion
$(function(){
  if ( $('#accordian').length != 0 ) {
  	$("#accordion").accordion({ collapsible: true });	
  }
});


// when the #start time field changes
$(function (){
  $("#start-time").live('change',function() {
     $("#end-time").val($(this).val());
  });
  
  $("#loc").live('click',function() {
    $(this).text($(this).text() == 'Add Location' ? $('.ev-loc').show('fast') : $('.ev-loc').hide('fast') );
    $(this).text($(this).text() == 'Add Location' ? 'Hide Location' : '+ Add Location');
  });   
});

// check if reminder checkbox is selected
$(function (){
	$('#remflg').bind('change', function () {

		if ($(this).attr("checked"))
		  { $("#reminder-type").show('fast'); }      		
   		else
      	  { $("#reminder-type").hide('slow'); }
	});
});