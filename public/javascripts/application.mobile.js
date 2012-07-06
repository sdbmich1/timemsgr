/**
 * @author Sean Brown
 */
$(document).bind("mobileinit", function(){
	// set ajax to false
	$.extend(  $.mobile, { ajaxFormsEnabled: false });
				
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
    var url = '/categories.mobile?location=' + loc;  

	// change the page
	window.location.href= url;
    //$.mobile.changePage(url, { reloadPage : true });

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
function NewInitialize(lat,lng) {
  directionsDisplay = new google.maps.DirectionsRenderer();
  selectedLocation = new google.maps.LatLng(lat,lng);
  var myOptions = {
	zoom: 16,
	center: selectedLocation,
	mapTypeId: google.maps.MapTypeId.ROADMAP
  } 
  
  // determine browser type
  //detectBrowser();
	
  if ( $('#map_canvas').length != 0 ) {
	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	directionsDisplay.setMap(map);
 	var marker = new google.maps.Marker({
      position: selectedLocation,
      map: map
    });   
  }
  else 
  	{ alert('no canvas'); }
  	
}

function detectBrowser() {
  var useragent = navigator.userAgent;

  if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1 ) {
	$('.ui-page').css('height', '480px!important'); 
	$('.app-content ui-content').css('height', '480px!important'); 

	//$('#map_canvas').css('width', '320px');
	//$('.ui-content').css('height', '480px');
	} 
  else {
	$('#map_canvas').css('width', '600px');
	$('#map_canvas').css('height', '800px');
	}
};

function get_position(lat, lng) {
    
  // get user's current location 
  if(navigator.geolocation) {
     navigator.geolocation.getCurrentPosition(function(position){
       myLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
     })  }  		
  
  // get specified location 
  NewInitialize(lat,lng);
}

// get longitude & latitude
function getLatLng() {
  if ( $('.lnglat').length != 0 ) {
	var lnglat = $('.lnglat').attr("data-lnglat");
	if ( lnglat != 'undefined' ) {
  		var lat = parseFloat(lnglat.split(', ')[0].split('["')[1]);
  		var lng = parseFloat(lnglat.split(', "')[1].split('"]')[0]);  		
  		get_position(lat, lng); // get position
	}
  } 
}

function calcRoute() {
  var selectedMode = document.getElementById("mode").value;
  var request = {
      origin: myLocation,
      destination: selectedLocation,
      travelMode: google.maps.TravelMode[selectedMode]
  };
  
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
    }
  });
}