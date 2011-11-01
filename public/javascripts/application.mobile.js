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
	 