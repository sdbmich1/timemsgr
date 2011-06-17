/**
 * @author Sean Brown
 */
// add slider to display list of upcoming events
$(document).ready(function() {
    $(".tmp-slider").jCarouselLite({
        btnNext: ".next",
        btnPrev: ".prev"
    });
    $(".obsrv-slider").jCarouselLite({
        btnNext: ".next-btn",
        btnPrev: ".prev-btn"
    });
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