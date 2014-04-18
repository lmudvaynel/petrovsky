function start_video () {
	$('#wrapper').hide();
	$('.place').hide();
	$('#big-video-wrap ').show();
	BV.getPlayer().currentTime(0);
	BV.getPlayer().play();
	setTimeout(function(){
	  $('#wrapper').show();
	  $('.place').show();
	  BV.getPlayer().pause();
	  BV.getPlayer().currentTime(0);
	 	$('#big-video-wrap ').hide();
	}, 1150)
}
$(document).ready(function(){
$(function() {
 BV = new $.BigVideo({
		useFlashForFirefox:false,
		});
    BV.init();
    BV.show('video/first.mp4', {ambient:true});
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
