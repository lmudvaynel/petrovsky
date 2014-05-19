<script type="text/javascript">
  function fasad_to_2(){
    $('#floor-1').animate({ opacity: 0 }, 2000);
    $('#inset-floor-1').animate({ opacity: 1 }, 2000);
    $('#floor-2').animate({ opacity: 0 }, 2000);
    $('#inset-floor-2').animate({ opacity: 1 }, 2000);
    $('#floor-3').animate({ opacity: 0 }, 2000);
    $('#inset-floor-3').animate({ opacity: 1 }, 2000);
    $('#floor-4').animate({ opacity: 0 }, 2000);
    $('#inset-floor-4').animate({ opacity: 1 }, 2000);
    $('#floor-5').animate({ opacity: 0 }, 2000);
    $('#inset-floor-5').animate({ opacity: 1 }, 2000);
    $('#floor-6').animate({ opacity: 0 }, 2000);
    $('#inset-floor-6').animate({ opacity: 1 }, 2000);
    $('.fasad').animate({ opacity: 0 }, 2000);
    $('.fasad-2').animate({ opacity: 1 }, 2000);
    $('#house-image-container').removeClass('house-image-container');
    $('#house-image-container').addClass('house-image-container-2 ');
    $('.side-1').removeClass('current_fasad');
    $('.side-2').addClass('current_fasad');
    $('#wrapper').hide();
    $('.fasad-bg-wrap').hide();
    $('#big-video-wrap ').show();
    BV.getPlayer().currentTime(0);
    BV.getPlayer().play();
    setTimeout(function(){
      BV = new $.BigVideo({
        useFlashForFirefox:false,
      });
      BV.init();
      BV.show('video/second.webm', {altSource:'video/second.ogv'}, {ambient:true});
      BV.getPlayer().pause();
      $('#wrapper').show();
      $('.fasad-bg-wrap').show();
      BV.getPlayer().remove();
      $('#big-video-wrap ').hide();
    }, 2100);
    var wWidth=$(window).width()
    wLeft=(wWidth/100)*21
    console.log(wWidth)
    $('.house-image-container').find('.floor_number').each(function() {
      if ($(this).hasClass('n_6'))
        {$(this).css('left', wLeft-226+40 + 'px');}
      else
        {$(this).css('left', wLeft  + 'px');}
    });
    $('.house-image-container-2').find('.floor_number').css('left', wLeft + 'px');
    $(".house-image-container-2 .floor_number a")
      .mouseover(function(){
        var curFloor = parseInt($(this).attr("dataid"));
        $("#inset-floor-"+curFloor).addClass("active");
      })
      .mouseout(function(){
        $(".floor-2").removeClass("active");
      });
  };
  function fasad_to_1(){
    $('#floor-1').animate({ opacity: 1 }, 2000);
    $('#inset-floor-1').animate({ opacity: 0 }, 2000);
    $('#floor-2').animate({ opacity: 1 }, 2000);
    $('#inset-floor-2').animate({ opacity: 0 }, 2000);
    $('#floor-3').animate({ opacity: 1 }, 2000);
    $('#inset-floor-3').animate({ opacity: 0 }, 2000);
    $('#floor-4').animate({ opacity: 1 }, 2000);
    $('#inset-floor-4').animate({ opacity: 0 }, 2000);
    $('#floor-5').animate({ opacity: 1 }, 2000);
    $('#inset-floor-5').animate({ opacity: 0 }, 2000);
    $('#floor-6').animate({ opacity: 1 }, 2000);
    $('#inset-floor-6').animate({ opacity: 0 }, 2000);
    $('.fasad-2').animate({ opacity: 0 }, 2000);
    $('.fasad').animate({ opacity: 1 }, 2000);
    $('#house-image-container').removeClass('house-image-container-2');
    $('#house-image-container').addClass('house-image-container');
    $('.side-2').removeClass('current_fasad');
    $('.side-1').addClass('current_fasad');
    $('#wrapper').hide();
    $('.fasad-bg-wrap').hide();
    $('#big-video-wrap ').show();
    BV.getPlayer().currentTime(0);
    BV.getPlayer().play();
    setTimeout(function(){
      BV = new $.BigVideo({
        useFlashForFirefox:false,
      });
      BV.init();
      BV.show('video/first.webm', {altSource:'video/first.ogv'}, {ambient:true});
      BV.getPlayer().pause();
      $('#wrapper').show();
      $('.fasad-bg-wrap').show();
      BV.getPlayer().remove();
      $('#big-video-wrap ').hide();
    }, 2100);
      var wWidth=$(window).width()
      wLeft=(wWidth/100)*21
      console.log(wWidth)
      $('.house-image-container').find('.floor_number').each(function() {
        if ($(this).hasClass('n_6'))
          {$(this).css('left', wLeft-226+40 + 'px');}
        else
          {$(this).css('left', wLeft  + 'px');}
      });
      $('.house-image-container-2').find('.floor_number').css('left', wLeft + 'px');
      $(".house-image-container .floor_number a")
    .mouseover(function(){
      var curFloor = parseInt($(this).attr("dataid"));
      $("#floor-"+curFloor).addClass("active");
    })
    .mouseout(function(){
      $(".floor").removeClass("active");
    });
  };
</script>