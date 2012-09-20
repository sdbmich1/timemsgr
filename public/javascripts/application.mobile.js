/**
 * @author Sean Brown
 */

jQuery('div').live('pagehide', function(event, ui){
  var page = jQuery(event.target);

  if(page.attr('data-cache') == 'never'){
    page.remove();
  };
});

// set focus
$('#formapp').bind('pageshow', function() {
    $($('.ui-page-active form :input:visible')[0]).focus();
});

$(document).ready(function() {	
	
  // set checkbox	
  $("input[type='checkbox']").checkboxradio();
  
  // toggle location dropdown text
  matchLocation();
  
  // check for location changes
  $("#loc_id").live("change", function() {
    var loc = $(this).val().toLowerCase(); // grab the selected location 
    
    if ( $('#cat_id').length != 0 )
      { var url = '/categories.mobile?location=' + loc; }
	else
  	  {	var url = '/nearby_events.mobile?location=' + loc; }    		

	// change the page
	window.location.href= url;

    //prevent the default behavior of the click event
    return false;
  });

  // check for category changes
  $("#cat_id").live("change", function() {
    var category = $(this).val(); // grab the selected location 
  	var loc = $('#loc_id').val();
  	var url = '/list.mobile?location=' + loc + "&category_id=" + category;
  	
	// change the page
	window.location.href= url;

    //prevent the default behavior of the click event
    return false;
  });
    
  // used to toggle reminder
  $("#rflg").live('click',function() {
    $(this).text($(this).text() == '+ Add Reminder' ? $('#reminder-type').show('fast') : $('#reminder-type').hide('fast'));    
    $(this).text($(this).text() == '+ Add Reminder' ? $('#remflg').val('yes') : $('#remflg').val('no') );
    $(this).text($(this).text() == '+ Add Reminder' ? '- Remove Reminder' : '+ Add Reminder');
  });  
  
  // used to toggle sponsor logos
  $("#close-btn").live('click', function() {
   	$("#sponsor-pg").hide();
   	$("#event-pg").show();
  });	 

  // used to toggle visible search bar
  $(".srchflg").live('click',function() {
	$('.evsearch').toggle();
	if ($('.evsearch').is(':visible')) {
		$(".home-pg, .nearby-pg, .channelList").css('margin-top', '35px');
	}
	else {
		$(".home-pg, .nearby-pg, .channelList").css('margin-top', 0);		
	}
  });   

}); 

// import events from 3rd party services
$(document).bind('pageinit', function() {
		
  $("#google-btn").live("click", function() {
    var uid = $('#email').val();
    var pwd = $('#password').val();
  	var url = '/gcal_import.mobile?uid=' + uid + "&pwd=" + pwd; 

  	$.mobile.changePage( url, { transition: "none", reload: true} ); 	  		
	return false;
  });
});
	  
  // add iphone orientation change handler
  $(function (){ 
    if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/Android/i)) {
        $(window).bind('orientationchange', function(event) {
            if (window.orientation == 90 || window.orientation == -90 || window.orientation == 270) {
                $('meta[name="viewport"]').attr('content', 'height=device-width,width=device-height,initial-scale=1.0,maximum-scale=1.0');
            } else {
                $('meta[name="viewport"]').attr('content', 'height=device-height,width=device-width,initial-scale=1.0,maximum-scale=1.0');
            }
        }).trigger('orientationchange');
    }	
  });
  
// hide address bar 
  window.addEventListener("load", function () {
    setTimeout(function () {        
        window.scrollTo(0, 1); // Hide the address bar!
    }, 0);
  });  

// toggle location selectmenu after search by city
function matchLocation() {
	var srchText = $('.srchText').attr("data-query");
	if ( $('#loc_id').length != 0 && (typeof srchText != 'undefined'))
 		  {
   	 		var tmp = $("#loc_id option:contains(" + capitalize(srchText) + ")").val();
   	 		$("#loc_id option[value='" + tmp + "']").attr('selected', 'selected');
   	 	  }	
}

// set enddate to startdate
function dooffset() { 
  var startdate = $('#start-dt').val();     
  var enddate = new Date(startdate);
  $('#end-dt').data('datebox').theDate = enddate;
  $('#end-dt').trigger('datebox', {'method':'doset'});
  setRecurEndDate();
}

// set endtime to start time + 1 hour
function dotimeoffset() { 
  var endtime = set_end_time($('#start-tm').val());
  $('#end-tm').val(endtime); 
  $('#end-tm').trigger('datebox', {'method':'set', 'value':endtime});
}

function setRecurEndDate() {
  var sdt = set_reoccur_date($('#start-dt').val()); 
  $('#reoccur-dt').val(sdt);
  $('#reoccur-dt').trigger('datebox', {'method':'set', 'value':sdt});	
}

$(document).ready(function() {	
  $(".nearby").live("click", function() {
  	getMyLocation(false, true);  // get user location

    //prevent the default behavior of the click event
    return false;  
  });
});

// check for category changes
$(".details").live("click", function() {
    var loc = $('.loc').attr('data-loc');
    var title = $('.loc').attr('data-title');
	var lnglat = $('.lnglat').attr("data-lnglat");
  	var mode = $('#mode').val();
  	var url = '/details.mobile?loc=' + loc + "&lnglat=" + lnglat + "&title=" + encodeURIComponent(title) + "&mode=" + mode;
  	
	// change the page
	window.location.href= url;

    //prevent the default behavior of the click event
    return false;
});

$(".loadmore").live("click", function() {
    var page_num = $('.viewmore').attr('data-page') + 1;
//	alert('page = ' + page_num);
    $.get('categories.js?page=' + page_num, function (data) {
        $('#moblist > li.viewmore').remove();
        $('#moblist').append(data);
    });
}); 

// select autocomplete text
$(document).ready(function() {	
  $('.suggestions li').live('click', function() {
	var selectedText = $(this).text(); // grab the selected text
    $(this).parent().prev().val(selectedText);
    $('.suggestions').html("").hide('fast');
  });
 
  $("#start-tm").live('change',function() {
     dotimeoffset();
  });
  
});
