/**
 * @author Sean Browm
 */
$(document).ready(function () {  
  	var timerId = 0;
	var qtimerId = 0;

	$('#events').each(function() {
    	timerId = setInterval(function(){
      		$.ajax({ url: "/events/clock", type: "GET", dataType: "script"
    		});
  		}, 60000 );
	});	
	
 	$('#quotes').each(function() {
    	qtimerId = setInterval(function(){
      		$.ajax({ url: "/events/getquote", type: "GET", dataType: "script"
    		});
  		}, 60000 );
	});		
	
	$('.show-item, .manage-item').click(function () {  
 		clearInterval(timerId);
 		clearInterval(qtimerId);
//    	return false;  
  	});   
  	
});