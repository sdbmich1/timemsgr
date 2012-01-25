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
				reset_slider();
    		}
		});
		return false;  
	});		
	
	$('a[data-method="post"]').live('ajax:success', function(){
		reset_slider();
	});

});

function reset_slider () {
	event_slider();
	resizeFrame();
}

function reset_css () {
	$(".opp-slider, .appt-slider, .sch-slider, .sub-slider").css({height: "150px"});	
}

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
		auto: 60000,
    	speed: 1000,
    	scroll: 3, 
        btnNext: ".next",
        btnPrev: ".prev"
    });
    $(".appt-slider").jCarouselLite({
		visible: count_items(".appt-slider"),
        btnNext: ".next-btn",
        btnPrev: ".prev-btn"
    });   
    $(".sub-slider").jCarouselLite({
		visible: count_items(".sub-slider"),
        btnNext: ".next-btn",
        btnPrev: ".prev-btn"
    });
    $(".sch-slider").jCarouselLite({
		visible: count_items(".sch-slider"),
        btnNext: ".sch-next-btn",
        btnPrev: ".sch-prev-btn"
    });  
    $('#js-news').ticker({
    	titleText: 'Observances & Milestones',
    	displayType: 'fade'
    });
}

jQuery.event.add(window, "load", resizeFrame);
jQuery.event.add(window, "resize", resizeFrame);

function resizeFrame() 
{
    var h = $(window).height();
    var w = $(window).width();
        $(".left-nav").css('left',(w < 1024 || h < 768) ? 150 : (w > 1400) ? 250 : 350 );
        $(".right-nav").css('right',(w < 1024 || h < 768) ? 50 : (w > 1400) ? 150 : 200 );
		$(".push").css('margin-top', function() {
	  		   var c = $(".container").height();
			   return c + 20;
		});
		
	reset_css();
}

$(function() {
	 $(".opp-slider li").draggable({
			appendTo: "body",
			helper: "clone"
		});
		
		$( ".sch-slider .eslide li" ).droppable({
			activeClass: "ui-state-default",
			hoverClass: "ui-state-hover",
			drop: function( event, ui ) {
				var eid = $(ui.draggable).find(".eid").attr("data-eid");
     			var sdt = $(ui.draggable).find(".sdt").attr("data-sdt");
   				var etype = $(ui.draggable).find(".etype").attr("data-etype");
    			$.ajax({
  						url: '/scheduled_events.js?sdate=' + sdt + "&id=" + eid + '&etype=' + etype,
  						type: 'POST',
  						dataType: 'script',
  						success:  function() {  				
							reset_slider();
    					}
				});
			}
		});
	});