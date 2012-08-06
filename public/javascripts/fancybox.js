
// add fancy box
$(document).ready(function() {

	/* This is basic - uses default settings */	
	$("a#single_image").fancybox();
	
	/* Using custom settings */	
	$("a#inline").fancybox({
		'hideOnContentClick': true
	});

	/* Apply fancybox to multiple items */
	$("a#modalGroup").fancybox({
    	'width'			:   '560',
    	'height'		: 	'340',
    	'autoscale'		:   true,
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	600, 
		'speedOut'		:	600, 
		'overlayShow'	:	true
	});	
	
	$('.show_event').bind('ajax:success', function() {
		$("#modalGroup").trigger('click');
	});
});

// close fancybox on ajax events
$(function (){ 

  $("#notify_btn")
    .bind("ajax:success", function(event, data, status, xhr) {
      parent.$.fancybox.close();
    });
}); 
