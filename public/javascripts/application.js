// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({  
    'beforeSend': function (xhr) {
//    	xhr.setRequestHeader("Accept", "text/javascript");
    	var token = $("meta[name='csrf-token']").attr("content");
		xhr.setRequestHeader("X-CSRF-Token", token);
    },
  	'complete': function(){ },
  	'success': function() {}
}); 

function toggleLoading () { 
	$("#spinner").toggle(); 
}

// add spinner to ajax events
$(document).ready(function() {
  $("#map, #cal-btn, #connect_btn, #search_btn, #notify_form, #schedule_btn, #import_form, #rel_id, #chlist_btn, #edit_btn, #subscribe_btn, #unsub_btn, #remove_btn")
    .live("ajax:beforeSend", toggleLoading)
    .live("ajax:complete", toggleLoading)
    .live("ajax:success", function(event, data, status, xhr) {
      $("#response").html(data);
      toggleLoading();
    });
}); 

$(function (){ 
	
  // add date picker code and synch start & end dates
  if ( $('#start-date').length != 0 ) {

  	var dateFormat = "mm/dd/yy";
	
	$('#start-date').datepicker({ 
 	  minDate:'-0d',
      dateFormat:dateFormat,
      buttonImage: '/images/date_picker1.gif', 
      buttonImageOnly: true, 
      showOn: 'button',
      onSelect: function (dateText, inst) { 
          var nyd = $.datepicker.parseDate(dateFormat,dateText);
          $('#end-date').datepicker("option", 'minDate', nyd ).val($(this).val());          
  	 	  $('#reoccur-dt').datepicker("option", 'minDate', nyd ).val(set_reoccur_date($(this).val()));
      }, 
      onClose: function (dateText, e) { $(this).focus() } 
  	 }).change(function () {  
  	 	$('#end-date').val($(this).val());
 	 	$('#reoccur-dt').val(set_reoccur_date($(this).val()));
    }); 
  
    $('#end-date, #reoccur-dt').datepicker({ 
      onClose: function () { $(this).focus(); }, 
 	  minDate: '-0d',
      dateFormat:dateFormat,
      buttonImage: '/images/date_picker1.gif', 
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

// when the #event type field changes
$(function (){
  $("select[id*=event_type]").live('change',function() {
    var etype = $(this).val().toLowerCase();
	chkAnnualEvent(etype);
   });
});

$(document).ready(function() {
  if ( $('#mform label').length != 0 ) {
    $("#mform label").inFieldLabels();
  }
  
  // full calendar display
  var calndr = $('#calendar').fullCalendar({
    // put your options and callbacks here
  	header: {
		left:   'today',
    	center: 'prev title next',
    	right:  'agendaDay,agendaWeek,month'  		
//    	right:  'basicDay,basicWeek,month'  		
  	},
  	eventSources: [
  		{
  			url: 	'/calendars.json',
        }
  	],
  	endParam: 'enddt',
	eventRender: function(event, element) {
        element.attr("description",event.bbody)
    }, 
    dayClick: function(date, allDay, jsEvent, view) {
        calndr.fullCalendar('gotoDate', date);
        calndr.fullCalendar( 'changeView', 'agendaDay' );       
    },
	loading: function(bool){
        if (bool) 
            toggleLoading();
        else 
            toggleLoading();
    }      	 
  })
});
  
$(function () {
  $("#ev-results .pagination a, #past_evnt .pagination a, #event_form .pagination a, #sub-list .pagination a, #channel_form .pagination a, #notice_list .pagination a, #pres-list .pagination a, #sess-list .pagination a")
  	.live('click', function () {
//   $("[id*=pagination]").live('click', function () {
         $.getScript(this.href);
         return false;   
   });
});

function chkAnnualEvent(etype) {
  if(etype == "anniversary" || etype == "birthday")
      { 
      	$('#end-dt, #enddt, #stime').hide('fast');  
		if ($('#annual').length != 0) {  $('#annual').prop("checked", true); }
  		if ($('#annualflg').length != 0) { $('#annualflg').attr("checked", true).checkboxradio('refresh'); }
  		
  		// set time for web app
  		var sdt = $("#start-time").prop('selectedIndex', 0).val();  
  		var edt = $("#end-time").prop('selectedIndex', 287).val();  

  		$("#start-time").val(sdt);
  		$("#end-time").val(edt);
  		
  		// set time for mobile device
  		$('#start-tm').val('12:00 AM');
  		$('#end-tm').val('11:59 PM');
      }
  else
      { 
      	$('#end-dt, #enddt, #stime').show('fast'); 
		if ($('#annual').length != 0) {  $('#annual').prop("checked", false); }
  		if ($('#annualflg').length != 0) { $('#annualflg').attr("checked", false).checkboxradio('refresh'); }
  		$('#start-tm, #start-time').val('');
  		$('#end-tm, #end-time').val('');
	  }	
}

// close light box pop-up window
$(function () {
   $("#submit-btn, #notice-id").live('click', function () {
   	$.fancybox.close();
   });
});

$(function () {
  $(".notice_id").live('click',function() {
    var url = '/events/notice.js?';
    process_url(url, false);    
  })
  return false;
});

// process channel selection changes
$(function () {
  $(".channel_menu").live('click',function() {
    var intid = $(this).attr("data-intid");
    var loc = $('#location_id').val();
    var url = '/select.js?location=' + loc + "&interest_id=" + intid;
    
    $('ul.menu li ul li a').css('background-color', '#ccc');
	$(this).css('background-color', '#C2E1EF');
	
    process_url(url, false);    
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
   $(".add_prv_btn").live('click', function () {
	 $('ul.menu li a').css('background-color', '#0C6FCB');
	 $('.prv_btn').css('background-color', '#f08103');
	});
	
   $(".add_soc_btn").live('click', function () {
	 $('ul.menu li a').css('background-color', '#0C6FCB');
	 $('.soc_btn').css('background-color', '#f08103');
	});	
	
   $(".add_ext_btn").live('click', function () {
	 $('ul.menu li a').css('background-color', '#0C6FCB');
	 $('.ext_btn').css('background-color', '#f08103');
	});	
});

$(document).ready(function() {
  	$(".all_btn, .def_btn").css('background-color', '#f08103');
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
   	 	if ( $('#location_id').length != 0 && srchText.length != 0 )
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
$(document).ready(function() {
	set_accordion(0);
});

function set_accordion(element) {
  if ( $('#accordion').length != 0 ) {
 	$("#accordion").accordion({ active: element, collapsible: true, header: '.clicker', clearStyle: true });	
  }		
}


// when the #start time field changes by toggling select index on web app
$(function (){
  $("#start-time").live('change',function() {
  	var idx = this.selectedIndex + 12;  
  	if (idx > 287) {idx -= 288}     
    var edt = $("#end-time").prop('selectedIndex', idx).val();  
    $("#end-time").val(edt);
  });
  
  $("#loc").live('click',function() {
    $(this).text($(this).text() == '+ Add Location' ?  $('.ev-loc').show('fast') : $('.ev-loc').hide('fast') );
    $(this).text($(this).text() == '+ Add Location' ? '- Hide Location' : '+ Add Location');
  });   
});

// check if reminder checkbox is selected
$(function (){
	$('#remflg').live('change', function () {
		if ($(this).attr("checked"))
		  { $("#reminder-type").show('fast'); }      		
   		else
      	  { $("#reminder-type").hide('slow'); }
	});
});

// autocomplete 
$(document).ready(function() {	
	$('.query').live('keyup', function (e, ui) {
		 var nxtID = $(this).next();
 		 var text = $(this).val();
		 if(text.length < 3) {
 		 	$(nxtID).html("");
 		 	$(nxtID).hide('fast');
  		 }
 		 else {
		 	$.get("/suggestions.js", {search:text}, function(res,code) {
 		 		var str = "";
 		 		for(var i=0, len=res.length; i<len; i++) {
                    str += "<li><a href='#'>"+res[i]+"</a></li>";
                }
                $(nxtID).html(str);
 		 		$(nxtID).show('fast');
 		 	},"json");
 		 }
  	}); 
});

// check for map functions
$(document).ready(function() {	
  if ( $('#map_canvas').length != 0 ) {  
	getLatLng(true);
  }

  if ( $('#map_details').length != 0 ) {   
  	calcRoute();
  }
});

// check for travel mode changes
$("#mode").live("change", function() {
	calcRoute();
});

// check for directions display
$("#map").live("click", function() {
	$('#trvlmode').show('fast');
	toggleLoading();
});

// check for directions request
$(".map-btn").live("click", function() {
    var loc = $('.loc').attr('data-loc');
    var title = $('.loc').attr('data-title');
	var lnglat = $('.lnglat').attr("data-lnglat");
  	var url = '/directions?loc=' + loc + "&lnglat=" + lnglat + "&title=" + encodeURIComponent(title) + "&mode=" + mode;
	process_url(url, false);  	
});

// check for text display toggle
$("#more-btn").live("click", function() {
	$('#edetails').hide('fast');
	$('#fdetails').show('fast') 
});	

// check for category changes
$("#etype").live("change", function() {
  var etype = $(this).val();
	
  chkAnnualEvent(etype);
});

// set end time for private/life events
function set_end_time(starttime) {
  var parts = starttime.split(':'); 
  var ampm = parts[1].split(' ');
  
  if (parts[0][0] == '0') 
  	{var hour = parseInt(parts[0][1]);}
  else 
  	{var hour = parseInt($.trim(parts[0]));}

  // set hour based on time of day
  if(hour == 11) 
    { 
  	  if(ampm[1] == 'AM') { ampm[1] = 'PM'; }
	  else { ampm[1] = 'AM'; }
  	}
  
  // adjust hour for 12 hour day
  if(hour == 12) { hour -= 12; }
  
  // increment end time by one hour
  hour += 1;
  
  if(hour < 10) {hour = '0' + hour}
  var result = hour + ':' + ampm[0] + ' ' + ampm[1];
  return result 
}

function set_reoccur_date(startdt) {
  var newdt = new Date(startdt).add({months: 1});  
  return newdt.toString('MM/dd/yyyy')
}

  // check for reoccurrence type change
$(function (){
  $("#reoccur-type").live("change", function() {
	var rtype = $(this).val(); 
	if (rtype != 'once') 
	  { 
	  	if ($('#start-dt').length != 0) 
	  	  { setRecurEndDate(); }
	  	else 
	  	  { 
	  	  	var sdt = set_reoccur_date($('#start-date').val()); 
	  	  	$('#reoccur-dt').val(sdt);
	  	  }
	  	$('#reoccur').show('fast'); 
	  }
	else 
	  { 
	  	$('#reoccur').hide('fast'); 
	  }  
  });
});

// check for google import
$(document).ready(function() {	
  $("#googlebtn").live("click", function() {
    var uid = $('#email').val();
    var pwd = $('#password').val();
    
    if ($('imp-item').length == 0)
  	  { 
  	  	var url = '/gcal_import?uid=' + uid + "&pwd=" + pwd; 
  	  	process_url(url);
  	  }
  	  
    //prevent the default behavior of the click event
    return false;
  });
    
});