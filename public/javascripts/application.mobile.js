/**
 * @author Sean Brown
 */

jQuery('div').live('pagehide', function(event, ui){
  var page = jQuery(event.target);

  if(page.attr('data-cache') == 'never'){
    page.remove();
  };
});

// load for rails to handle non-GET HTTP requests
$.rails.href = function(element) {
  return element.data('href') || element.attr('href');
}

// set focus
$('#formapp').bind('pageshow', function() {
    $($('.ui-page-active form :input:visible')[0]).focus();
});

$(document).ready(function() {	
	
  // set checkbox	
//  $("input[type='checkbox']").checkboxradio();
 
  // toggle location dropdown text
  matchLocation();

  // check for location changes
  $("#loc_id").live("change", function() {
    var loc = $(this).val().toLowerCase(); // grab the selected location 
    
    if ( $('#cat_id').length != 0 )
      { var url = '/categories?location=' + loc; }
	else
  	  {	var url = '/nearby_events?location=' + loc; }    		

	// change the page
	goToUrl(url);

    //prevent the default behavior of the click event
    return false;
  });

  // check for category changes
  $("#cat_id").live("change", function() {
    var category = $(this).val(); // grab the selected location 
  	var loc = $('#loc_id').val();
  	var url = '/list?location=' + loc + "&category_id=" + category;
  	
	// change the page
	goToUrl(url);

    //prevent the default behavior of the click event
    return false;
  });
  
  // change page based on menu selection
  $("#menu_id").live("change", function() {
    var menu = $(this).val(); // grab the selected location 
   
    if ( menu.length != 0 ) {
    	switch(menu) {
    		case 'Home':
    			goToUrl('/events');
    			break;
    		case 'Menu': 
    			goToUrl('/home/user');
    			break;
    		case 'Website': 
    			var url = $('.ev-loc').attr('data-loc');
   				if ( url.length != 0 ) {	
					window.location.href= url;
   				}   
   				break; 	
   	 }
  }
  
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
  $("#srchflg").live('click',function() {
	$('.evsearch').toggle();
	if ($('.evsearch').is(':visible')) {
		if ($('.evloc').is(':visible')) {
		   $(".home-pg, .nearby-pg, .channelList").css('margin-top', '66px'); 
		  }
		else {
		   $(".home-pg, .nearby-pg, .channelList").css('margin-top', '35px'); 
		  }
	}
	else {
   		if ($('.evloc').is(':visible')) { 
		  $(".home-pg").css('margin-top', '31px'); }
		else {
		  $(".home-pg, .nearby-pg, .channelList").css('margin-top', 0);		
		}	
	}
  });   

  // used to toggle visible search bar
  $("#chgflg").live('click',function() {
	$('.evloc').toggle();
	if ($('.evloc').is(':visible')) {
		if ($('.evsearch').is(':visible')) { 
		  $(".home-pg").css('margin-top', '66px'); }
		else {
		  $(".home-pg").css('margin-top', '31px'); 	
		}
	}
	else {
		if ($('.evsearch').is(':visible')) { 
		  $(".home-pg").css('margin-top', '35px'); }
		else {
		  $(".home-pg").css('margin-top', 0); 	
		}
	}
  });   
}); 

// import events from 3rd party services
$(document).bind('pageinit', function() {

  $("#google-btn").live("click", function() {
    var uid = $('#email').val();
    var pwd = $('#password').val();
  	var url = '/gcal_import.mobile?uid=' + uid + "&pwd=" + pwd; 

	goToUrl(url);	
	return false;
  });

  $("#discount_btn").live("click", function() {
    var cd = $('#promo_code').val();
    if (cd.length > 0) 
    	uiLoading(true);  
  });
    
  $("#addEvent").live("click", function() {
  	var sdt = calndr.fullCalendar( 'getDate' );
  	var url = '/private_events/new.mobile?sdt=' + sdt; 

	goToUrl(url);	
	return false;
  });
  
  $("#cal-aday").live("click", function() {
    calndr.fullCalendar( 'changeView', 'agendaDay' );  
  });
  
  $("#cal-week").live("click", function() {
    calndr.fullCalendar( 'changeView', 'agendaWeek' );       
  });
  
  $("#cal-month").live("click", function() {
    calndr.fullCalendar( 'changeView', 'month' );       
  });    
  
  // check for category changes
  $(".details").live("click", function() {
    var loc = $('.loc').attr('data-loc');
    var title = $('.loc').attr('data-title');
    var id = $('.loc').attr('data-id');
    var eid = $('.loc').attr('data-eid');
    var etype = $('.loc').attr('data-etype');
    var sdt = $('.loc').attr('data-sdt');
	var lnglat = $('.lnglat').attr("data-lnglat");
  	var mode = $('#mode').val();
  	var url = '/details.mobile?loc=' + loc + "&lnglat=" + lnglat + "&title=" + encodeURIComponent(title) + "&mode=" + mode + "&id=" + id 
  		+ "&eid=" + eid + "&sdt=" + sdt + "&etype=" + etype;
  	
	// change the page
	window.location.href= url;

    //prevent the default behavior of the click event
    return false;
  });   
});

$('[data-role="page"]').live('pageshow', function () {
  
  // picture slider
  $('.bxslider').bxSlider({
  	minSlides: 4,
    maxSlides: 4,
    slideMargin:10,
    pager: false,
    mode: 'fade',
    captions: true 
  });	
  
  $(".bxslider div").each(function(){
	var sLink = $(this).find('a').attr('href');
	$(this).find('div').click(function(){
	//window.location = sLink;
	goToUrl(sLink);
	});
  });

  // full calendar display
  if ( $('#calendar').length != 0 ) {http://localhost:3000/system/photos/309/original/2241284-Hotel-Whitcomb-San-Francisco-Hotel-Exterior-16.jpg?1366671291
	showCalendar(false, true, (3).months().ago(), (12).months().fromNow(), '');
  }
  
  // show conference calendar
  if ( $('#eventcal').length != 0 ) {
  	showConfCalendar();
  }
  
  if ($('#pmtForm').length != 0 || $('#buyTxtForm').length != 0) {
  	uiLoading(false);
	payForm = getFormID('#payForm');		
  }  
  
  if ( $('#printable').length != 0 ) {
  	uiLoading(false);
  }
    
  // initialize infield labels
  if ( $('#mform').length != 0 ) {
    $("#mform label").inFieldLabels();
  }
    
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
  
// manage page splash for logos  
$(document).on('pageinit', '#splash', function() {

  $(function() {
  	setTimeout(hideSplash, 1000);
  });

  function hideSplash() {
   $.mobile.changePage("/apphome", { transition: "fade" });
  }  
});
  
// hide address bar 
  window.addEventListener("load", function () {
    setTimeout(function () {        
        window.scrollTo(0, 1); // Hide the address bar!
    }, 0);
  });  

function uiLoading(bool) {
  if (bool)
    $('body').addClass('ui-loading');
  else
    $('body').removeClass('ui-loading');
}

function goToUrl(url) {
	// window.location.href= url;
	$.mobile.changePage( url, { transition: "none", reverse: false, changeHash: false });
}

// toggle location selectmenu after search by city
function matchLocation() {
	var srchText = $('.srchText').attr("data-query");
	if (srchText !== undefined) {
	   if ( $('#loc_id').length != 0 && srchText.length != 0 )
 		  {
   	 		var tmp = $("#loc_id option:contains(" + capitalize(srchText) + ")").val();
   	 		$("#loc_id option[value='" + tmp + "']").attr('selected', 'selected');
   	 	  }	
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
 	
  	// get user location	  		
  	getMyLocation(false, true);   		

    //prevent the default behavior of the click event
    return false;  
  });
  
  $("#payForm").live("click", function() { 	
  	uiLoading(true);  	
    return false;  
  });
    
});


$(".loadmore").live("click", function() {
    var page_num = $('.viewmore').attr('data-page') + 1;
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
