$(document).ready(function(){
	
	// RESIZE BUILD
	var bodyHeight = $(window).outerHeight(),
	contentHeight = $('#wrapper').outerHeight(),
	biuldHeight = $('.bg-item');

	if( bodyHeight > contentHeight ) {
		biuldHeight.css('height',bodyHeight);
	} else {
		biuldHeight.css('height',contentHeight);	
	}
	
	$(window).resize(function(){
		var bodyHeight = $(window).outerHeight(),
		contentHeight = $('#wrapper').outerHeight(),
		biuldHeight = $('.bg-item');
	
		if( bodyHeight > contentHeight ) {
			biuldHeight.css('height',bodyHeight);
		} else {
			biuldHeight.css('height',contentHeight);	
		}
	});

	// FLOOR CONTROL
	$(".floor-control ul li a")
	.mouseover(function(){
		var curFloor = parseInt($(this).attr("dataid"));
		$("#floor-"+curFloor).addClass("active");
	})
	.mouseout(function(){
		$(".floor").removeClass("active");
	});
	
	// TAB
	$(".tab-control a").click(function(){
		var curTab = $(this).attr('rel');
		
		$(".tab-control a").removeClass("current");
		$(this).addClass("current");
		
		$("#tab .tab-item").removeClass("current");
		$("#tab").find("#"+curTab).addClass("current");
		return false;
	});
	

});
