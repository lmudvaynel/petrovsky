function reset_animation(){
  $.cookie('number',0);
  $.cookie('timer',1500);
}
// place this before all of your code, outside of document ready.

$.fn.clicktoggle = function(a,b){
    return this.each(function(){
        var clicked = false;
        $(this).bind("click",function(){
            if (clicked) {
                clicked = false;
                return b.apply(this,arguments);
            }
            clicked = true;
            return a.apply(this,arguments);
        });
    });// fixed typo here, was missing )
};
$( window ).resize(function() {
	var wWidth=$(window).width()
	wLeft=(wWidth/100)*21
	console.log(wWidth)
	$('.house-image-container').find('.floor_number').each(function() {
		if ($(this).hasClass('n_6'))
			{$(this).css('left', wLeft-226+40	+ 'px');}
		else
			{$(this).css('left', wLeft	+ 'px');}
	});
	$('.house-image-container-2').find('.floor_number').css('left', wLeft	+ 'px');
});
$(document).ready(function(){
  	$('#canvas-container').on('mouseover', '.apartment-element', function (event) {
      $(this).addClass('current');
	  	$('.apartment-element').stop().each(function() {
				if (!$(this).hasClass('current'))
					{$(this).animate({opacity: 0}, 300);}
				else
					{$(this).animate({opacity: 1}, 300);}
			});
    });
    $('#canvas-container').on('mouseout', '.apartment-element', function (event) {
      $(this).removeClass('current');
      $('.apartment-element').stop().each(function() {
				$(this).animate({opacity: 1}, 300);
			});
    });
	  $('#canvas-container').mouseenter(function () {
			$(this).find('.floor-element').mouseenter(function () {
				$('.apartment-element').stop().animate({opacity: 1}, 300);
			}).mouseleave(function () {
				$('.apartment-element').stop().each(function() {
  				if (!$(this).hasClass('current'))
  					{
  						$(this).animate({opacity: 0}, 300);}
				});
			});
	  });

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

$(window).on('load', function () {
		var timer;
    var $preloader = $('#page-preloader'),
    		$spinner   = $preloader.find('.spinner');
    $spinner.fadeOut();
    $svg = $('#svg')
    $("#svg").length==0 ? timer=10 : timer=1100
    $svg.delay(1500).fadeOut('slow')
    $preloader.delay(timer).fadeOut('slow');
});
	// FLOOR CONTROL
	$(".house-image-container .floor_number a")
	.mouseover(function(){
		var curFloor = parseInt($(this).attr("dataid"));
		$("#floor-"+curFloor).addClass("active");
	})
	.mouseout(function(){
		$(".floor").removeClass("active");
	});
	
	// FLOOR CONTROL
	$(".house-image-container-2 .floor_number a")
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

	$("#dwn-link")
	.mouseover(function(){
		$(".concept_content .presentation .present-icon").css('background-position', '0 0');
		$(".concept_content .presentation .content-link").css('color', '#757575');
	})
	.mouseout(function(){
		$(".concept_content .presentation .present-icon").css('background-position', '');
		$(".concept_content .presentation .content-link").css('color', '');
	});

	$("#maps-link")
	.mouseover(function(){
		$(".common-wrapper .map-btn-wrap .place-icon").css('background-position', '0 0');
		$(".common-wrapper .map-btn-wrap .content-link").css('color', '#757575');
	})
	.mouseout(function(){
		$(".common-wrapper .map-btn-wrap .place-icon").css('background-position', '');
		$(".common-wrapper .map-btn-wrap .content-link").css('color', '');
	});

	// Map and bg

	$("#maps-link").clicktoggle(
		function() {
			$( "#bg-place" ).fadeOut();
			$( "#map" ).fadeIn();
			$( ".shadow-text" ).addClass( "bounce" );
		  $(this).text('Скрыть карту');
		},
		function() {
			$( "#bg-place" ).fadeIn();
			$( "#map" ).fadeOut();
			$( ".shadow-text" ).removeClass( "bounce" );
		  $(this).text('Посмотреть на карте');
		});
	// callback
	$('.callback a').click(function(){
		$(".callback-wrapper").show();
		return false;
	});

	$('.action-call').click(function(){
		$(".action-wrapper").hide();
		$(".callback-wrapper").show();
		return false;
	});

	$('.callback-shadow').click(function(){
		$(".callback-wrapper").hide();
	});

	$('.callback-shadow').click(function(){
		$(".action-wrapper").hide();
	});

	$('.buy-shadow').click(function(){
		$(".buy-wrapper").hide();
		$(".buy-wrapper-sold").hide();
	});

	$('.sale-wrapper').click(function(){
		$(".action-wrapper").show();
		return false;
	});

	$('.order-apart').click(function(){
		$(".buy-wrapper").hide();
		$(".buy-wrapper-sold").hide();
		$(".callback-wrapper").show();
		return false;
	});
	$('#cancel_button').click(function(){
		$(".callback-wrapper").hide();
	});
	
});
