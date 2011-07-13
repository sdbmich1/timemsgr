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

function event_slider () {
    $(".opp-slider").jCarouselLite({
        btnNext: ".next",
        btnPrev: ".prev"
    });
    $(".obsrv-slider").jCarouselLite({
        btnNext: ".next-btn",
        btnPrev: ".prev-btn"
    });
    $(".sch-slider").jCarouselLite({
        btnNext: ".sch-next-btn",
        btnPrev: ".sch-prev-btn"
    });	
}