/**
 * @author Sean Brown
 */
// add slider to display list of upcoming events
$(function() {
	event_slider();
	
    // Used to change list of events to display by date range
	$('.select-date').click(function() { 		
		var enddate = this.getAttribute("data-numdays");
		$.ajax({
  			url: '/events.js?end_date=' + enddate,
  			dataType: 'script',
  			success:  function() {
  				event_slider(); 
    		}
		});
		return false;  
	});	
});

function count_items (cname) {
	var count = $(cname).find("ul").children("li").size();
	if (count < 3) {
		return count;
		}
	else {
		return 3;
		}			
}

function event_slider () {
    $(".mobile-slider").jCarouselLite({
		visible: count_items(".mobile-slider"),
		vertical: true,
   		auto: 800,
    	speed: 1000,
        btnNext: ".next",
        btnPrev: ".prev"
    });    
}

$(function() {
  $('#my-link').click(function(event){
	history.back(); 
	return false
  });
})

$(document).bind("mobileinit", function() {
      $.mobile.page.prototype.options.addBackBtn = true;
 });