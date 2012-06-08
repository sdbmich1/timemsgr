/**
 * @author Sean Brown
 */
$(document).bind("mobileinit", function(){
	// set ajax to false
	$.extend(  $.mobile, { ajaxFormsEnabled: false });
				
	//reset type=date inputs to text
   	$.mobile.page.prototype.options.degradeInputs.date = true;
   	
   	// hide toolbars
   	$("#app").live('pageshow', function(event) {
       $.mobile.fixedToolbars.hide(true)
	});

   	
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

$(document).bind("pageinit", function(){
    $("#mform label").inFieldLabels();
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
	 