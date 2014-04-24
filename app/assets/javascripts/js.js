$(document).ready(function(){
$(function() {
 BV = new $.BigVideo({
		useFlashForFirefox:false,
		});
    BV.init();
       BV.show('video/first.webm', {altSource:'video/first.ogv'}, {ambient:true});
    BV.getPlayer().pause();
});
	/*/ RESIZE BUILD
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
*/

	// FLOOR CONTROL
	$(".floor-control ul li a")
	.mouseover(function(){
		var curFloor = parseInt($(this).attr("dataid"));
		$("#floor-"+curFloor).addClass("active");
	})
	.mouseout(function(){
		$(".floor").removeClass("active");
	});
	
	// FLOOR CONTROL
	$(".floor-control-2 ul li a")
	.mouseover(function(){
		var curFloor = parseInt($(this).attr("dataid"));
		$("#inset-floor-"+curFloor).addClass("active");
	})
	.mouseout(function(){
		$(".floor-2").removeClass("active");
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
	// Index link 

	$("#concept_link")
	.mouseover(function(){
		$("#header .menu li.icon-1 span").css('background-position', '0 -60px');
		$("#header .menu li.icon-1 a").css('color', '#fff');
	})
	.mouseout(function(){
		$("#header .menu li.icon-1 span").css('background-position', '');
		$("#header .menu li.icon-1 a").css('color', '');
	});

	$("#gallery_link")
	.mouseover(function(){
		$("#header .menu li.icon-5 span").css('background-position', '0 -60px');
		$("#header .menu li.icon-5 a").css('color', '#fff');
	})
	.mouseout(function(){
		$("#header .menu li.icon-5 span").css('background-position', '');
		$("#header .menu li.icon-5 a").css('color', '');
	});

	$("#floorplans_link")
	.mouseover(function(){
		$("#header .menu li.icon-3 span").css('background-position', '0 -60px');
		$("#header .menu li.icon-3 a").css('color', '#fff');
	})
	.mouseout(function(){
		$("#header .menu li.icon-3 span").css('background-position', '');
		$("#header .menu li.icon-3 a").css('color', '');
	});

	$("#service_link")
	.mouseover(function(){
		$("#header .menu li.icon-4 span").css('background-position', '0 -60px');
		$("#header .menu li.icon-4 a").css('color', '#fff');
	})
	.mouseout(function(){
		$("#header .menu li.icon-4 span").css('background-position', '');
		$("#header .menu li.icon-4 a").css('color', '');
	});

	// callback
	$('.callback a').click(function(){
		$(".callback-wrapper").show();
		return false;
	});
	
	$('.callback-shadow').click(function(){
		$(".callback-wrapper").hide();
	});

	$('.buy-shadow').click(function(){
		$(".buy-wrapper").hide();
	});

	$('.sale-wrapper').click(function(){
		$(".callback-wrapper").show();
		return false;
	});

	$('#order-apart').click(function(){
		$(".buy-wrapper").hide();
		$(".callback-wrapper").show();
		return false;
	});
	$('#cancel_button').click(function(){
		$(".callback-wrapper").hide();
	});
	
});
