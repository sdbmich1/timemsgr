var map;
var selectedLocation;
var myLocation;
var directionsDisplay;
var directionsService;

// initialize google map
function NewInitialize(lat,lng, showMkr) {
  directionsService = new google.maps.DirectionsService();	
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

// detect browser to set map layout
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
  		if ( !isNaN(lat) ) {
  			var lng = parseFloat(lnglat.split(', "')[1].split('"]')[0]); 
  		} 	
  		else {
  			lat = parseFloat(lnglat.split(', ')[0].split('[')[1]);
  			var lng = parseFloat(lnglat.split(', ')[1].split(']')[0]);  	
  		}  			
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
    	  if ( $('#mode').length != 0 ) 
    	  	{ var selectedMode = $('#mode').val(); }
    	  else 
    	  	{ var selectedMode = 'DRIVING'; }

          var request = {origin: myLocation, destination: selectedLocation, travelMode: google.maps.TravelMode[selectedMode] };        
          directionsService.route(request, function(response, status) {
    			if (status == google.maps.DirectionsStatus.OK) 
    				{ directionsDisplay.setDirections(response); }       	
       			});       	
       	} 
    }, 
    function(error){ // geoError
  		alert('error: ' + error.message + '\n' + 'code: ' + error.code);
    }, geoOptions);  
      
}

function calcRoute() {
  getLatLng(false);  // get longitude & latitude of destination
  getMyLocation(true, false);  // get user location 
}

function getDirections() {
	$('#directionsPanel').empty();
	directionsDisplay.setPanel(document.getElementById("directionsPanel"));	
}


