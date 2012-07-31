/**
 * @author Sean Brown
 */
$(document).bind("mobileinit", function(){
	// set ajax to false
//	$.extend(  $.mobile, { ajaxFormsEnabled: false });
				
	//reset type=date inputs to text
   	$.mobile.page.prototype.options.degradeInputs.date = true;
   	
   	// hides the date time as soon as the DOM is ready
    $('#timebox').hide();
    
 	// shows the date & time fields on clicking the check box  
  	$('#freq').click(function() {
	
		// If checked
		if ($("#freq").is(":checked"))
			{
    			$('#timebox').show('slow');
    			return false;
    		}
    	else
    		{
    			$('#timebox').hide('fast');
    			return false;
    		}
  	});
 	 
});

// hide toolbars
$(document).bind('pageshow', function(event) {
     $.mobile.fixedToolbars.hide(true)
});
	
$('#formapp').bind('pageshow', function() {
    $($('.ui-page-active form :input:visible')[0]).focus();
});

// check for location changes
$("#loc_id").live("change", function() {
    var loc = $(this).val().toLowerCase(); // grab the selected location 
    
    if ( $('#cat_id').length != 0 )
      { var url = '/categories.mobile?location=' + loc; }
	else
  	  { var url = '/nearby_events.mobile?location=' + loc; }    		

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

$(function() {    
  $("#rflg").live('click',function() {
    $(this).text($(this).text() == '+ Add Reminder' ? $('#reminder-type').show('fast') : $('#reminder-type').hide('fast'));    
    $(this).text($(this).text() == '+ Add Reminder' ? $('#remflg').val('yes') : $('#remflg').val('no') );
    $(this).text($(this).text() == '+ Add Reminder' ? '- Remove Reminder' : '+ Add Reminder');
  });     
}); 

// used to toggle visible search bar
$(function() {    
  $(".srchflg").live('click',function() {
	$('.evsearch').toggle();
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
    // Set a timeout...
    setTimeout(function () {
        // Hide the address bar!
        window.scrollTo(0, 1);
    }, 0);
  });  

// toggle location selectmenu after search by city
function matchLocation() {
	var srchText = $('.srchText').attr("data-query");
	if ( $('#loc_id').length != 0 && srchText.length != 0 )
 		  {
   	 		var tmp = $("#loc_id option:contains(" + capitalize(srchText) + ")").val();
   	 		$("#loc_id option[value='" + tmp + "']").attr('selected', 'selected');
   	 	  }	
}

// set enddate to startdate
function dooffset() { 
  var startdate = $('#start-dt').val();  
  $('#end-dt').val(startdate); 
  $('#end-dt').trigger('datebox', {'method':'doset'});
}

// set endtime to start time
function dotimeoffset() { 
  var starttime = $('#start-tm').val();  
  $('#end-tm').val(starttime); 
  $('#end-tm').trigger('datebox', {'method':'doset'});
}

var map;
var selectedLocation;
var myLocation;
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();

// initialize google map
function NewInitialize(lat,lng, showMkr) {
  directionsDisplay = new google.maps.DirectionsRenderer();
  selectedLocation = new google.maps.LatLng(lat,lng);
  var myOptions = {
	zoom: 16,
	center: selectedLocation,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
	zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.LEFT_TOP
    }
  } 
  	
  if ( $('#map_canvas').length != 0 ) {
	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	directionsDisplay.setMap(map);
	
	if ( $('#directionsPanel').length != 0 ) {
		getDirections();
	 }

	if (showMkr) {
 	  var marker = new google.maps.Marker({
        position: selectedLocation,
        map: map
      }); 
    }  
  }
  else 
  	{ alert('no canvas'); }
  	
}

function detectBrowser() {
  var useragent = navigator.userAgent;
  if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1 ) {
	$('.ui-page').css('height', '480px!important'); 
	} 
  else {
	$('#map_canvas').css('width', '600px');
	$('#map_canvas').css('height', '800px');
	}
};

// get longitude & latitude
function getLatLng(showMkr) {
  if ( $('.lnglat').length != 0 ) {
	var lnglat = $('.lnglat').attr("data-lnglat");
	if ( lnglat != 'undefined' ) {
  		var lat = parseFloat(lnglat.split(', ')[0].split('["')[1]);
  		var lng = parseFloat(lnglat.split(', "')[1].split('"]')[0]);  		
  		NewInitialize(lat,lng, showMkr); // get position
	}
  } 
}

function getMyLocation(dFlg, nearby) {
  var geoOptions = {maximumAge: 60000, enableHighAccuracy: true, timeout: 20000 };  
  navigator.geolocation.getCurrentPosition(function(position){ // geoSuccess
       myLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
       
       if (nearby) {
       	  	var url = '/nearby_events.mobile?loc=' + myLocation;

			// change the page
			window.location.href= url;
       }
       
       // check for directions
       if (dFlg) {     	
  			var selectedMode = $('#mode').val(); 
        	var request = {origin: myLocation, destination: selectedLocation, travelMode: google.maps.TravelMode[selectedMode] };
        
        	directionsService.route(request, function(response, status) {
    			if (status == google.maps.DirectionsStatus.OK) 
    				{ directionsDisplay.setDirections(response); }       	
       			});       	
       	} 
    }, 
    function(error){ // geoError
     		navigator.notification.alert('error: ' + error.message + '\n' + 'code: ' + error.code);
    }, geoOptions);  
      
}

function calcRoute() {
  getLatLng(false);  // get longitude & latitude of destination
  getMyLocation(true, false);  // get user location 
}

// check for travel mode changes
$("#mode").live("change", function() {
	calcRoute();
});

function getDirections() {
	$('#directionsPanel').empty();
	directionsDisplay.setPanel(document.getElementById("directionsPanel"));	
}

$(".nearby").live("click", function() {
  	getMyLocation(false, true);  // get user location

    //prevent the default behavior of the click event
    return false;  
});

// check for category changes
$(".details").live("click", function() {
    var loc = $('.loc').attr('data-loc');
    var title = $('.loc').attr('data-title');
  	var mode = $('#mode').val();
	var lnglat = $('.lnglat').attr("data-lnglat");
  	var url = '/details.mobile?loc=' + loc + "&lnglat=" + lnglat + "&title=" + encodeURIComponent(title) + "&mode=" + mode;
  	
	// change the page
	window.location.href= url;

    //prevent the default behavior of the click event
    return false;
});

$(".loadmore").live("click", function() {
    var page_num = $('.viewmore').attr('data-page') + 1;
	alert('page = ' + page_num);
    $.get('categories.js?page=' + page_num, function (data) {
        $('#moblist > li.viewmore').remove();
        $('#moblist').append(data);
    });
}); 

// select autocomplete text
$(document).ready(function() {	
  $('.suggestions').delegate('li', 'click', function() {
	var selectedText = $(this).text(); // grab the selected text
    $(this).parent().prev().val(selectedText);
    $('.suggestions').html("").hide('fast');
  });
});
