/**
 * @author Sean Brown
 */
$(document).bind("mobileinit", function(){
	// set ajax to false
	$.extend(  $.mobile, { ajaxFormsEnabled: false });
		
	// keeps my page transitions from "jumping" 
	$.extend($.mobile, {
		metaViewportContent: "width=device-width, minimum-scale=1, maximum-scale=1"
	});
		
	//reset type=date inputs to text
   	$.mobile.page.prototype.options.degradeInputs.date = true;
   	
   	// hides the date time as soon as the DOM is ready
    $('#timebox').hide();
    
 	// shows the date & time fields on clicking the checkbox  
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
  	
  $('#dialoglink').live('vclick', function() {
    $(this).simpledialog({
    'mode' : 'bool',
    'prompt' : 'Got Here?',
    'buttons' : {
      'Yes': {
        click: function () {
          $('#dialogoutput').text('Yep');
        }
      },
      'No': {
        click: function () {
          $('#dialogoutput').text('Nah');
        },
        icon: "delete",
        theme: "c"
      }
    }
   })
 })
  	    	 	 
});
	 