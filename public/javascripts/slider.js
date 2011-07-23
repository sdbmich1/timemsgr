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
    $(".opp-slider").jCarouselLite({
		visible: count_items(".opp-slider"),
        btnNext: ".next",
        btnPrev: ".prev"
    });
    $(".obsrv-slider").jCarouselLite({
		visible: count_items(".obsrv-slider"),
        btnNext: ".next-btn",
        btnPrev: ".prev-btn"
    });
    $(".sch-slider").jCarouselLite({
		visible: count_items(".sch-slider"),
        btnNext: ".sch-next-btn",
        btnPrev: ".sch-prev-btn"
    });
}